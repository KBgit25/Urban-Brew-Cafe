import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AppTrackingService {
  static Future<void> requestTrackingAuthorization() async {
    if (!Platform.isIOS) {
      return; // Only needed for iOS
    }

    try {
      // Check if we should show the tracking dialog
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;

      // If status is not determined, request permission
      if (status == TrackingStatus.notDetermined) {
        // Show custom message before requesting permission
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      // Handle any errors gracefully
      print('App Tracking Transparency Error: $e');
    }
  }

  static Future<TrackingStatus> getTrackingStatus() async {
    if (!Platform.isIOS) {
      return TrackingStatus.authorized; // Android doesn't need this
    }

    try {
      return await AppTrackingTransparency.trackingAuthorizationStatus;
    } catch (e) {
      print('Error getting tracking status: $e');
      return TrackingStatus.notDetermined;
    }
  }

  static Future<String?> getAdvertisingIdentifier() async {
    if (!Platform.isIOS) {
      return null; // Only available on iOS
    }

    try {
      final status = await getTrackingStatus();
      if (status == TrackingStatus.authorized) {
        return await AppTrackingTransparency.getAdvertisingIdentifier();
      }
      return null;
    } catch (e) {
      print('Error getting advertising identifier: $e');
      return null;
    }
  }
}