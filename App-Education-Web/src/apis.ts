import axios, { AxiosResponse } from 'axios';
import { uuid } from './utils/utils';
import config from './config';

export interface IGetAnonymousAccountRes {
  code: number;
  msg: string;
  ret: {
    accountId: string;
    accountToken: string;
    appKey: string;
    imAppKey: string;
    nrtcAppKey: string;
    imAccid: string;
    imToken: string;
    nickname: string;
    roomUid: string;
  };
}

export interface ICreateMeetingRes {
  code: number;
  msg: string;
  ret: {
    meetingUniqueId: number;
    meetingId: string;
    subject: string;
    startTime: number;
    endTime: number;
    password: string;
    settings: any;
    attendeeAudioOff: boolean;
    status: number;
    sipCid: string;
  };
}

export interface IJoinMeetingRes {
  code: number;
  msg: string;
  ret: {
    avRoomCName: string;
    avRoomCid: string;
    avRoomUid: number;
    avRoomCheckSum: string;
    createTime: number;
    duration: number;
    audioAllMute: number;
    chatRoomId: number;
    pushUrl: string;
    meetingKey: string;
    meetingId: string;
    shortId: string;
    meetingUniqueId: string;
    nrtcAppKey: string;
    sipCid: string;
  };
}

export const urlMap = {
  get_anonymous_account: '/v1/sdk/account/anonymous',
  create_meeting: '/v1/sdk/meeting/schedule/create',
  join_meeting: '/v1/sdk/meeting/joinInfo',
};

export const request = async <T>({
  method,
  url,
  data,
  headers,
}: {
  method: 'get' | 'post';
  url: string;
  data?: any;
  headers?: any;
}): Promise<T> => {
  try {
    const res: AxiosResponse<T & { code: number; msg: string }> = await axios({
      method,
      url: `${config.baseDomain}${url}`,
      data,
      headers,
    });
    if (res.data.code !== 200) {
      return Promise.reject(res.data.msg);
    }
    return res.data;
  } catch (err) {
    return Promise.reject(err);
  }
};

// 获取匿名账号
export const getAnonymousAccount = () =>
  request<IGetAnonymousAccountRes>({
    method: 'get',
    url: urlMap['get_anonymous_account'],
    headers: {
      clientType: 6,
      meetingSdkVersion: '1.5.2',
      deviceId: uuid(),
      appKey: config.appKey,
    },
  });

// 创建会议
export const createMeeting = ({
  meetingId,
  subject,
  password,
  attendeeAudioOff = false,
  maxCount,
  accountToken,
  accountId,
}: {
  meetingId?: string;
  subject: string;
  password?: string;
  attendeeAudioOff?: boolean;
  maxCount: number;
  accountToken: string;
  accountId: string;
}) =>
  request<ICreateMeetingRes>({
    method: 'post',
    url: urlMap['create_meeting'],
    data: {
      meetingId,
      subject,
      password,
      startTime: Date.now() + 30 * 60 * 1000,
      endTime: Date.now() + 24 * 60 * 60 * 1000 + 30 * 60 * 1000,
      settings: {
        attendeeAudioOff,
        scene: {
          code: 'education-1-to-1',
          roleTypes: [
            {
              roleType: 2,
              maxCount: 1,
            },
            {
              roleType: 1,
              maxCount,
            },
          ],
        },
      },
    },
    headers: {
      clientType: 6,
      meetingSdkVersion: '1.5.2',
      deviceId: uuid(),
      appKey: config.appKey,
      accountId,
      accountToken,
    },
  });

// 加入会议
export const joinMeeting = ({
  meetingId,
  nickName,
  video = 1,
  audio = 1,
  password,
  roleType,
  accountId,
  accountToken,
}: {
  meetingId: string;
  nickName: string;
  video?: number;
  audio?: number;
  password?: string;
  roleType: number;
  accountId: string;
  accountToken: string;
}) =>
  request<IJoinMeetingRes>({
    method: 'post',
    url: urlMap['join_meeting'],
    headers: {
      clientType: 6,
      meetingSdkVersion: '1.5.2',
      deviceId: uuid(),
      appKey: config.appKey,
      accountToken,
      accountId,
    },
    data: {
      accountId,
      meetingId,
      nickName,
      video,
      audio,
      password,
      roleType,
    },
  });
