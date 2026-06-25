import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:dongsoop/ui/color_styles.dart';

class AdmobNativeAd extends StatefulWidget {
  final TemplateType templateType;
  final double height;

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
  final Logger _logger = Logger();

  static const String _androidTestAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
  static const String _iosTestAdUnitId = 'ca-app-pub-3940256099942544/3986624511';

  String get _adUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) return _androidTestAdUnitId;
      return dotenv.maybeGet('ADMOB_ANDROID_NATIVE_ID') ?? _androidTestAdUnitId;
    } else if (Platform.isIOS) {
      if (kDebugMode) return _iosTestAdUnitId;
      return dotenv.maybeGet('ADMOB_IOS_NATIVE_ID') ?? _iosTestAdUnitId;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if (_nativeAdIsLoaded && _nativeAd != null) {
      return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          minHeight: widget.height,
          maxHeight: 320,
        ),
        width: double.infinity,
        child: AdWidget(ad: _nativeAd!),
      );
    }
    // 광고 로딩 중에는 빈 공간 또는 스켈레톤 UI를 보여줄 수 있습니다.
    return SizedBox(height: widget.height);
  }
}
