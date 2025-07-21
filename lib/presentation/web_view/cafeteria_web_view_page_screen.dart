import 'package:dongsoop/core/presentation/components/detail_header.dart';
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
      appBar: DetailHeader(),
      body: WebViewWidget(controller: controller),
    );
  }
}
