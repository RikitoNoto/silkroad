import 'package:flutter/material.dart';
import 'package:platform/platform.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PlatformBannerAd extends StatelessWidget {
  const PlatformBannerAd({
    this.bannerAd,
    required this.platform,
    super.key,
  });

  final BannerAd? bannerAd;
  final Platform platform;

  @override
  Widget build(BuildContext context) {
    if ((!platform.isAndroid && !platform.isIOS) || bannerAd == null) {
      return Container();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: bannerAd!.size.width.toDouble(),
        height: bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: bannerAd!),
      ),
    );
  }
}
