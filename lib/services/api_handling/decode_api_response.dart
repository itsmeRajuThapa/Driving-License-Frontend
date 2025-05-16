import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:driver/services/toast/app_toast.dart';

Future<Either<dynamic, Failure>> decodingApi(
  Response? response, {
  Function? fromJson,
  String? endPoint,
  String message = '',
}) async {
  List<int> successStatusCode = [200, 201];

  if (response == null) {
    return Right(Failure(
      message: "Something went wrong",
    ));
  } else if (successStatusCode.contains(response.statusCode)) {
    final data = response.data;
    switch (data.runtimeType) {
      case Map _:
        return Left({'data': fromJson!(data), 'message': message});
      case List _:
        List<dynamic> listDataFromApi = data;

        try {
          // final listing = listDataFromApi.map((e) => fromJson!(e)).toList();
          return Left(listDataFromApi);
        } catch (e) {
          log(e.toString());
          return Right(Failure(message: e.toString()));
        }

      default:
        return Left({'data': data, 'message': message});
    }
  } else if (response.statusCode == 500) {
    AppToasts().showToast(message: 'Server Error', isSuccess: false);

    return Left(response.data);
  } else if (response.statusCode == 401) {
    AppToasts().showToast(message: 'Unauthorized', isSuccess: false);
  } else if (response.statusCode == 400) {
    return Right(Failure.fromJson(response.data));
  } else if (response.statusCode == 422) {
    return Right(Failure.fromJson(response.data));
  } else if (response.data == null) {
    return Right(response.data);
  } else {
    return Right(Failure(message: 'Something went wrong'));
  }
  return response.data;
}

Either<dynamic, Failure> handlingParsing(Response response) {
  try {
    return Left(response);
  } catch (e) {
    return Right(Failure(message: 'Parsing Error'));
  }
}
