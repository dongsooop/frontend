import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:dongsoop/core/environment/app_distribution.dart';

class AdmobNativeAd extends StatefulWidget {
  // Keep these dimensions in sync with the Android and iOS horizontal factories.
  // 12 padding + 32 header + 12 gap + 128 media + 12 padding = 196.
  static const double height = 196;
  static const double minWidth = 320;
  static const String factoryId = 'dongsoopHorizontalNativeAd';

  const AdmobNativeAd({super.key});

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
      factoryId: AdmobNativeAd.factoryId,
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
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Never squeeze the native assets into a smaller parent or scale the
        // MediaView below the SDK's 120 x 120 video minimum.
        if (!constraints.hasBoundedWidth ||
            constraints.maxWidth < AdmobNativeAd.minWidth ||
            constraints.maxHeight < AdmobNativeAd.height) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: constraints.maxWidth,
          height: AdmobNativeAd.height,
          child: _nativeAdIsLoaded && _nativeAd != null
              ? AdWidget(ad: _nativeAd!)
              : null,
        );
      },
    );
  }
}
