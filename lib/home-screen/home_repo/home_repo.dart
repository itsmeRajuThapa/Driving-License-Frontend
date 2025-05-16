import 'package:dartz/dartz.dart';
import 'package:driver/services/api_handling/decode_api_response.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:driver/services/api_handling/network_reponse.dart';

class HomeRepo {
  static const String _home = '/quizzes';

  Future<Either<dynamic, Failure>> fetchdata() async {
    final response = await ApiResponse.getResponse(
      endPoint: _home,
      apiMethods: ApiMethods.get,
    );

    return decodingApi(response);
  }
}
