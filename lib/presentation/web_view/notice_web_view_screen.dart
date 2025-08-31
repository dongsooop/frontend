import 'package:dongsoop/core/presentation/components/detail_header.dart';
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

  static const String _baseUrl = 'https://www.dongyang.ac.kr';

  @override
  void initState() {
    super.initState();

    final uri = _normalizeToUri(_baseUrl, widget.path);

    if (uri != null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate())
        ..loadRequest(uri);
    }
  }

  Uri? _normalizeToUri(String baseUrl, String rawInput) {
    final inputUrl = rawInput.trim();

    final absoluteUri = Uri.tryParse(inputUrl);
    if (absoluteUri != null && absoluteUri.hasScheme && absoluteUri.host.isNotEmpty) {
      return absoluteUri.replace(
        pathSegments: absoluteUri.pathSegments.where((s) => s.isNotEmpty).toList(),
      );
    }

    final baseUri = Uri.tryParse(baseUrl);
    if (baseUri == null || !(baseUri.hasScheme && baseUri.host.isNotEmpty)) return null;

    final needsSlash = !(baseUri.path.endsWith('/')) && !(inputUrl.startsWith('/'));
    final combinedUrl = needsSlash
        ? '${baseUri.toString()}/$inputUrl'
        : '${baseUri.toString()}$inputUrl';

    final combinedUri = Uri.tryParse(combinedUrl);
    if (combinedUri == null) return null;

    return combinedUri.replace(
      pathSegments: combinedUri.pathSegments.where((s) => s.isNotEmpty).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailHeader(),
      body: SafeArea(
        child: _controller == null
            ? const Center(child: Text('잘못된 URL입니다.'))
            : WebViewWidget(
          key: ValueKey(widget.path),
          controller: _controller!,
        ),
      ),
    );
  }
}
