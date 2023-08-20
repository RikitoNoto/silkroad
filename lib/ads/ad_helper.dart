import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdHelper {
  static Future<InitializationStatus> initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/2934735716';
      } else {
        return 'ca-app-pub-9865959999329879/8255171291';
      }
      // } else if (Platform.isIOS) {
      //   return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      return '';
      throw UnsupportedError('Unsupported platform');
    }
  }
}
