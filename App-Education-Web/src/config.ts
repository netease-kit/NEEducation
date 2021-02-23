export default {
  appKey: '', // 请输入您的appKey
  baseDomain:
    process.env.ENV === 'dev'
      ? '/api'
      : process.env.ENV === 'prod'
      ? 'https://meeting-api.netease.im'
      : 'https://meeting-api-test.netease.im',
  meetingServerDomain:
    process.env.ENV === 'prod'
      ? 'https://meeting-api.netease.im'
      : 'https://meeting-api-test.netease.im',
  wbTargetOrigin:
    process.env.ENV === 'prod' ? '' : 'https://apptest.netease.im',
};
