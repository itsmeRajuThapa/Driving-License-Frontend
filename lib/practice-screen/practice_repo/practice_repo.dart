import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:driver/services/api_handling/decode_api_response.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:driver/services/api_handling/network_reponse.dart';

class PracticeRepo {
  static const String _practice = '/quizzes/random-questions';
  static const String _submitdata = '/quizzes/submit-quiz';

  Future<Either<dynamic, Failure>> fetchpracticedata() async {
    final response = await ApiResponse.getResponse(
      endPoint: _practice,
      apiMethods: ApiMethods.get,
    );

    return decodingApi(response);
  }

  Future<Either<dynamic, Failure>> submitanswer(
    List<Map<String, String>> responses,
  ) async {
    print('Full submission: ${jsonEncode({"responses": responses})}');

    final responsee = await ApiResponse.getResponse(
      endPoint: _submitdata,
      apiMethods: ApiMethods.post,
      body: {"responses": responses},

      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return decodingApi(responsee); // Remove fromJson, expect Map
  }
}
