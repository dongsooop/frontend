import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class AdmobNativeAd extends StatefulWidget {
  const AdmobNativeAd({super.key});

  @override
  State<AdmobNativeAd> createState() => _AdmobNativeAdState();
}

class _AdmobNativeAdState extends State<AdmobNativeAd> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  final Logger _logger = Logger();

  String get _adUnitId {
    if (Platform.isAndroid) {
      // .env에 ADMOB_ANDROID_NATIVE_ID가 없으면 테스트 ID 사용 (계정 정지 방지)
      return dotenv.maybeGet('ADMOB_ANDROID_NATIVE_ID') ?? 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      // .env에 ADMOB_IOS_NATIVE_ID가 없으면 테스트 ID 사용
      return dotenv.maybeGet('ADMOB_IOS_NATIVE_ID') ?? 'ca-app-pub-3940256099942544/3986624511';
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
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: const Color(0xFF4B9460), // 앱 테마에 맞춘 초록색 계열 (예시)
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (_nativeAdIsLoaded && _nativeAd != null) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 320,
        child: AdWidget(ad: _nativeAd!),
      );
    }
    // 광고 로딩 중에는 빈 공간 또는 스켈레톤 UI를 보여줄 수 있습니다.
    return const SizedBox.shrink();
  }
}
