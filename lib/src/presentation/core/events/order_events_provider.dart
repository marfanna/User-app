import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_events_provider.g.dart';

enum OrderEvent { updated, rejected, undone, transferred }

@Riverpod(keepAlive: true)
class OrderEvents extends _$OrderEvents {
  @override
  (OrderEvent, int)? build() => null;

  int _seq = 0;

  void emit(OrderEvent event) => state = (event, _seq++);
}
