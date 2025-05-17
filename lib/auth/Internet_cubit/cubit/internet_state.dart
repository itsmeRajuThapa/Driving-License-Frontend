part of 'internet_cubit.dart';

enum ConnectStatus { connected, unconnected }

class InternetState extends Equatable {
  final ConnectStatus status;

  const InternetState({required this.status});

  const InternetState.initial() : status = ConnectStatus.connected;

  InternetState copyWith({ConnectStatus? status}) {
    return InternetState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
