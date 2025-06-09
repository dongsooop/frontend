import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CafeteriaWebViewPageScreen extends StatefulWidget {
  const CafeteriaWebViewPageScreen({super.key});

  @override
  State<CafeteriaWebViewPageScreen> createState() =>
      _CafeteriaWebViewPageScreenState();
}

class _CafeteriaWebViewPageScreenState
    extends State<CafeteriaWebViewPageScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
          Uri.parse('https://www.dongyang.ac.kr/dmu/4902/subview.do'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('학식 배너 웹뷰')),
      body: WebViewWidget(controller: controller),
    );
  }
}
