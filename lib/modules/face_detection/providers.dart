import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class TimerHandler extends _$TimerHandler {
  @override
  int build() {
    return 5;
  }

  void decrement() {
    if (state > 0) {
      state = state - 1;
    }
  }

  void reset() {
    state = 5;
  }
}
