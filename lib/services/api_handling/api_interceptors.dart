import 'package:dio/dio.dart';
import 'package:driver/services/service_locator.dart';
import 'package:driver/services/shared_preference_service.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor({this.dioInstance});
  final Dio? dioInstance;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? accessToken = locator<SharedPrefsServices>().getString(
      key: 'token',
    );

    if (accessToken != null) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $accessToken');
    }
    return super.onRequest(options, handler);
  }
}
