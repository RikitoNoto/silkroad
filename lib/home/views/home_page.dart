import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platform/platform.dart';
import 'package:silkroad/ads/platform_banner_ad.dart';
import 'package:silkroad/app_theme.dart';
import 'package:silkroad/utils/views/theme_input_field.dart';
import 'package:silkroad/parameter.dart';
import 'package:silkroad/utils/views/character_logo.dart';
import 'package:silkroad/i18n/translations.g.dart';
import 'package:silkroad/ads/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:silkroad/version/version.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.platform, required this.version, super.key});

  final Platform platform;
  final Version version;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    AdHelper(platform: widget.platform).initBannerAd(
        onAdLoaded: (ad) => setState(() {
              _bannerAd = ad as BannerAd;
            }));

    if (widget.version.isNeedUpdate()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                title: Text(t.version.oldVersionDialogTitle),
                content: Text(t.version.oldVersionDialogContent),
              ),
              onWillPop: () async => false)));
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Object? name = OptionManager().get(Params.name.toString());
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: CharacterLogo(),
        ),
        body: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: SizedBox(
                height: 50,
                child: ThemeInputField(
                  labelText: t.params.name,
                  initialValue: name is String ? name : null,
                  onChanged: OptionInput.createCallbackForInput(Params.name),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildActionSelectButton(
                    context,
                    label: t.actions.send,
                    svgPath: 'assets/svg_icons/transfer-out.svg',
                    iconColor: AppTheme.appIconColor1,
                    onPressed: () => Navigator.pushNamed(context, '/send'),
                  ),
                  _buildActionSelectButton(
                    context,
                    label: t.actions.receive,
                    svgPath: 'assets/svg_icons/transfer-in.svg',
                    iconColor: AppTheme.appIconColor2,
                    onPressed: () => Navigator.pushNamed(context, '/receive'),
                  ),
                  _buildActionSelectButton(
                    context,
                    label: t.actions.option,
                    iconData: Icons.settings,
                    iconColor: Colors.grey,
                    onPressed: () => Navigator.pushNamed(context, '/option'),
                  ),
                ],
              ),
            ),
          ]),
          PlatformBannerAd(
            platform: widget.platform,
            bannerAd: _bannerAd,
          ),
        ]),
      ),
    );
  }

  Widget _buildActionSelectButton(BuildContext context,
      {required String label,
      String? svgPath,
      IconData? iconData,
      required Color iconColor,
      void Function()? onPressed}) {
    if (((svgPath == null) && (iconData == null)) ||
        ((svgPath != null) && (iconData != null)))
      throw ArgumentError(
          'there is no icon data. set svgPath or iconData which one.');

    Widget icon;
    if (svgPath != null) {
      icon = SvgPicture.asset(
        svgPath,
        fit: BoxFit.scaleDown,
        color: Colors.white,
      );
    } else {
      // if(iconData != null){
      icon = Icon(
        iconData,
        color: Colors.white,
      );
    }

    return ElevatedButton(
      key: ValueKey<String>(label),
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: MaterialStateProperty.all<Color>(
            AppTheme.getBackgroundColor(context)),
      ),
      child: SizedBox(
        height: 40,
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: iconColor,
                ),
                child: icon,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
