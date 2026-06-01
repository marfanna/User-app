part of 'button.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.comfortable({
    super.key,
    this.title,
    this.content,
    this.onPressed,
  }) : padding = null,
       backgroundColor = null,
       borderRadius = null,
       expand = true,
       hasShadow = true,
       _variant = _ButtonSizeVariant.comfortable;

  const PrimaryButton.compact({
    super.key,
    this.title,
    this.content,
    this.onPressed,
  }) : padding = null,
       backgroundColor = null,
       borderRadius = null,
       expand = true,
       hasShadow = true,
       _variant = _ButtonSizeVariant.compact;

  const PrimaryButton.vanilla({
    super.key,
    this.title,
    this.content,
    this.onPressed,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.expand = true,
    this.hasShadow = true,
  }) : _variant = _ButtonSizeVariant.vanilla;

  final String? title;
  final Widget? content;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool? expand;
  final bool? hasShadow;
  final double? borderRadius;
  final _ButtonSizeVariant _variant;

  BoxDecoration _getBackgroundDecoration(
    BuildContext context,
    Set<WidgetState> states,
  ) {
    final colors = context.color;
    final radius = BorderRadius.circular(_variant.radius);

    if (states.contains(WidgetState.disabled)) {
      return BoxDecoration(
        color: colors.background.surfaceVariant,
        borderRadius: radius,
      );
    }

    return BoxDecoration(
      borderRadius: radius,
      gradient: RadialGradient(
        center: const Alignment(-0.27, -0.27),
        radius: 2.0,
        colors: colors.background.surfaceContainerGradient,
        stops: const [0.0, 1.0],
      ),
      boxShadow: hasShadow == true
          ? [
              BoxShadow(
                color: colors.elevation.elevationMedium,
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ]
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final borderRadius = BorderRadius.circular(
      this.borderRadius ?? _variant.radius,
    );

    final backgroundColor =
        this.backgroundColor ?? colors.background.transparent;

    final padding =
        this.padding ??
        EdgeInsets.symmetric(horizontal: _variant.horizontalPadding);

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        backgroundBuilder: this.backgroundColor != null
            ? null
            : (context, states, child) {
                return DecoratedBox(
                  decoration: _getBackgroundDecoration(context, states),
                  child: child,
                );
              },
        foregroundColor: colors.text.inverse,
        disabledForegroundColor: colors.text.disabled,
        shadowColor: colors.elevation.transparent,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        minimumSize: expand == true
            ? Size(_variant.width, _variant.height)
            : null,
        fixedSize: Size.fromHeight(_variant.height),
      ),
      child: content ?? TitleText.mediumInverse(title!),
    );
  }
}
