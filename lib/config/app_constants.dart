class AppConstants {
  // Firebase Node Paths
  static const String databaseNodeGateStatus = 'gate_status';
  static const String databaseNodeAppConfig = 'app_config';
  static const String databaseNodeDeviceTokens = 'device_tokens';

  // FCM Configuration
  static const String fcmTopicGateStatus = 'gate-status-alerts';

  // Vercel Serverless Backend
  static const String vercelNotifyUrl = 'https://project-bwg1z.vercel.app/api/notify';

  // Admin Access Constraints
  static const int adminTapCountThreshold = 5;
  static const int adminTapWindowMs = 2000;
}
