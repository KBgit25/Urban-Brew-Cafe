
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../constants/AppConfig.dart';
import '../servies/privacy_policy_service.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _currentUrl = '';
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress if needed
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
              _currentUrl = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _currentUrl = url;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation within the app
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConfig.mainUrl));
  }

  void _reloadPage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _controller.reload();
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  void _showPrivacyPolicy() {
    PrivacyPolicyService.openPrivacyPolicy(context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Main WebView
              if (!_hasError && _isConnected)
                WebViewWidget(controller: _controller),

              // Error State
              if (_hasError || !_isConnected)
                _buildErrorState(),

              // Loading Indicator
              if (_isLoading && !_hasError && _isConnected)
                _buildLoadingIndicator(),

              // Privacy Policy Button
              // _buildPrivacyPolicyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isConnected ? Icons.error_outline : Icons.wifi_off,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                _isConnected
                    ? 'Something went wrong'
                    : 'No Internet Connection',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isConnected
                    ? 'Please check your connection and try again'
                    : 'Please check your internet connection',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _reloadPage,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildPrivacyPolicyButton() {
  //   return Positioned(
  //     bottom: 20,
  //     right: 20,
  //     child: FloatingActionButton.extended(
  //       onPressed: _showPrivacyPolicy,
  //       backgroundColor: Colors.blue,
  //       foregroundColor: Colors.white,
  //       icon: const Icon(Icons.privacy_tip, size: 20),
  //       label: Text(
  //         AppConfig.privacyButtonText,
  //         style: const TextStyle(fontSize: 12),
  //       ),
  //       elevation: 4,
  //     ),
  //   );
  // }
}