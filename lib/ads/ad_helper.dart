import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform/platform.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  AdHelper({
    required this.platform,
  });

  final Platform platform;

  Future<InitializationStatus> initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  String get bannerAdUnitId {
    if (platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/2934735716';
      } else {
        return 'ca-app-pub-9865959999329879/8255171291';
      }
      // } else if (Platform.isIOS) {
      //   return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      return '';
    }
  }

  void initBannerAd({void Function(Ad)? onAdLoaded}) {
    if (platform.isAndroid) {
      initGoogleMobileAds();
      BannerAd(
        adUnitId: bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: (ad, err) {
            ad.dispose();
          },
        ),
      ).load();
    }
  }
}
