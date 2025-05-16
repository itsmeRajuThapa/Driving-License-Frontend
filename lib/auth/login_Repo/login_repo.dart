import 'package:dartz/dartz.dart';
import 'package:driver/services/api_handling/decode_api_response.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:driver/services/api_handling/network_reponse.dart';

class LoginRepo {
  static const String _login = 'auth/sign-in';
  Future<Either<dynamic, Failure>> loginUser({
    required String email,
    required String password,
  }) async {
    final respons = await ApiResponse.getResponse(
      endPoint: _login,
      apiMethods: ApiMethods.post,
      body: {"email": email, "password": password},
    );

    return decodingApi(respons);
  }
}
