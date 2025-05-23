import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticeWebViewScreen extends StatefulWidget {
  final String path;

  const NoticeWebViewScreen({super.key, required this.path});

  @override
  State<NoticeWebViewScreen> createState() => _NoticeWebViewScreenState();
}

class _NoticeWebViewScreenState extends State<NoticeWebViewScreen> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();

    final baseUrl = 'https://www.dongyang.ac.kr';
    final fullUrl = _mergeUrl(baseUrl, widget.path);
    final uri = Uri.tryParse(fullUrl);

    if (uri != null && uri.hasScheme) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(uri);
    } else {
      debugPrint('Invalid URL: $fullUrl');
    }
  }

  String _mergeUrl(String base, String path) {
    if (base.endsWith('/') && path.startsWith('/')) {
      return base + path.substring(1);
    } else if (!base.endsWith('/') && !path.startsWith('/')) {
      return '$base/$path';
    } else {
      return '$base$path';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공지 상세보기')),
      body: _controller == null
          ? const Center(child: Text('잘못된 URL입니다.'))
          : WebViewWidget(controller: _controller!),
    );
  }
}
