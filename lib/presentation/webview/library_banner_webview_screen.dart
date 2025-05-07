import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LibraryBannerWebViewScreen extends StatefulWidget {
  const LibraryBannerWebViewScreen({super.key});

  @override
  State<LibraryBannerWebViewScreen> createState() =>
      _LibraryBannerWebViewState();
}

class _LibraryBannerWebViewState extends State<LibraryBannerWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    final url = 'https://lib.dongyang.ac.kr/studyroom/groupReserveStat/101';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도서관 배너 웹뷰')),
      body: WebViewWidget(controller: controller),
    );
  }
}
