import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checkout_state_providers.g.dart';

@Riverpod(keepAlive: true)
class CheckoutDeliveryCharge extends _$CheckoutDeliveryCharge {
  @override
  double? build() => null;
}

@Riverpod(keepAlive: true)
class CheckoutRiderTip extends _$CheckoutRiderTip {
  @override
  double build() => 0.0;
}

@Riverpod(keepAlive: true)
class CheckoutDiscount extends _$CheckoutDiscount {
  @override
  int build() => 0;
}
