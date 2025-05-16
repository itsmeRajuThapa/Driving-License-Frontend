import 'package:dartz/dartz.dart';
import 'package:driver/services/api_handling/decode_api_response.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:driver/services/api_handling/network_reponse.dart';

class QuestionRepo {
  //static const String _home = "/quizzes/title/";

  Future<Either<dynamic, Failure>> fetchquestiondata({required String title}) async {
    String question = "/quizzes/title/$title";
    final response = await ApiResponse.getResponse(
      endPoint: question,
      apiMethods: ApiMethods.get,
    );

    return decodingApi(response);
  }
}
