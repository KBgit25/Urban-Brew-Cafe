class AppConfig {
  // App Configuration - Change these values for different apps
  static const String appName = 'Burger Baron Onoway';
  static const String mainUrl = 'https://www.ordermenu.ca/ordering/restaurant/menu?restaurant_uid=26cc663e-b070-42af-88e3-c87b513b79b5&client_is_mobile=true';
  static const String privacyPolicyUrl = 'https://www.ordermenu.ca/api/legal?type=privacy&add_header=1&uid=26cc663e-b070-42af-88e3-c87b513b79b5&language=en';

  // Splash Screen Configuration
  static const String splashImagePath = 'assets/images/icon.png';
  static const int splashDurationSeconds = 3;

  // WebView Configuration
  static const bool enableJavaScript = true;
  static const bool enableDomStorage = true;
  static const bool enableZoom = true;

  // App Tracking Transparency
  static const String attTitle = 'App Tracking Permission';
  static const String attDescription = 'This app would like to access your device identifier to provide personalized ads and improve your experience.';

  // Privacy Policy Button Text
  static const String privacyButtonText = 'Privacy Policy';
}