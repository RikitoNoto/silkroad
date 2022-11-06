
/*
 * Generated file. Do not edit.
 *
 * Locales: 2
 * Strings: 26 (13.0 per locale)
 *
 * Built on 2022-11-06 at 13:18 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale {
	en, // 'en' (base locale, fallback)
	ja, // 'ja'
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_TranslationsEn _t = _currLocale.translations;
_TranslationsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _TranslationsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale useDeviceLocale() {
		final locale = AppLocaleUtils.findDeviceLocale();
		return setLocale(locale);
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

		// force rebuild if TranslationProvider is used
		_translationProviderKey.currentState?.setLocale(_currLocale);

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String rawLocale) {
		final locale = AppLocaleUtils.parse(rawLocale);
		return setLocale(locale);
	}

	/// Gets current locale.
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}
}

/// Provides utility functions without any side effects.
class AppLocaleUtils {
	AppLocaleUtils._(); // no constructor

	/// Returns the locale of the device as the enum type.
	/// Fallbacks to base locale.
	static AppLocale findDeviceLocale() {
		final String? deviceLocale = WidgetsBinding.instance.window.locale.toLanguageTag();
		if (deviceLocale != null) {
			final typedLocale = _selectLocale(deviceLocale);
			if (typedLocale != null) {
				return typedLocale;
			}
		}
		return _baseLocale;
	}

	/// Returns the enum type of the raw locale.
	/// Fallbacks to base locale.
	static AppLocale parse(String rawLocale) {
		return _selectLocale(rawLocale) ?? _baseLocale;
	}
}

// context enums

// interfaces generated as mixins

// translation instances

late _TranslationsEn _translationsEn = _TranslationsEn.build();
late _TranslationsJa _translationsJa = _TranslationsJa.build();

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {

	/// Gets the translation instance managed by this library.
	/// [TranslationProvider] is using this instance.
	/// The plural resolvers are set via [LocaleSettings].
	_TranslationsEn get translations {
		switch (this) {
			case AppLocale.en: return _translationsEn;
			case AppLocale.ja: return _translationsJa;
		}
	}

	/// Gets a new translation instance.
	/// [LocaleSettings] has no effect here.
	/// Suitable for dependency injection and unit tests.
	///
	/// Usage:
	/// final t = AppLocale.en.build(); // build
	/// String a = t.my.path; // access
	_TranslationsEn build() {
		switch (this) {
			case AppLocale.en: return _TranslationsEn.build();
			case AppLocale.ja: return _TranslationsJa.build();
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
			case AppLocale.ja: return 'ja';
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return const Locale.fromSubtags(languageCode: 'en');
			case AppLocale.ja: return const Locale.fromSubtags(languageCode: 'ja');
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
			case 'ja': return AppLocale.ja;
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();

	static _InheritedLocaleData of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget;
	}
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	Locale get flutterLocale => locale.flutterLocale; // shortcut
	final _TranslationsEn translations; // store translations to avoid switch call

	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization feature not used

// helpers

final _localeRegex = RegExp(r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);
		final country = match.group(5);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}

		if (selected == null && country != null) {
			// match country
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.contains(country) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

// Path: <root>
class _TranslationsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsEn.build();

	/// Access flat map
	dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	late final Map<String, dynamic> _flatMap = _buildFlatMap();

	late final _TranslationsEn _root = this; // ignore: unused_field

	// Translations
	late final _TranslationsActionsEn actions = _TranslationsActionsEn._(_root);
	late final _TranslationsSendEn send = _TranslationsSendEn._(_root);
	late final _TranslationsParamsEn params = _TranslationsParamsEn._(_root);
}

// Path: actions
class _TranslationsActionsEn {
	_TranslationsActionsEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get send => 'Send';
	String get receive => 'Receive';
	String get option => 'Option';
}

// Path: send
class _TranslationsSendEn {
	_TranslationsSendEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get receiverAddress => 'Receiver Ipaddress';
	String get selectFile => 'select file';
	String get fileNone => 'No select';
	String get sendableAddress => 'Sendable Destination';
	late final _TranslationsSendSendResultEn sendResult = _TranslationsSendSendResultEn._(_root);
}

// Path: params
class _TranslationsParamsEn {
	_TranslationsParamsEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get name => 'Your name';
	String get port => 'Port number';
}

// Path: send.sendResult
class _TranslationsSendSendResultEn {
	_TranslationsSendSendResultEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get success => 'send complete';
	String get connectionFail => 'send failed. please check the devices are in same network.';
	String get lostFile => 'did not find the file.';
	String get sendFail => 'did not send the file to the connected device.';
}

// Path: <root>
class _TranslationsJa implements _TranslationsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsJa.build();

	/// Access flat map
	@override dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	@override late final Map<String, dynamic> _flatMap = _buildFlatMap();

	@override late final _TranslationsJa _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsActionsJa actions = _TranslationsActionsJa._(_root);
	@override late final _TranslationsSendJa send = _TranslationsSendJa._(_root);
	@override late final _TranslationsParamsJa params = _TranslationsParamsJa._(_root);
}

// Path: actions
class _TranslationsActionsJa implements _TranslationsActionsEn {
	_TranslationsActionsJa._(this._root);

	@override final _TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get send => '送信';
	@override String get receive => '受信';
	@override String get option => '設定';
}

// Path: send
class _TranslationsSendJa implements _TranslationsSendEn {
	_TranslationsSendJa._(this._root);

	@override final _TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get receiverAddress => '受信者のIPアドレス';
	@override String get selectFile => 'ファイルを選択';
	@override String get fileNone => 'ファイル無し';
	@override String get sendableAddress => '送信可能アドレス';
	@override late final _TranslationsSendSendResultJa sendResult = _TranslationsSendSendResultJa._(_root);
}

// Path: params
class _TranslationsParamsJa implements _TranslationsParamsEn {
	_TranslationsParamsJa._(this._root);

	@override final _TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '名前';
	@override String get port => 'ポート番号';
}

// Path: send.sendResult
class _TranslationsSendSendResultJa implements _TranslationsSendSendResultEn {
	_TranslationsSendSendResultJa._(this._root);

	@override final _TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get success => '送信完了しました';
	@override String get connectionFail => '送信失敗しました。同じネットワーク内にいることを確認してください。';
	@override String get lostFile => 'ファイルがありません。';
	@override String get sendFail => '接続先のデバイスに送信できません。';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _TranslationsEn {
	Map<String, dynamic> _buildFlatMap() {
		return <String, dynamic>{
			'actions.send': 'Send',
			'actions.receive': 'Receive',
			'actions.option': 'Option',
			'send.receiverAddress': 'Receiver Ipaddress',
			'send.selectFile': 'select file',
			'send.fileNone': 'No select',
			'send.sendableAddress': 'Sendable Destination',
			'send.sendResult.success': 'send complete',
			'send.sendResult.connectionFail': 'send failed. please check the devices are in same network.',
			'send.sendResult.lostFile': 'did not find the file.',
			'send.sendResult.sendFail': 'did not send the file to the connected device.',
			'params.name': 'Your name',
			'params.port': 'Port number',
		};
	}
}

extension on _TranslationsJa {
	Map<String, dynamic> _buildFlatMap() {
		return <String, dynamic>{
			'actions.send': '送信',
			'actions.receive': '受信',
			'actions.option': '設定',
			'send.receiverAddress': '受信者のIPアドレス',
			'send.selectFile': 'ファイルを選択',
			'send.fileNone': 'ファイル無し',
			'send.sendableAddress': '送信可能アドレス',
			'send.sendResult.success': '送信完了しました',
			'send.sendResult.connectionFail': '送信失敗しました。同じネットワーク内にいることを確認してください。',
			'send.sendResult.lostFile': 'ファイルがありません。',
			'send.sendResult.sendFail': '接続先のデバイスに送信できません。',
			'params.name': '名前',
			'params.port': 'ポート番号',
		};
	}
}
