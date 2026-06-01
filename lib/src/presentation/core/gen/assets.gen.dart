// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/bkash.svg
  SvgGenImage get bkash => const SvgGenImage('assets/icons/bkash.svg');

  /// File path: assets/icons/clear.svg
  SvgGenImage get clear => const SvgGenImage('assets/icons/clear.svg');

  /// File path: assets/icons/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/home.svg');

  /// File path: assets/icons/left_arrow.svg
  SvgGenImage get leftArrow => const SvgGenImage('assets/icons/left_arrow.svg');

  /// File path: assets/icons/location.svg
  SvgGenImage get location => const SvgGenImage('assets/icons/location.svg');

  /// File path: assets/icons/location_outlined.svg
  SvgGenImage get locationOutlined =>
      const SvgGenImage('assets/icons/location_outlined.svg');

  /// File path: assets/icons/notification.svg
  SvgGenImage get notification =>
      const SvgGenImage('assets/icons/notification.svg');

  /// File path: assets/icons/order.svg
  SvgGenImage get order => const SvgGenImage('assets/icons/order.svg');

  /// File path: assets/icons/profile.svg
  SvgGenImage get profile => const SvgGenImage('assets/icons/profile.svg');

  /// File path: assets/icons/right_arrow.svg
  SvgGenImage get rightArrow =>
      const SvgGenImage('assets/icons/right_arrow.svg');

  /// File path: assets/icons/statistic.svg
  SvgGenImage get statistic => const SvgGenImage('assets/icons/statistic.svg');

  /// File path: assets/icons/swipe_left.svg
  SvgGenImage get swipeLeft => const SvgGenImage('assets/icons/swipe_left.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    bkash,
    clear,
    home,
    leftArrow,
    location,
    locationOutlined,
    notification,
    order,
    profile,
    rightArrow,
    statistic,
    swipeLeft,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/explore
  $AssetsImagesExploreGen get explore => const $AssetsImagesExploreGen();

  /// File path: assets/images/rider.png
  AssetGenImage get rider => const AssetGenImage('assets/images/rider.png');

  /// List of all assets
  List<AssetGenImage> get values => [rider];
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/Hub.png
  AssetGenImage get hub => const AssetGenImage('assets/logo/Hub.png');

  /// File path: assets/logo/User.png
  AssetGenImage get user => const AssetGenImage('assets/logo/User.png');

  /// File path: assets/logo/duare_logo.png
  AssetGenImage get duareLogo =>
      const AssetGenImage('assets/logo/duare_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [hub, user, duareLogo];
}

class $AssetsImagesExploreGen {
  const $AssetsImagesExploreGen();

  /// File path: assets/images/explore/cylinder.png
  AssetGenImage get cylinder =>
      const AssetGenImage('assets/images/explore/cylinder.png');

  /// File path: assets/images/explore/laundry.png
  AssetGenImage get laundry =>
      const AssetGenImage('assets/images/explore/laundry.png');

  /// File path: assets/images/explore/mart.png
  AssetGenImage get mart =>
      const AssetGenImage('assets/images/explore/mart.png');

  /// File path: assets/images/explore/medicine.png
  AssetGenImage get medicine =>
      const AssetGenImage('assets/images/explore/medicine.png');

  /// File path: assets/images/explore/restaurants.png
  AssetGenImage get restaurants =>
      const AssetGenImage('assets/images/explore/restaurants.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    cylinder,
    laundry,
    mart,
    medicine,
    restaurants,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

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
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
