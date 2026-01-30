import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:share_plus/share_plus.dart';
import 'notice_web_view_view_model.dart';

class NoticeWebViewScreen extends ConsumerStatefulWidget {
  final String path;

  const NoticeWebViewScreen({super.key, required this.path});

  @override
  ConsumerState<NoticeWebViewScreen> createState() => _NoticeWebViewScreenState();
}

class _NoticeWebViewScreenState extends ConsumerState<NoticeWebViewScreen> {
  WebViewController? _controller;
  bool _didRefreshFromNotifList = false;

  static const String _baseUrl = 'https://www.dongyang.ac.kr';

  @override
  void initState() {
    super.initState();

    final uri = _normalizeToUri(_baseUrl, widget.path);

    if (uri != null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest:
                (NavigationRequest request) async {
              final viewmodel = ref.read(
                noticeWebViewViewModelProvider.notifier,
              );

              if (viewmodel.isDownloadUrl(request.url)) {
                final file =
                await viewmodel.downloadFile(request.url);

                if (!mounted) {
                  return NavigationDecision.prevent;
                }

                if (file != null) {
                  await Share.shareXFiles(
                    [file],
                    text: '첨부파일',
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${file.name} 다운로드를 완료했습니다.',
                        ),
                      ),
                    );
                  }
                } else {
                  final state = ref.read(
                    noticeWebViewViewModelProvider,
                  );
                  final msg = state.errorMessage ??
                      '파일을 다운로드하는 중 오류가 발생했습니다.';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                }

                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(uri);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeRefreshBadgeFromQuery();
    });
  }

  void _maybeRefreshBadgeFromQuery() {
    if (_didRefreshFromNotifList) return;

    final from = GoRouterState.of(context).uri.queryParameters['from'];
    if (from == 'notificationList') {
      _didRefreshFromNotifList = true;
      ref.read(notificationBadgeViewModelProvider.notifier)
          .refreshBadge(force: true);
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
    _maybeRefreshBadgeFromQuery();

    final downloadState = ref.watch(noticeWebViewViewModelProvider);

    return Scaffold(
      appBar: DetailHeader(
        onBack: () {
          if (context.canPop()) {
            context.pop();
            return;
          }
          context.go(RoutePaths.home);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (_controller == null)
              const Center(child: Text('잘못된 URL입니다.'))
            else
              WebViewWidget(
                key: ValueKey(widget.path),
                controller: _controller!,
              ),
            if (downloadState.isDownloading)
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    color: ColorStyles.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
