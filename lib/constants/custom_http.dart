import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:news_chat_app/constants/api_endpoints.dart';
import 'package:news_chat_app/service/navigation_service.dart';

import '../constants/config.dart';

class CustomHttp {
  static String? baseUrl = Config.baseUrl;
  static Dio? _dio;
  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;
  static final List<Map<String, dynamic>> _failedRequests = [];
  static bool _isInitialized = false;

  // 🔐 Basic Auth Credentials
  static String _basicAuthUsername = '';
  static String _basicAuthPassword = '';

  Future<void> initialize() async {
    // Use default URL if baseUrl is null
    final effectiveBaseUrl = baseUrl ?? '';

    _dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          // Accept all status codes to handle them manually
          return status != null && status < 500;
        },
      ),
    );

    // Add interceptors
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Add logging interceptor
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
          // Also print to console for production debugging
          print('[DIO] $object');
        },
      ),
    );

    // Configure HTTP client for Android release builds
    // This helps with SSL certificate issues
    if (_dio!.httpClientAdapter is IOHttpClientAdapter) {
      (_dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) {
          developer.log(
            '⚠️ SSL Certificate validation bypassed for $host:$port',
            name: 'HTTP',
          );
          // In production, you should validate the certificate properly
          // For now, we'll accept all certificates to debug the issue
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
    print('[HTTP] ✅ CustomHttp initialized with baseUrl: $effectiveBaseUrl');
  }

  // Ensure _dio is initialized before use
  void _ensureInitialized() {
    developer.log('✅✅_isInitialized $_isInitialized');
    if (!_isInitialized || _dio == null) {
      throw Exception(
        'CustomHttp has not been initialized. Call initialize() first.',
      );
    }
  }

  static void setBasicAuthCredentials({String? username, String? password}) {
    if (username != null) _basicAuthUsername = username;
    if (password != null) _basicAuthPassword = password;
    developer.log(
      '🔐 Basic Auth credentials updated: $_basicAuthUsername:******',
      name: 'AUTH',
    );
  }

  static Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Ensure _dio is initialized
    if (_dio == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'CustomHttp has not been initialized',
        ),
      );
      return;
    }
    // Add language header

    // Handle different auth types
    final authType = options.extra['authType'] ?? TokenAuth.no;

    switch (authType) {
      case TokenAuth.yes:
        await _addBearerToken(options);
        break;
      case TokenAuth.basic:
        _addBasicAuth(options);
        break;
      case TokenAuth.custom:
        _addCustomAuth(options);
        break;
      case TokenAuth.no:
        // No auth needed
        break;
    }

    developer.log(
      '🚀 ${options.method.toUpperCase()} ${options.uri}',
      name: 'HTTP',
    );
    developer.log('🔐 Auth Type: $authType', name: 'HTTP');
    handler.next(options);
  }

  static Future<void> _addBearerToken(RequestOptions options) async {}

  static void _addBasicAuth(RequestOptions options) {
    final credentials = '$_basicAuthUsername:$_basicAuthPassword';
    final basicAuth = 'Basic ${base64Encode(utf8.encode(credentials))}';
    options.headers['Authorization'] = basicAuth;
    developer.log('🔑 Basic Auth added', name: 'AUTH');
  }

  static void _addCustomAuth(RequestOptions options) {
    final customHeaders =
        options.extra['customHeaders'] as Map<String, String>?;
    if (customHeaders != null) {
      options.headers.addAll(customHeaders);
      developer.log('🔧 Custom Headers added: $customHeaders', name: 'AUTH');
    }
  }

  static Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // START TEST: Simulate HTTP Errors (For Debugging Only)
    // Uncomment ONE of the lines below to simulate a specific error code

    // response.statusCode = 400; // Bad Request
    // response.statusCode = 401; // Unauthorized
    // response.statusCode = 403; // Forbidden
    // response.statusCode = 404; // Not Found
    // response.statusCode = 408; // Request Timeout
    // response.statusCode = 500; // Internal Server Error
    // response.statusCode = 502; // Bad Gateway
    // response.statusCode = 503; // Service Unavailable
    // response.statusCode = 504; // Gateway Timeout
    // response.statusCode = 520; // Default Error (Unknown)

    // END TEST

    developer.log(
      '✅ ${response.statusCode} ${response.requestOptions.uri}',
      name: 'HTTP',
    );

    // Handle 401 Unauthorized (because validateStatus < 500 allows it here)
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

    // Handle token expiration only for Bearer Token requests
    // final authType = error.requestOptions.extra['authType'] ?? TokenAuth.no;
    // if (authType == TokenAuth.yes && error.response?.statusCode == 401) {
    //   final isTokenExpired = _isTokenExpiredError(error);

    //   if (isTokenExpired) {
    //     // Queue the failed request
    //     _failedRequests.add({
    //       'options': error.requestOptions,
    //       'handler': handler,
    //     });

    //     // Try to refresh token
    //     final refreshSuccess = await _handleTokenRefresh();

    //     if (refreshSuccess) {
    //       // Retry all failed requests with new token
    //       await _retryFailedRequests();
    //     } else {
    //       // Clear all requests and logout
    //       _failedRequests.clear();
    //       await _logoutUser();
    //     }
    //     return;
    //   }
    // }
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

  static bool _isTokenExpiredError(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map) {
      final message =
          responseData['errors']?['message']?.toString().toLowerCase() ?? '';
      return message.contains('token') || message.contains('unauthorized');
    }
    return false;
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
      developer.log('✅✅ endpoint = $endpoint');
      developer.log('✅✅ method = $method');
      developer.log('✅✅ authType = $authType');
      developer.log('✅✅ fromJson = ${fromJson.toString()}');
      developer.log('✅✅ body = ${body.toString()}');
      // Ensure _dio is initialized
      _ensureInitialized();

      // Merge extra parameters
      final requestExtra = {'authType': authType, if (extra != null) ...extra};

      final options = Options(headers: headers, extra: requestExtra);
      developer.log('✅✅ requestExtra = ${requestExtra.toString()}');
      developer.log('✅✅ options = ${options.toString()}');
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
          developer.log('✅✅ HttpMethod.post = $response}');
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
      return Left('Unexpected error occurred');
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
    developer.log('✅✅✅ response = $response}');
    developer.log('✅✅✅ fromJson = $fromJson}');
    developer.log('✅✅✅ statusCode = ${response.statusCode}');
    if (ApiEndpoints.validStatusCodes.contains(response.statusCode)) {
      try {
        final data = response.data is Map<String, dynamic>
            ? response.data
            : jsonDecode(response.data);
        developer.log('✅✅✅ response.data = ${data.toString()}');
        developer.log('✅✅✅ data.runtimeType = ${data.runtimeType}');
        return Right(fromJson(data));
      } catch (e) {
        developer.log('❌ JSON parsing error: $e', name: 'HTTP');
        // return Left('Failed to parse response');
        final errorStatusCode = response.statusCode ?? 0;
        final errorMessage = _mapStatusCodeToHumanMessage(errorStatusCode);
        return Left(errorMessage);
      }
    } else {
      final errorStatusCode = response.statusCode ?? 0;
      // Try to extract message from the API response body first
      final apiMessage = _extractMessageFromBody(response.data);
      final errorMessage =
          apiMessage ?? _mapStatusCodeToHumanMessage(errorStatusCode);
      return Left(errorMessage);
    }
  }

  /// Tries to extract the `message` field from an error response body.
  /// Returns null if the body cannot be parsed or has no `message`.
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
        return Left("Koneksi timeout saat mencoba menghubungi server.");

      case DioExceptionType.sendTimeout:
        return Left("Timeout saat mengirim data ke server.");

      case DioExceptionType.receiveTimeout:
        return Left("Timeout saat menerima data dari server.");

      case DioExceptionType.connectionError:
        return Left(
          "Tidak dapat terhubung ke server. Periksa koneksi atau server sedang offline.",
        );

      case DioExceptionType.badCertificate:
        return Left("Gagal verifikasi SSL. Sertifikat server tidak valid.");

      case DioExceptionType.cancel:
        return Left("Request dibatalkan.");

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        // Server memberikan response error (400-500)
        final errorStatusCode = _mapStatusCodeToHumanMessage(statusCode);
        return Left(errorStatusCode);
      // return Left("Server error ($status): $msg");

      case DioExceptionType.unknown:
        return Left(
          "Tidak ada koneksi internet atau terjadi kesalahan tak dikenal.",
        );

      // default:
      //   final msg = _extractErrorMessage(error.response?.data);
      //   return Left("Kesalahan tidak diketahui: $msg");
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

  // String _extractErrorMessage(dynamic responseData) {
  //   try {
  //     if (responseData is Map) {
  //       return responseData['errors']?['message']?.toString() ??
  //           responseData['message']?.toString() ??
  //           'Request failed';
  //     } else if (responseData is String) {
  //       final parsed = jsonDecode(responseData);
  //       return parsed['errors']?['message']?.toString() ??
  //           parsed['message']?.toString() ??
  //           'Request failed';
  //     }
  //   } catch (e) {
  //     developer.log('Error extracting error message: $e', name: 'HTTP');
  //   }
  //   return 'Request failed';
  // }

  static Future<bool> _handleTokenRefresh() async {
    if (_isRefreshing) {
      developer.log("⏳ Waiting for existing token refresh...", name: 'AUTH');
      return await _refreshCompleter?.future ?? false;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    bool success = false;
    try {
      success = await _refreshToken();
    } catch (e) {
      developer.log('❌ Token refresh error: $e', name: 'AUTH');
      success = false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter?.complete(success);
      _refreshCompleter = null;
    }

    return success;
  }

  static Future<bool> _refreshToken() async {
    try {
      // final langCode = await getLocale();
      // final response = await _dio.post(
      //   ApiServices.refreshToken,
      //   data: RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
      //   options: Options(headers: {
      //     'accept-language': langCode.languageCode,
      //   }),
      // );

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   final model = RefreshTokenResponse2Model.fromJson(response.data);

      //   if (model.isSuccess) {
      //     final accessToken = model.data?.accessToken;
      //     final newRefreshToken = model.data?.refreshToken;

      //     if (accessToken != null && newRefreshToken != null) {
      //       await LocalDatasource().saveToken(accessToken);
      //       await LocalDatasource().saveRefreshToken(newRefreshToken);
      //       developer.log('✅ Token refreshed successfully', name: 'AUTH');
      //       return true;
      //     } else {
      //       developer.log('⚠️ New tokens are null in response', name: 'AUTH');
      //     }
      //   } else {
      //     developer.log('❌ Refresh token failed: ${model.message}', name: 'AUTH');
      //   }
      // } else {
      //   developer.log('❌ Refresh token failed with status: ${response.statusCode}', name: 'AUTH');
      // }

      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        developer.log('🚫 Refresh token invalid, logging out...', name: 'AUTH');
        await _logoutUser();
      }
      return false;
    }
  }

  static Future<void> _retryFailedRequests() async {
    if (_failedRequests.isEmpty) {
      developer.log('✅ No failed requests to retry', name: 'HTTP');
      return;
    }

    developer.log(
      '🔄 Retrying ${_failedRequests.length} failed requests...',
      name: 'HTTP',
    );
    final requestsToRetry = List<Map<String, dynamic>>.from(_failedRequests);
    _failedRequests.clear();

    for (final request in requestsToRetry) {
      final options = request['options'] as RequestOptions;
      final handler = request['handler'] as ErrorInterceptorHandler;

      try {
        // Retry the request
        final response = await _dio!.fetch(options);
        developer.log('✅ Retry successful for ${options.uri}', name: 'HTTP');
        handler.resolve(response);
      } catch (e) {
        developer.log('❌ Retry failed for ${options.uri}: $e', name: 'HTTP');
        handler.next(DioException(requestOptions: options, error: e));
      }
    }
  }

  static Future<void> _logoutUser() async {
    developer.log('🚪 Logging out user...', name: 'AUTH');
    await NavigationService.navigateToLoginAndRemoveAll();
  }

  static void clearFailedRequests() {
    _failedRequests.clear();
    developer.log('🧹 Cleared all failed requests', name: 'HTTP');
  }

  static Map<String, String> getBasicAuthCredentials() {
    return {'username': _basicAuthUsername, 'password': '••••••••'};
  }
}

enum HttpMethod { get, post, patch, put, delete }

enum TokenAuth {
  yes, // Bearer Token
  no, // No Auth
  basic, // Basic Auth
  custom, // Custom Header
}
