import { urlMap } from '../src/apis';

export default {
  [`GET /api${urlMap['get_anonymous_account']}`]: {
    code: 200,
    msg: '',
    ret: {
      accountId: '1158148553127790',
      accountToken: '1158148553127790',
      appKey: 'hquiwouewq',
      imAppKey: 'hquiwouewq',
      nrtcAppKey: 'hquiwouewq',
      imAccid: 'hquiwouewq',
      imToken: 'hquiwouewq',
      nickname: 'xiaobai',
      roomUid: 'hquiwouewq',
    },
  },

  [`POST /api${urlMap['create_meeting']}`]: {
    code: 200,
    msg: '',
    ret: {
      meetingUniqueId: 123123,
      meetingId: '7589477225',
      subject: 'iuoquwoieo',
      startTime: 123123,
      endTime: 123123,
      password: 'iuoquwoieo',
      settings: {},
      attendeeAudioOff: true,
      status: 123123,
      sipCid: 'iuoquwoieo',
    },
  },

  [`POST /api${urlMap['join_meeting']}`]: {
    code: 200,
    msg: '',
    ret: {
      avRoomCName: 'hquiwouewq',
      avRoomCid: 'hquiwouewq',
      avRoomUid: 123123,
      avRoomCheckSum: 'hquiwouewq',
      createTime: 123123,
      duration: 123123,
      audioAllMute: 123123,
      chatRoomId: 123123,
      pushUrl: 'hquiwouewq',
      meetingKey: 'hquiwouewq',
      meetingId: '7589477225',
      shortId: 'hquiwouewq',
      meetingUniqueId: 'hquiwouewq',
      nrtcAppKey: 'hquiwouewq',
      sipCid: 'hquiwouewq',
    },
  },
};
