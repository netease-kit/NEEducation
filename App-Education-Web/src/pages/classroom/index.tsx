import React, { useEffect } from 'react';
import { history } from 'umi';
import { actions } from '@/sdk/neWebMeeting.umd.min.js';
import { message } from 'antd';
import config from '@/config';
import Storage from '@/utils/storage';
import styles from './index.less';

const storage = Storage.getInstance('sessionStorage');

export default () => {
  const goBack = () => {
    history.push('/');
  };

  useEffect(() => {
    const eduParams = storage.get('eduParams');
    if (!eduParams) {
      goBack();
      return;
    }
    const {
      accountId,
      accountToken,
      meetingId,
      nickName,
      roleType,
    } = eduParams;

    actions.init(0, 0, {
      appKey: config.appKey,
      locale: 'edu',
      meetingServerDomain: config.meetingServerDomain,
      wbTargetOrigin: config.wbTargetOrigin,
    });

    actions.afterLeave(goBack);

    actions.login(
      {
        accountId,
        accountToken,
      },
      (err: any) => {
        if (err) {
          message.error(err.message, goBack);
          return;
        }

        actions.join(
          {
            meetingId,
            nickName,
            video: 1,
            audio: 1,
            roleType,
            defaultWindowMode: 2,
          },
          (err: any) => {
            if (err) {
              message.error(err.message, goBack);
              return;
            }
          },
        );
      },
    );

    return () => {
      actions.destory();
    };
  }, []);

  return (
    <div className={styles.fullScreen}>
      <div id="ne-web-meeting"></div>
    </div>
  );
};
