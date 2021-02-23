import React, { useState, useMemo, useEffect } from 'react';
import { history } from 'umi';
import { Button, Divider, Input, Select, message } from 'antd';
import { RightOutlined } from '@ant-design/icons';
import { getAnonymousAccount, createMeeting } from '@/apis';
import Storage from '@/utils/storage';
import styles from './index.less';

const storage = Storage.getInstance('sessionStorage');

export default () => {
  const [step, setStep] = useState<'default' | 'join' | 'create' | 'created'>(
    'default',
  );
  const [accountId, setAccountId] = useState('');
  const [accountToken, setAccountToken] = useState('');
  const [subject, setSubject] = useState('');
  const [maxCount, setMaxCount] = useState<number | undefined>(undefined);
  const [nickName, setNickName] = useState('');
  const [meetingId, setMeetingId] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    getAnonymousAccount()
      .then(res => {
        setAccountId(res.ret.accountId);
        setAccountToken(res.ret.accountToken);
      })
      .catch(err => {
        message.error(err);
      });
  }, []);

  const onCreate = () => {
    if (!subject) {
      message.error('请输入课堂名');
      return;
    }
    if (!nickName) {
      message.error('请输入昵称');
      return;
    }
    if (!/^[\u4e00-\u9fa5\sa-zA-Z0-9]+$/.test(nickName)) {
      message.error('昵称只能填写中英文、数字和空格');
      return;
    }
    if (!maxCount) {
      message.error('请选择课堂类别');
      return;
    }
    setLoading(true);
    createMeeting({
      subject,
      maxCount,
      accountId,
      accountToken,
    })
      .then(res => {
        setMeetingId(res.ret.meetingId);
        setStep('created');
      })
      .catch(err => {
        message.error(err);
      })
      .finally(() => {
        setLoading(false);
      });
  };

  const onJoin = (roleType: number) => {
    if (!meetingId) {
      message.error('请输入您想要加入的课堂号');
      return;
    }
    if (!/^\d+$/.test(meetingId)) {
      message.error('会议号只能填写数字');
      return;
    }
    if (!nickName) {
      message.error('请输入昵称');
      return;
    }
    if (!/^[\u4e00-\u9fa5\sa-zA-Z0-9]+$/.test(nickName)) {
      message.error('昵称只能填写中英文、数字和空格');
      return;
    }
    storage.set('eduParams', {
      accountId,
      accountToken,
      meetingId,
      nickName,
      roleType,
    });
    history.push({
      pathname: '/classroom',
    });
    // joinMeeting({
    //   meetingId,
    //   nickName,
    //   roleType,
    //   accountId,
    //   accountToken,
    // })
    //   .then(() => {})
    //   .catch(err => {
    //     message.error(err);
    //   });
  };

  const defaultContent = useMemo(
    () => (
      <>
        <h1 className={styles.title}>智慧云课堂</h1>
        <div className={styles.actions}>
          <dl
            onClick={() => {
              setStep('join');
            }}
          >
            <dt>
              <img src={require('@/assets/join.png')} alt="" />
            </dt>
            <dd>加入课堂</dd>
          </dl>
          <dl
            onClick={() => {
              setStep('create');
            }}
          >
            <dt>
              <img src={require('@/assets/create.png')} alt="" />
            </dt>
            <dd>创建课堂</dd>
          </dl>
        </div>
        <Divider style={{ margin: '20px 0' }} />
        <Button
          href="http://yunxin.163.com/clauses"
          target="_blank"
          className={styles.tips}
          type="text"
        >
          用户服务协议
          <RightOutlined style={{ color: '#bcc3da' }} />
        </Button>
        <Divider style={{ margin: '20px 0' }} />
        <Button
          href="https://yunxin.163.com/clauses?serviceType=3"
          target="_blank"
          className={styles.tips}
          type="text"
        >
          隐私政策
          <RightOutlined style={{ color: '#bcc3da' }} />
        </Button>
        <Divider style={{ margin: '20px 0' }} />
      </>
    ),
    [],
  );

  const joinContent = useMemo(
    () => (
      <>
        <h1 className={styles.title}>加入课堂</h1>
        <Input
          allowClear={true}
          maxLength={12}
          value={meetingId}
          onChange={e => {
            setMeetingId(e.target.value.replace(/[\D]/g, '').slice(0, 20));
          }}
          placeholder="请输入您想要加入的课堂号"
          bordered={false}
        />
        <Divider style={{ margin: '5px 0 20px' }} />
        <Input
          allowClear={true}
          value={nickName}
          onChange={e => {
            setNickName(e.target.value);
          }}
          placeholder="请输入昵称"
          bordered={false}
        />
        <Divider style={{ margin: '5px 0 50px' }} />
        <Button
          onClick={() => {
            onJoin(1);
          }}
          className={`${styles.bigButton} ${styles.mb16}`}
          type="primary"
        >
          加入课堂
        </Button>
        <Button
          onClick={() => {
            setStep('default');
          }}
          className={styles.bigButton}
          type="default"
        >
          返回
        </Button>
      </>
    ),
    [meetingId, nickName],
  );

  const createContent = useMemo(
    () => (
      <>
        <h1 className={styles.title}>创建课堂</h1>
        <Input
          allowClear={true}
          maxLength={30}
          value={subject}
          onChange={e => {
            setSubject(e.target.value);
          }}
          placeholder="请输入课堂名"
          bordered={false}
        />
        <Divider style={{ margin: '5px 0 20px' }} />
        <Input
          allowClear={true}
          maxLength={20}
          value={nickName}
          onChange={e => {
            setNickName(e.target.value);
          }}
          placeholder="请输入昵称"
          bordered={false}
        />
        <Divider style={{ margin: '5px 0 20px' }} />
        <Select
          value={maxCount}
          onChange={setMaxCount}
          placeholder="选择课堂类别"
          bordered={false}
        >
          <Select.Option value={30}>小班课</Select.Option>
          <Select.Option value={1}>一对一</Select.Option>
        </Select>
        <Divider style={{ margin: '5px 0 40px' }} />
        <Button
          onClick={onCreate}
          className={`${styles.bigButton} ${styles.mb16}`}
          type="primary"
          loading={loading}
        >
          创建课堂
        </Button>
        <Button
          onClick={() => {
            setStep('default');
          }}
          className={styles.bigButton}
          type="default"
        >
          返回
        </Button>
      </>
    ),
    [subject, nickName, maxCount, loading],
  );

  const createdContent = useMemo(
    () => (
      <>
        <h1 className={styles.title}>创建成功</h1>
        <div className={styles.classItem}>
          <div className={styles.classItemLeft}>课堂名</div>
          <div
            title={subject}
            className={[styles.classItemRight, styles.ellipsis].join(' ')}
          >
            {subject}
          </div>
        </div>
        <div className={styles.classItem}>
          <div className={styles.classItemLeft}>课堂号</div>
          <div className={styles.classItemRight}>{meetingId}</div>
        </div>
        <div className={`${styles.classItem} ${styles.mb50}`}>
          <div className={styles.classItemLeft}>课堂类别</div>
          <div className={styles.classItemRight}>
            {maxCount === 1 ? '一对一' : '小班课'}
          </div>
        </div>
        <Button
          onClick={() => {
            onJoin(2);
          }}
          className={`${styles.bigButton} ${styles.mb16}`}
          type="primary"
        >
          加入课堂
        </Button>
        <Button
          onClick={() => {
            setStep('default');
          }}
          className={styles.bigButton}
          type="default"
        >
          返回
        </Button>
      </>
    ),
    [subject, meetingId, maxCount],
  );

  return (
    <div className={styles.fullScreen}>
      <div className={styles.wrapperLogin}>
        {step === 'join'
          ? joinContent
          : step === 'create'
          ? createContent
          : step === 'created'
          ? createdContent
          : defaultContent}
      </div>
    </div>
  );
};
