import 'package:dartz/dartz.dart';
import 'package:driver/auth/login_Repo/login_repo.dart';
import 'package:driver/auth/model/login_model.dart';
import 'package:driver/routes/route_name.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/service_locator.dart';
import 'package:driver/services/shared_preference_service.dart';
import 'package:driver/services/toast/app_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState(status: LoginUserStatus.initial)) {
    on<LoginButtonClickEvent>(_loginButtonClickEvent);
  }

  void _loginButtonClickEvent(
    LoginButtonClickEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginUserStatus.loading));
      LoginRepo repo = LoginRepo();
      Either<dynamic, Failure> resp = await repo.loginUser(
        email: event.email,
        password: event.password,
      );
      resp.fold(
        (l) {
          emit(state.copyWith(status: LoginUserStatus.success));
          _onLoginSuccess();
          locator<SharedPrefsServices>().setString(
            key: 'token',
            value: l["data"]["token"],
          );
        },
        (r) {
          emit(state.copyWith(status: LoginUserStatus.failure));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: LoginUserStatus.failure));
    }
  }
}

void _onLoginSuccess() {
  locator<NavigationService>().navigateTo(Routes.homeScreen);
  AppToasts().showToast(message: 'Logged In Successfully', isSuccess: true);
}
