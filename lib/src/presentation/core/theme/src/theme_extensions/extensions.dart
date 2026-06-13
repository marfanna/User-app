import 'src/colors/colors.dart';
import 'src/dimensions.dart';
import 'src/text_style.dart';

export 'src/app_colors.dart';
export 'src/colors/colors.dart';
export 'src/dimensions.dart';
export 'src/gradients.dart';
export 'src/text_style.dart';

mixin ThemeExtensions {
  final ColorExtension colors = const ColorExtension();
  final TextStyleExtension textStyle = const TextStyleExtension();
  final Dimensions dimensions = const Dimensions();
}
