import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:driver/services/api_handling/api_default_headers.dart';
import 'package:driver/services/api_handling/api_manager.dart';
import 'package:driver/services/toast/app_toast.dart';
import '../service_locator.dart';
import '../shared_preference_service.dart';

enum ApiMethods { get, post, put, delete }

class ApiResponse {
  static final ApiManager _apiManager = locator<ApiManager>();

  static Future<Response?> getResponse({
    required String endPoint,
    required ApiMethods apiMethods,
    Map<String, dynamic>? queryParams,
    dynamic body,
    Options? options,
    bool shouldCache = false,
  }) async {
    Response? response;
    try {
      switch (apiMethods) {
        case ApiMethods.post:
          response = await _apiManager.dio!.post(
            endPoint,
            data: body,
            queryParameters: queryParams,
            options: options ?? Options(headers: apiDefaultHeaders()),
          );
          break;
        case ApiMethods.put:
          response = await _apiManager.dio!.put(
            endPoint,
            data: body,
            queryParameters: queryParams,
            options: options ?? Options(headers: apiDefaultHeaders()),
          );
          break;
        case ApiMethods.get:
          response = await _apiManager.dio!.get(
            endPoint,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case ApiMethods.delete:
          response = await _apiManager.dio!.delete(
            endPoint,
            queryParameters: queryParams,
            data: body,
            options: options ?? Options(headers: apiDefaultHeaders()),
          );
          break;
      }

      if (response.statusCode == 200 && shouldCache) {
        locator<SharedPrefsServices>().setString(
          key: endPoint,
          value: response.data,
        );
      }
    } on SocketException catch (_) {
      //  log(_.message);
      AppToasts().showToast(
        message: 'No Internet Connection',
        isSuccess: false,
      );
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    return response;
  }
}
