class Secrets {
  // Local admin fallback. Remember to never commit the real file.
  static const String gatemanPin = "REPLACE_WITH_AGREED_PIN";
  
  // Temporary Spark-plan workaround FCM push trigger authentication (legacy — unused)
  static const String fcmServerKey = "REPLACE_WITH_REAL_KEY";

  // Vercel serverless backend authentication key
  // Set this to the value of NOTIFY_SECRET_KEY in your Vercel dashboard.
  // NEVER commit the real value. Keep this file in .gitignore.
  static const String vercelSecretKey = "REPLACE_WITH_VERCEL_SECRET_KEY";
}
