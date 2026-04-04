import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:news_chat_app/constants/api_endpoints.dart';
import 'package:news_chat_app/service/navigation_service.dart';

import '../constants/config.dart';

class CustomHttp {
  static String? get baseUrl => Config.baseUrl;
  static Dio? _dio;
  static bool _isInitialized = false;

  Future<void> initialize() async {
    final effectiveBaseUrl = baseUrl ?? '';

    _dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    _dio!.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          developer.log(object.toString(), name: 'DIO');
          print('[DIO] $object');
        },
      ),
    );

    if (_dio!.httpClientAdapter is IOHttpClientAdapter) {
      (_dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) {
          developer.log(
            '⚠️ SSL Certificate validation bypassed for $host:$port',
            name: 'HTTP',
          );
          return true;
        };
        return client;
      };
    }

    _isInitialized = true;
    developer.log(
      '✅ CustomHttp initialized with baseUrl: $effectiveBaseUrl',
      name: 'HTTP',
    );
    debugPrint(
      '[HTTP] ✅ CustomHttp initialized with baseUrl: $effectiveBaseUrl',
    );
  }

  void _ensureInitialized() {
    if (!_isInitialized || _dio == null) {
      throw Exception(
        'CustomHttp has not been initialized. Call initialize() first.',
      );
    }
  }

  static Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_dio == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'CustomHttp has not been initialized',
        ),
      );
      return;
    }

    developer.log(
      '🚀 ${options.method.toUpperCase()} ${options.uri}',
      name: 'HTTP',
    );
    handler.next(options);
  }

  static Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    developer.log(
      '✅ ${response.statusCode} ${response.requestOptions.uri}',
      name: 'HTTP',
    );

    if (response.statusCode == 401) {
      developer.log(
        '🚫 401 Unauthorized detected in Response, logging out...',
        name: 'AUTH',
      );
      await _logoutUser();

      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Unauthorized',
        ),
      );
      return;
    }

    handler.next(response);
  }

  static Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    developer.log(
      '❌ ${error.type} - ${error.response?.statusCode} ${error.requestOptions.uri}',
      name: 'HTTP',
    );

    if (error.response?.statusCode == 401) {
      developer.log(
        '🚫 401 Unauthorized detected, logging out...',
        name: 'AUTH',
      );
      await _logoutUser();
      return;
    }

    handler.next(error);
  }

  Future<Either<String, T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    required TokenAuth authType,
    required T Function(Map<String, dynamic>) fromJson,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    try {
      _ensureInitialized();

      final requestExtra = {'authType': authType, if (extra != null) ...extra};
      final options = Options(headers: headers, extra: requestExtra);
      Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio!.get(
            endpoint,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.post:
          response = await _dio!.post(
            endpoint,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.patch:
          response = await _dio!.patch(
            endpoint,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.put:
          response = await _dio!.put(
            endpoint,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.delete:
          response = await _dio!.delete(
            endpoint,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
      }

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      developer.log('❌ Unexpected error: $e', name: 'HTTP');
      return const Left('Unexpected error occurred');
    }
  }

  Future<Either<String, List<int>>> requestBytes({
    required String endpoint,
    required HttpMethod method,
    required TokenAuth authType,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    try {
      _ensureInitialized();

      final requestExtra = {'authType': authType, if (extra != null) ...extra};
      final options = Options(
        headers: headers,
        extra: requestExtra,
        responseType: ResponseType.bytes,
      );

      Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio!.get(
            endpoint,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.post:
          response = await _dio!.post(
            endpoint,
            data: body,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        default:
          return const Left('Method not supported for bytes request');
      }

      if (ApiEndpoints.validStatusCodes.contains(response.statusCode)) {
        return Right(response.data as List<int>);
      } else {
        final errorStatusCode = response.statusCode ?? 0;
        final errorMessage = _mapStatusCodeToHumanMessage(errorStatusCode);
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      return _handleDioError<List<int>>(e);
    } catch (e) {
      developer.log('❌ Unexpected error in requestBytes: $e', name: 'HTTP');
      return const Left('Unexpected error occurred');
    }
  }

  Either<String, T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (ApiEndpoints.validStatusCodes.contains(response.statusCode)) {
      try {
        final data = response.data is Map<String, dynamic>
            ? response.data
            : jsonDecode(response.data);
        return Right(fromJson(data));
      } catch (e) {
        developer.log('❌ JSON parsing error: $e', name: 'HTTP');
        final errorStatusCode = response.statusCode ?? 0;
        final errorMessage = _mapStatusCodeToHumanMessage(errorStatusCode);
        return Left(errorMessage);
      }
    } else {
      final errorStatusCode = response.statusCode ?? 0;
      final apiMessage = _extractMessageFromBody(response.data);
      final errorMessage =
          apiMessage ?? _mapStatusCodeToHumanMessage(errorStatusCode);
      return Left(errorMessage);
    }
  }

  String? _extractMessageFromBody(dynamic responseData) {
    try {
      Map<String, dynamic>? bodyMap;
      if (responseData is Map<String, dynamic>) {
        bodyMap = responseData;
      } else if (responseData is String && responseData.isNotEmpty) {
        bodyMap = jsonDecode(responseData) as Map<String, dynamic>?;
      }
      if (bodyMap != null) {
        final msg = bodyMap['message'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
    } catch (_) {}
    return null;
  }

  Either<String, T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const Left("Koneksi timeout saat mencoba menghubungi server.");
      case DioExceptionType.sendTimeout:
        return const Left("Timeout saat mengirim data ke server.");
      case DioExceptionType.receiveTimeout:
        return const Left("Timeout saat menerima data dari server.");
      case DioExceptionType.connectionError:
        return const Left(
          "Tidak dapat terhubung ke server. Periksa koneksi atau server sedang offline.",
        );
      case DioExceptionType.badCertificate:
        return const Left(
          "Gagal verifikasi SSL. Sertifikat server tidak valid.",
        );
      case DioExceptionType.cancel:
        return const Left("Request dibatalkan.");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final errorStatusCode = _mapStatusCodeToHumanMessage(statusCode);
        return Left(errorStatusCode);
      case DioExceptionType.unknown:
        return const Left(
          "Tidak ada koneksi internet atau terjadi kesalahan tak dikenal.",
        );
    }
  }

  String _mapStatusCodeToHumanMessage(int status) {
    switch (status) {
      case 400:
        return "Data yang dikirim tidak valid.";
      case 401:
        return "Sesi Anda berakhir. Silakan login kembali.";
      case 403:
        return "Anda tidak memiliki izin untuk mengakses fitur ini.";
      case 404:
        return "Data tidak ditemukan.";
      case 408:
        return "Server terlalu lama merespons. Coba lagi.";
      case 500:
        return "Terjadi masalah pada server. Silakan coba beberapa saat lagi.";
      case 502:
        return "Koneksi ke server bermasalah. Coba lagi nanti.";
      case 503:
        return "Server sedang offline atau dalam perbaikan.";
      case 504:
        return "Server tidak merespons tepat waktu.";
      default:
        return "Terjadi kesalahan. Silakan coba lagi.";
    }
  }

  static Future<void> _logoutUser() async {
    developer.log('🚪 Logging out user...', name: 'AUTH');
    await NavigationService.navigateToLoginAndRemoveAll();
  }
}

enum HttpMethod { get, post, patch, put, delete }

enum TokenAuth { yes, no, basic, custom }
