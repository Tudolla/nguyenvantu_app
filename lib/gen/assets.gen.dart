/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/ComingSoon-Regular.ttf
  String get comingSoonRegular => 'assets/fonts/ComingSoon-Regular.ttf';

  /// File path: assets/fonts/Kalnia_Expanded-Light.ttf
  String get kalniaExpandedLight => 'assets/fonts/Kalnia_Expanded-Light.ttf';

  /// File path: assets/fonts/LibreBaskerville-Bold.ttf
  String get libreBaskervilleBold => 'assets/fonts/LibreBaskerville-Bold.ttf';

  /// File path: assets/fonts/NerkoOne-Regular.ttf
  String get nerkoOneRegular => 'assets/fonts/NerkoOne-Regular.ttf';

  /// File path: assets/fonts/Oswald-VariableFont_wght.ttf
  String get oswaldVariableFontWght =>
      'assets/fonts/Oswald-VariableFont_wght.ttf';

  /// File path: assets/fonts/Philosopher-Bold.ttf
  String get philosopherBold => 'assets/fonts/Philosopher-Bold.ttf';

  /// File path: assets/fonts/Philosopher-Regular.ttf
  String get philosopherRegular => 'assets/fonts/Philosopher-Regular.ttf';

  /// List of all assets
  List<String> get values => [
        comingSoonRegular,
        kalniaExpandedLight,
        libreBaskervilleBold,
        nerkoOneRegular,
        oswaldVariableFontWght,
        philosopherBold,
        philosopherRegular
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/5898.jpg
  AssetGenImage get a5898 => const AssetGenImage('assets/images/5898.jpg');

  /// File path: assets/images/avatar.png
  AssetGenImage get avatar => const AssetGenImage('assets/images/avatar.png');

  /// File path: assets/images/calendar.jpg
  AssetGenImage get calendar =>
      const AssetGenImage('assets/images/calendar.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [a5898, avatar, calendar];
}

class $AssetsRiveGen {
  const $AssetsRiveGen();

  /// File path: assets/rive/button.riv
  String get button => 'assets/rive/button.riv';

  /// File path: assets/rive/check.riv
  String get check => 'assets/rive/check.riv';

  /// File path: assets/rive/confetti.riv
  String get confetti => 'assets/rive/confetti.riv';

  /// File path: assets/rive/house.riv
  String get house => 'assets/rive/house.riv';

  /// File path: assets/rive/icons.riv
  String get icons => 'assets/rive/icons.riv';

  /// File path: assets/rive/menu_button.riv
  String get menuButton => 'assets/rive/menu_button.riv';

  /// File path: assets/rive/shapes.riv
  String get shapes => 'assets/rive/shapes.riv';

  /// List of all assets
  List<String> get values =>
      [button, check, confetti, house, icons, menuButton, shapes];
}

class $AssetsSoundGen {
  const $AssetsSoundGen();

  /// File path: assets/sound/click.mp3
  String get click => 'assets/sound/click.mp3';

  /// List of all assets
  List<String> get values => [click];
}

class Assets {
  Assets._();

  static const String animation = 'assets/animation.json';
  static const String animationBgLogin = 'assets/animation_bg_login.json';
  static const String arrowRight = 'assets/arrow-right.json';
  static const String bell = 'assets/bell.json';
  static const String bg = 'assets/bg.json';
  static const String book = 'assets/book.json';
  static const String calendar = 'assets/calendar.json';
  static const String company = 'assets/company.json';
  static const String dropdown = 'assets/dropdown.json';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const String mybell = 'assets/mybell.json';
  static const String notification = 'assets/notification.json';
  static const $AssetsRiveGen rive = $AssetsRiveGen();
  static const $AssetsSoundGen sound = $AssetsSoundGen();
  static const String tree = 'assets/tree.json';

  /// List of all assets
  static List<String> get values => [
        animation,
        animationBgLogin,
        arrowRight,
        bell,
        bg,
        book,
        calendar,
        company,
        dropdown,
        mybell,
        notification,
        tree
      ];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
