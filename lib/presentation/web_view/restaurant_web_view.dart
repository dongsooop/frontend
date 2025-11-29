import 'dart:io';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RestaurantWebView extends StatefulWidget {
  final String url;

  const RestaurantWebView({
    super.key,
    required this.url,
  });

  @override
  State<RestaurantWebView> createState() => _RestaurantWebViewState();
}

class _RestaurantWebViewState extends State<RestaurantWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;
            debugPrint('WebView navigation: $url');

            if (Platform.isAndroid && url.startsWith('intent://')) {
              final deepLink = _convertIntentToScheme(url);
              debugPrint('converted deeplink: $deepLink');

              if (deepLink != null && await canLaunchUrlString(deepLink)) {
                await launchUrlString(
                  deepLink,
                  mode: LaunchMode.externalApplication,
                );
              } else {
              }
              return NavigationDecision.prevent;
            }

            if (url.startsWith('kakaomap://')) {
              if (await canLaunchUrlString(url)) {
                await launchUrlString(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
              return NavigationDecision.prevent;
            }

            if (url.startsWith('itms-apps://') ||
                url.startsWith('market://') ||
                url.contains('apps.apple.com') ||
                url.contains('play.google.com')) {
              if (await canLaunchUrlString(url)) {
                await launchUrlString(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  String? _convertIntentToScheme(String intentUrl) {
    try {
      final schemeMatch = RegExp(r';scheme=([^;]+);').firstMatch(intentUrl);
      final scheme = schemeMatch?.group(1);
      if (scheme == null) return null;

      final start = 'intent://'.length;
      final end = intentUrl.indexOf('#Intent');
      if (end == -1) return null;

      final pathAndQuery = intentUrl.substring(start, end);

      return '$scheme://$pathAndQuery';
    } catch (e) {
      debugPrint('convert intent error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailHeader(title: ''),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}