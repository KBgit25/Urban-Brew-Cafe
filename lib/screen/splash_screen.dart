
import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'dart:io';
import 'package:urban_brew_cafe/screen/web_view_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }


  Future<void> _initializeApp() async {
    // Wait for 3 seconds to show splash screen with animations
    await Future.delayed(const Duration(seconds: 3));

    // Request tracking permission on iOS
    if (Platform.isIOS) {
      await _requestTrackingPermission();
    }

    // Navigate to webview
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WebViewScreen()),
      );
    }
  }

  Future<void> _requestTrackingPermission() async {
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;

      if (status == TrackingStatus.notDetermined) {
        final requestStatus = await AppTrackingTransparency.requestTrackingAuthorization();
        print('Tracking authorization status: $requestStatus');

        switch (requestStatus) {
          case TrackingStatus.authorized:
            print('User authorized tracking');
            break;
          case TrackingStatus.denied:
            print('User denied tracking');
            break;
          case TrackingStatus.restricted:
            print('Tracking is restricted');
            break;
          case TrackingStatus.notDetermined:
            print('Tracking status not determined');
            break;
          case TrackingStatus.notSupported:
            print('Tracking status not determined');
            break;
        }
      } else {
        print('Tracking authorization status already determined: $status');
      }
    } catch (e) {
      print('Error requesting tracking permission: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Simple beige background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple splash image
            Image.asset(
              "assets/images/roundlogo.png",
              width: 380,
              height: 400,
            ),
            const SizedBox(height: 40),

            // Simple circular progress indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD2691E)),
            ),
          ],
        ),
      ),
    );
  }
}


