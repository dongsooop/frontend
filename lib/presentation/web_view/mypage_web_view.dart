import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

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
    logger.i("url: ${widget.url}");
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(widget.title, style: TextStyles.largeTextBold.copyWith(
            color: ColorStyles.black
          )),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 24,
              color: ColorStyles.black,
            ),
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
