import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform/platform.dart';

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
    } else if (platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/2934735716';
      } else {
        return 'ca-app-pub-9865959999329879/3977062661';
      }
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
