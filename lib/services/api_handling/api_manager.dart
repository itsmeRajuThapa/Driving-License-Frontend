import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:driver/services/api_handling/api_default_headers.dart';
import 'package:driver/services/api_handling/api_interceptors.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiManager {
  Dio? dio;

  ApiManager() {
    final options = BaseOptions(
      baseUrl: 'https://driving-license-21j8.onrender.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: apiDefaultHeaders(),
    );

    dio = Dio(options);
    dio!.interceptors.add(ApiInterceptor(dioInstance: dio));

    dio!.interceptors.add(
      PrettyDioLogger(
        request: false,
        responseBody: false,
        requestBody: false,
        requestHeader: false,
      ),
    );

    // ignore: deprecated_member_use
    (dio?.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (
      HttpClient client,
    ) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
}
