import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';

class MypageWebView extends StatefulWidget {
  final String url;
  final String title;

  const MypageWebView({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<MypageWebView> createState() => _MypageWebViewState();
}

class _MypageWebViewState extends State<MypageWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailHeader(),
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
