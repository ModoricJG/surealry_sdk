class AppConfigs {
  static String apiBaseUrl = 'http://modoric-dev-1.modoric.com:5055/sdk';
  static String webBaseUrl = 'https://surearly-smart-sdk-web-dev.vespexx.com/splash?';

  static String initUrl = '/initialize';
  static String lotUrl = '/lots';
  static String lastLotUrl = '/lots/last-selected';
  static String logUrl = '/log';
  static String testResultUrl = '/test-result';

  ///테스트 진행률 표시 노티
  static int progressNotificationChannelId = 1000;
  static String progressNotificationChannelKey = 'Progress';
  static String progressNotificationChannelName = 'Progress';
  static int timerDeviceTestSeconds = 300;

  ///테스트 완료 표시 노티
  static int testCompleteNotificationChannelId = 999;
  static String testCompleteNotificationChannelKey = 'TestComplete';
  static String testCompleteNotificationChannelName = 'TestComplete';
}
