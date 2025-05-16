part of 'login_bloc.dart';

enum LoginUserStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginResponse? userdata;
  final LoginUserStatus? status;
  const LoginState({
    this.userdata,
    this.status,
  });
  @override
  List<Object?> get props => [userdata, status];
  LoginState copyWith({
    final LoginResponse? userdata,
    final LoginUserStatus? status,
  }) {
    return LoginState(
        status: status ?? this.status, userdata: userdata ?? this.userdata);
  }
}

// final class LoginInitial extends LoginState {
   // LoginInitial()
  //     : super(status: LoginUserStatus.initial, userdata: );
// }
