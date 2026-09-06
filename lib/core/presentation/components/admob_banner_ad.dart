import 'dart:io';

import 'package:dongsoop/core/environment/app_distribution.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

/// 홈의 스크롤 콘텐츠 안에 배치되는 인라인 적응형 배너 광고.
///
/// 광고가 아직 로드되지 않았거나 실패하면 빈 공간을 남기지 않는다.
/// 화면 폭/방향이 바뀌면 해당 크기에 맞춰 광고를 다시 요청한다.
class AdmobBannerAd extends StatefulWidget {
  const AdmobBannerAd({super.key});

  @override
  State<AdmobBannerAd> createState() => _AdmobBannerAdState();
}

class _AdmobBannerAdState extends State<AdmobBannerAd> {
  BannerAd? _bannerAd;
  AdSize? _loadedSize;
  bool _isLoaded = false;
  bool _useTestAds = kDebugMode;
  int? _requestedWidth;
  Orientation? _requestedOrientation;
  int _requestGeneration = 0;

  final Logger _logger = Logger();

  static const String _androidTestAdUnitId =
      'ca-app-pub-3940256099942544/9214589741';
  static const String _iosTestAdUnitId =
      'ca-app-pub-3940256099942544/2435281174';

  String get _adUnitId {
    if (Platform.isAndroid) {
      if (_useTestAds) return _androidTestAdUnitId;
      return dotenv.maybeGet('ADMOB_ANDROID_BANNER_ID') ?? _androidTestAdUnitId;
    }

    if (Platform.isIOS) {
      if (_useTestAds) return _iosTestAdUnitId;
      return dotenv.maybeGet('ADMOB_IOS_BANNER_ID') ?? _iosTestAdUnitId;
    }

    return '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width.truncate();
    final orientation = mediaQuery.orientation;

    if (_requestedWidth == width && _requestedOrientation == orientation) {
      return;
    }

    _requestedWidth = width;
    _requestedOrientation = orientation;
    _loadInlineAdaptiveAd(width);
  }

  Future<void> _loadInlineAdaptiveAd(int width) async {
    final generation = ++_requestGeneration;
    final isTestFlight = await AppDistribution.isTestFlight();

    if (!mounted || generation != _requestGeneration) return;

    _useTestAds = kDebugMode || isTestFlight;

    final previousAd = _bannerAd;
    _bannerAd = null;
    _loadedSize = null;
    _isLoaded = false;
    await previousAd?.dispose();

    if (!mounted || generation != _requestGeneration) return;

    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) return;

    // 홈은 ListView 안에 있으므로 anchored가 아니라 inline adaptive를 사용한다.
    final requestSize = AdSize.getInlineAdaptiveBannerAdSize(width, 100);

    late final BannerAd ad;
    ad = BannerAd(
      adUnitId: adUnitId,
      size: requestSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) async {
          if (!mounted || generation != _requestGeneration) {
            await ad.dispose();
            return;
          }

          final platformSize = await ad.getPlatformAdSize();
          if (!mounted || generation != _requestGeneration) {
            await ad.dispose();
            return;
          }

          setState(() {
            _loadedSize = platformSize ?? ad.size;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (failedAd, error) {
          _logger.d('AdMob banner failed: $error');
          failedAd.dispose();

          if (!mounted || generation != _requestGeneration) return;

          setState(() {
            _bannerAd = null;
            _loadedSize = null;
            _isLoaded = false;
          });
        },
      ),
    );

    _bannerAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    _requestGeneration++;
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    final size = _loadedSize;

    if (!_isLoaded || ad == null || size == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      color: ColorStyles.white,
      width: size.width.toDouble(),
      height: size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
