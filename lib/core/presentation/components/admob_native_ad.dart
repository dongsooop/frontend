import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/core/environment/app_distribution.dart';

/// AdMob 네이티브 광고 한 칸.
///
/// [height] 는 최소 높이다. 광고가 실제로 더 필요하면 그만큼 늘어난다.
/// 고정 높이를 주면 안 된다 — 템플릿이 잘리면서 광고 자산이 광고 뷰 경계
/// 밖으로 나가고, AdMob 검증기가 `Advertiser assets outside native ad view`
/// 로 잡는다.
class AdmobNativeAd extends StatefulWidget {
  final TemplateType templateType;

  /// 광고가 뜨기 전 자리를 잡아 두는 최소 높이.
  ///
  /// `small` 템플릿이라도 [minTemplateHeight] 아래로는 내려가지 않는다.
  final double height;

  /// 미디어뷰가 영상을 담을 수 있는 최소 크기가 120x120 이다. 여기에
  /// 템플릿의 위아래 여백이 더 붙으므로 그보다 넉넉히 잡는다.
  static const double minTemplateHeight = 140;

  const AdmobNativeAd({
    super.key,
    this.templateType = TemplateType.medium,
    this.height = 250,
  });

  @override
  State<AdmobNativeAd> createState() => _AdmobNativeAdState();
}

class _AdmobNativeAdState extends State<AdmobNativeAd> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  bool _useTestAds = kDebugMode;

  final Logger _logger = Logger();

  static const String _androidTestAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
  static const String _iosTestAdUnitId = 'ca-app-pub-3940256099942544/3986624511';

  String get _adUnitId {
    if (Platform.isAndroid) {
      if (_useTestAds) return _androidTestAdUnitId;
      return dotenv.maybeGet('ADMOB_ANDROID_NATIVE_ID') ?? _androidTestAdUnitId;
    } else if (Platform.isIOS) {
      if (_useTestAds) return _iosTestAdUnitId;
      return dotenv.maybeGet('ADMOB_IOS_NATIVE_ID') ?? _iosTestAdUnitId;
    }

    return '';
  }

  @override
  void initState() {
    super.initState();
    _initAndLoadAd();
  }

  Future<void> _initAndLoadAd() async {
    final isTestFlight = await AppDistribution.isTestFlight();
    _useTestAds = kDebugMode || isTestFlight;
    _logger.d('AdMob use test ads: $_useTestAds');
    if (!mounted) return;
    _loadAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) return;

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _logger.d('$NativeAd loaded.');
          if (mounted) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          _logger.e('$NativeAd failed to load: $error');
          ad.dispose();

          if (mounted) {
            setState(() {
              _nativeAd = null;
              _nativeAdIsLoaded = false;
            });
          }
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
        mainBackgroundColor: Colors.white,
        cornerRadius: 8.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: ColorStyles.primaryColor,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 12.0,
        ),
      ),
    )..load();
  }

  /// 광고가 잘리지 않을 최소 높이.
  double get _minHeight =>
      widget.height < AdmobNativeAd.minTemplateHeight
          ? AdmobNativeAd.minTemplateHeight
          : widget.height;

  @override
  Widget build(BuildContext context) {
    if (_nativeAdIsLoaded && _nativeAd != null) {
      return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(minHeight: _minHeight, maxHeight: 320),
        width: double.infinity,
        child: AdWidget(ad: _nativeAd!),
      );
    }

    return SizedBox(height: _minHeight);
  }
}
