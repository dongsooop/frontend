import 'dart:io';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/presentation/web_view/restaurant_web_view_status.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
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
  WebViewController? _controller;
  Uri? _placeUri;
  RestaurantWebViewStatus _status = RestaurantWebViewStatus.loading;

  @override
  void initState() {
    super.initState();

    _placeUri = parseKakaoPlaceUri(widget.url);
    if (_placeUri == null) {
      _status = RestaurantWebViewStatus.unavailable;
      return;
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'RestaurantPageStatus',
        onMessageReceived: _handlePageStatusMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _handlePageStarted,
          onPageFinished: _handlePageFinished,
          onHttpError: _handleHttpError,
          onWebResourceError: _handleWebResourceError,
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
      ..loadRequest(_placeUri!);

    _controller = controller;
  }

  void _handlePageStarted(String url) {
    final uri = Uri.tryParse(url);
    if (!isSameKakaoPlace(_placeUri!, uri)) return;

    _setStatus(RestaurantWebViewStatus.loading);
  }

  Future<void> _handlePageFinished(String url) async {
    final controller = _controller;
    if (controller == null) return;
    if (_status == RestaurantWebViewStatus.unavailable ||
        _status == RestaurantWebViewStatus.loadFailure) {
      return;
    }

    try {
      final result = await controller.runJavaScriptReturningResult('''
        (() => {
          const unavailableText = '데이터를 불러올 수 없습니다';
          const notifyIfUnavailable = () => {
            const bodyText = document.body?.innerText ?? '';
            if (!bodyText.includes(unavailableText)) return false;

            RestaurantPageStatus.postMessage('unavailable');
            window.__dongsoopRestaurantObserver?.disconnect();
            return true;
          };

          if (notifyIfUnavailable()) return true;

          window.__dongsoopRestaurantObserver?.disconnect();
          const observer = new MutationObserver(notifyIfUnavailable);
          observer.observe(document.documentElement, {
            childList: true,
            subtree: true,
            characterData: true,
          });
          window.__dongsoopRestaurantObserver = observer;
          return false;
        })()
      ''');

      if (!mounted || _status == RestaurantWebViewStatus.unavailable) return;
      final normalizedResult = result.toString().replaceAll('"', '');
      final isUnavailable = result == true ||
          result == 1 ||
          normalizedResult == 'true' ||
          normalizedResult == '1';
      _setStatus(
        isUnavailable
            ? RestaurantWebViewStatus.unavailable
            : RestaurantWebViewStatus.ready,
      );
    } catch (error) {
      debugPrint('Kakao place page inspection failed: $error');
      if (mounted && _status == RestaurantWebViewStatus.loading) {
        _setStatus(RestaurantWebViewStatus.ready);
      }
    }
  }

  void _handlePageStatusMessage(JavaScriptMessage message) {
    if (message.message == 'unavailable') {
      _setStatus(RestaurantWebViewStatus.unavailable);
    }
  }

  void _handleHttpError(HttpResponseError error) {
    _resolveHttpError(error);
  }

  Future<void> _resolveHttpError(HttpResponseError error) async {
    final controller = _controller;
    final statusCode = error.response?.statusCode;
    if (controller == null || statusCode == null) return;

    Uri? failedUri = error.request?.uri ?? error.response?.uri;
    if (failedUri == null) {
      final currentUrl = await controller.currentUrl();
      failedUri = currentUrl == null ? null : Uri.tryParse(currentUrl);
    }

    if (!mounted) return;
    final status = classifyRestaurantHttpError(
      initialUri: _placeUri!,
      failedUri: failedUri,
      statusCode: statusCode,
    );
    if (status != null) _setStatus(status);
  }

  void _handleWebResourceError(WebResourceError error) {
    final errorUri = error.url == null ? null : Uri.tryParse(error.url!);
    final isMainFrameError = error.isForMainFrame == true ||
        (error.isForMainFrame == null &&
            isSameKakaoPlace(_placeUri!, errorUri));

    if (isMainFrameError &&
        _status != RestaurantWebViewStatus.unavailable) {
      _setStatus(RestaurantWebViewStatus.loadFailure);
    }
  }

  void _setStatus(RestaurantWebViewStatus status) {
    if (!mounted || _status == status) return;
    setState(() => _status = status);
  }

  Future<void> _retry() async {
    final controller = _controller;
    final placeUri = _placeUri;
    if (controller == null || placeUri == null) return;

    _setStatus(RestaurantWebViewStatus.loading);
    try {
      await controller.loadRequest(placeUri);
    } catch (error) {
      debugPrint('Kakao place page reload failed: $error');
      _setStatus(RestaurantWebViewStatus.loadFailure);
    }
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final controller = _controller;
    if (controller == null) {
      return _buildUnavailableMessage();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        WebViewWidget(controller: controller),
        if (_status == RestaurantWebViewStatus.loading)
          const ColoredBox(
            color: ColorStyles.white,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorStyles.primaryColor,
              ),
            ),
          ),
        if (_status == RestaurantWebViewStatus.unavailable)
          _buildUnavailableMessage(),
        if (_status == RestaurantWebViewStatus.loadFailure)
          _RestaurantWebViewMessage(
            icon: Icons.wifi_off_rounded,
            title: '지도를 불러오지 못했어요',
            description: '인터넷 연결을 확인한 뒤 다시 시도해 주세요.',
            primaryLabel: '다시 시도',
            primaryIcon: Icons.refresh_rounded,
            isPrimaryOutlined: true,
            onPrimaryPressed: _retry,
            secondaryLabel: '목록으로 돌아가기',
            onSecondaryPressed: _goBack,
          ),
      ],
    );
  }

  Widget _buildUnavailableMessage() {
    return _RestaurantWebViewMessage(
      icon: Icons.storefront_outlined,
      title: '이 가게는 카카오맵에서\n더 이상 확인할 수 없어요',
      description: '폐업했거나 장소 정보가 삭제되었을 수 있어요.',
      primaryLabel: '목록으로 돌아가기',
      primaryIcon: Icons.arrow_back_rounded,
      onPrimaryPressed: _goBack,
    );
  }

  void _goBack() {
    Navigator.of(context).maybePop();
  }
}

class _RestaurantWebViewMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String primaryLabel;
  final IconData primaryIcon;
  final bool isPrimaryOutlined;
  final VoidCallback onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  const _RestaurantWebViewMessage({
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimaryPressed,
    this.isPrimaryOutlined = false,
    this.secondaryLabel,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorStyles.white,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: ColorStyles.gray5),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.largeTextBold.copyWith(
                  color: ColorStyles.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray4,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              if (isPrimaryOutlined)
                OutlinedButton.icon(
                  onPressed: onPrimaryPressed,
                  icon: Icon(primaryIcon, size: 16),
                  label: Text(primaryLabel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorStyles.primary100,
                    side: const BorderSide(color: ColorStyles.gray2),
                    textStyle: TextStyles.normalTextBold,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: onPrimaryPressed,
                  icon: Icon(primaryIcon, size: 16),
                  label: Text(primaryLabel),
                  style: TextButton.styleFrom(
                    foregroundColor: ColorStyles.gray6,
                    textStyle: TextStyles.normalTextRegular,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              if (secondaryLabel != null && onSecondaryPressed != null) ...[
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: onSecondaryPressed,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: Text(secondaryLabel!),
                  style: TextButton.styleFrom(
                    foregroundColor: ColorStyles.gray5,
                    textStyle: TextStyles.normalTextRegular,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
