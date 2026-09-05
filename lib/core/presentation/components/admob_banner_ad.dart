import 'dart:io';
import 'package:dongsoop/core/environment/app_distribution.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

/// 가로형 배너 광고.
///
/// 홈에서 쓰던 세로 250 네이티브 광고는 공지와 바로가기 사이를 크게 갈랐다.
/// 목록 흐름을 끊지 않도록 화면 폭에 맞춘 배너로 바꾼다.
///
/// 고정 320x50(`AdSize.banner`) 대신 **anchored adaptive** 를 쓴다. 구글이 권하는
/// 방식이고, 폭이 390~430 인 요즘 기기에서 고정 320 을 쓰면 양옆에 빈 자리가 남는다.
/// 기기 폭을 넘기면 그에 맞는 높이를 돌려준다.
///
/// 광고가 아직 안 붙었거나 실패하면 아무것도 그리지 않는다 — 빈 회색 칸이 남으면
/// 로딩이 끝나지 않은 것처럼 보인다.
class AdmobBannerAd extends StatefulWidget {
  const AdmobBannerAd({super.key});

  @override
  State<AdmobBannerAd> createState() => _AdmobBannerAdState();
}

class _AdmobBannerAdState extends State<AdmobBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _useTestAds = kDebugMode;

  final Logger _logger = Logger();

  static const String _androidTestAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosTestAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';

  String get _adUnitId {
    if (Platform.isAndroid) {
      if (_useTestAds) return _androidTestAdUnitId;
      return dotenv.maybeGet('ADMOB_ANDROID_BANNER_ID') ?? _androidTestAdUnitId;
    } else if (Platform.isIOS) {
      if (_useTestAds) return _iosTestAdUnitId;
      return dotenv.maybeGet('ADMOB_IOS_BANNER_ID') ?? _iosTestAdUnitId;
    }

    return '';
  }

  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // adaptive 크기를 구하려면 화면 폭이 필요해 여기서 한 번만 시작한다
    if (_requested) return;
    _requested = true;
    _initAndLoadAd(MediaQuery.sizeOf(context).width.truncate());
  }

  Future<void> _initAndLoadAd(int width) async {
    final isTestFlight = await AppDistribution.isTestFlight();
    _useTestAds = kDebugMode || isTestFlight;
    if (!mounted) return;

    final size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (!mounted) return;

    // 기기가 adaptive 크기를 못 주면 표준 배너로 떨어진다
    _loadAd(size ?? AdSize.banner);
  }

  void _loadAd(AdSize size) {
    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) return;

    final ad = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          _logger.d('AdMob banner failed: $error');
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
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
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (!_isLoaded || ad == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      color: ColorStyles.white,
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
