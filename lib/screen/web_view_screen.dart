import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'dart:io';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  bool trackingAllowed = false;

  @override
  void initState() {
    super.initState();
    _checkTrackingStatus();
    _initializeWebView();
  }

  Future<void> _checkTrackingStatus() async {
    if (Platform.isIOS) {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() {
        trackingAllowed = status == TrackingStatus.authorized;
      });
    } else {
      setState(() {
        trackingAllowed = true;
      });
    }
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFAF0E6)) // Warm cream background
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _handleCookieConsent();
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://urbanbrewcafe.ca/app/'));
  }

  Future<void> _handleCookieConsent() async {
    if (!trackingAllowed) {
      const jsCode = '''
        // Disable tracking cookies
        document.cookie.split(";").forEach(function(c) { 
          document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
        });
        
        // Block Google Analytics if present
        if (typeof gtag !== 'undefined') {
          gtag('config', 'GA_MEASUREMENT_ID', {
            'anonymize_ip': true,
            'allow_ad_personalization_signals': false
          });
        }
        
        // Disable other common tracking
        if (typeof _gaq !== 'undefined') {
          _gaq = [];
        }
      ''';

      try {
        await controller.runJavaScript(jsCode);
        print('Cookie blocking JavaScript injected');
      } catch (e) {
        print('Error injecting JavaScript: $e');
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF0E6), // Warm cream
        appBar: AppBar(
          title: Row(
            children: [
              // Coffee cup icon in title
              Icon(
                Icons.local_cafe,
                color: const Color(0xFFFAF0E6),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Urban Brew Cafe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF8B4513), // Saddle Brown
          foregroundColor: const Color(0xFFFAF0E6), // Cream text
          elevation: 4,
          shadowColor: const Color(0xFF654321).withOpacity(0.5),
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD2691E).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFFAF0E6),
              ),
            ),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            if (Platform.isIOS)
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2691E).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Color(0xFFFAF0E6),
                  ),
                ),
                color: const Color(0xFFFAF0E6),
                onSelected: (value) {
                  if (value == 'privacy') {
                    _showPrivacyDialog();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'privacy',
                    child: Row(
                      children: [
                        Icon(Icons.privacy_tip, color: Color(0xFF8B4513)),
                        SizedBox(width: 8),
                        Text(
                          'Privacy Settings',
                          style: TextStyle(color: Color(0xFF654321)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading)
              Container(
                color: const Color(0xFFFAF0E6), // Simple background color
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD2691E)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAF0E6),
          title: Row(
            children: [
              Icon(
                Icons.privacy_tip,
                color: const Color(0xFF8B4513),
              ),
              const SizedBox(width: 8),
              const Text(
                'Privacy Settings',
                style: TextStyle(
                  color: Color(0xFF654321),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      trackingAllowed ? Icons.check_circle : Icons.block,
                      color: trackingAllowed ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tracking Status: ${trackingAllowed ? "Allowed" : "Blocked"}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF654321),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'To change tracking permissions, please go to Settings > Privacy & Security > Tracking on your device.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B4513),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD2691E),
                foregroundColor: Colors.white,
                elevation: 2,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }
}