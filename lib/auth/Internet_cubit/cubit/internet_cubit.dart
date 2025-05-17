import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  late final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;

  InternetCubit() : super(const InternetState.initial()) {
    _connectivity = Connectivity();
    _initialize();
  }

  void _initialize() async {
    final result = await _connectivity.checkConnectivity();
    _emitFromResult(result);

    _subscription = _connectivity.onConnectivityChanged.listen(_emitFromResult);
  }

  void _emitFromResult(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      emit(state.copyWith(status: ConnectStatus.connected));
    } else {
      emit(state.copyWith(status: ConnectStatus.unconnected));
    }
  }

  /// 🔁 Called manually by a retry button or user action
  Future<void> checkConnectivityManually() async {
    final result = await _connectivity.checkConnectivity();
    _emitFromResult(result);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
