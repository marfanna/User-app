part of 'button.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton.comfortable({
    super.key,
    this.title,
    this.content,
    this.onPressed,
  }) : padding = null,
       backgroundColor = null,
       expand = true,
       hasShadow = false,
       _variant = _ButtonSizeVariant.comfortable;

  const SecondaryButton.compact({
    super.key,
    this.title,
    this.content,
    this.onPressed,
  }) : padding = null,
       backgroundColor = null,
       expand = true,
       hasShadow = false,
       _variant = _ButtonSizeVariant.compact;

  const SecondaryButton.vanilla({
    super.key,
    this.title,
    this.content,
    this.onPressed,
    this.padding,
    this.backgroundColor,
    this.expand = true,
    this.hasShadow = false,
  }) : _variant = _ButtonSizeVariant.vanilla;

  final String? title;
  final Widget? content;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool? expand;
  final bool? hasShadow;
  final _ButtonSizeVariant _variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final borderRadius = BorderRadius.circular(_variant.radius);

    final backgroundColor = this.backgroundColor ?? colors.background.surface;

    final padding =
        this.padding ??
        EdgeInsets.symmetric(horizontal: _variant.horizontalPadding);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: colors.text.primary,
        disabledForegroundColor: colors.text.disabled,
        shadowColor: hasShadow == true
            ? colors.elevation.elevationMedium
            : colors.elevation.transparent,
        elevation: hasShadow == true ? 2 : 0,
        padding: padding,
        side: BorderSide(
          color: onPressed == null
              ? colors.border.disabled
              : colors.border.focus,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        minimumSize: expand == true
            ? Size(_variant.width, _variant.height)
            : null,
        fixedSize: Size.fromHeight(_variant.height),
      ),
      child: content ?? TitleText.mediumBrand(title!),
    );
  }
}
