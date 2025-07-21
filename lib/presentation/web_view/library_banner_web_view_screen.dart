import 'package:dongsoop/core/presentation/components/detail_header.dart';
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
      appBar: DetailHeader(),
      body: WebViewWidget(controller: controller),
    );
  }
}
