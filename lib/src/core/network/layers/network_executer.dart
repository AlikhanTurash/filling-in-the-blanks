
import 'package:dio/dio.dart';
import 'package:fitb_pantry_app/src/core/error/network_error/network_exception.dart';
import 'package:fitb_pantry_app/src/core/network/interfaces/base_client_generator.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_connectivity.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_creator.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_decoder.dart';
import 'package:fitb_pantry_app/src/core/network/layers/network_options/network_options.dart';
import 'package:fitb_pantry_app/src/core/network/result.dart';
import 'package:fitb_pantry_app/src/core/utils/error_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:l/l.dart';

class NetworkExecuter {
  final Dio _dio;

  final NetworkCreator _creator;
  final NetworkConnectivity _connectivity;

  NetworkExecuter({
    required Dio dio,
    required NetworkDecoder decoder,
    required NetworkCreator creator,
    required NetworkConnectivity networkConnectivity,
  })  : _dio = dio,
        _creator = creator,
        _connectivity = networkConnectivity;

  bool _isTimeOut(DioException err) =>
      err.type == DioExceptionType.receiveTimeout ||
      err.type == DioExceptionType.sendTimeout ||
      err.type == DioExceptionType.connectionTimeout;

  Future<Result<K>> produce<K>({
    required BaseClientGenerator route,
    NetworkOptions? options,
  }) async {
    if (kDebugMode) {
      l.d(route);
    }

    if (await _connectivity.status) {
      try {
        final response =
            await _creator.request(route: route, options: options, dio: _dio);
        late final responseMap;
        final List<dynamic> responseList = [];

        if (response.data is List<dynamic>) {
          (response.data as List<dynamic>).forEach((element) {
            responseList.add(element);
          });
          return Result.success(responseList as K);
        } else if (response.data is Map<String, dynamic>) {
          responseMap = response.data as Map<String, dynamic>;
          return Result<K>.success(responseMap as K);
        }

        return Result<K>.failure(
            NetworkException.type(error: "something went wrong"));

        /// Dio error
      } on DioException catch (err) {
        if (kDebugMode) {
          l.d('$route => ${NetworkException.request(error: err)}');
        }

        return _isTimeOut(err)
            ? Result<K>.failure(const NetworkException.timeOut())
            : Result<K>.failure(NetworkException.request(error: err));

        /// dynamic error
      } on Object catch (e, stackTrace) {
        if (kDebugMode) {
          l.d('$route => ${NetworkException.type(error: e.toString())}');
        }

        /// Отправляем ошибку в Sentry
        await ErrorUtil.logError(
          e,
          stackTrace: stackTrace,
          hint: '$route => ${NetworkException.type(error: e.toString())}',
        );

        return Result<K>.failure(NetworkException.type(error: e.toString()));
      }

      /// No Internet Connection
    } else {
      if (kDebugMode) {
        l.d(const NetworkException.connectivity());
      }

      return Result<K>.failure(const NetworkException.connectivity());
    }
  }
}
