import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _authToken;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.currentBaseUrl,
      connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
      headers: ApiConfig.defaultHeaders,
    ));

    // 인터셉터 추가
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  // 인증 토큰 설정
  void setAuthToken(String token) {
    _authToken = token;
  }

  // 인증 토큰 제거
  void clearAuthToken() {
    _authToken = null;
  }

  // GET 요청
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST 요청
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT 요청
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE 요청
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 파일 업로드
  Future<Response> uploadFile(String path, String filePath, {String fieldName = 'file'}) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
      });
      return await _dio.post(path, data: formData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 에러 처리
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('네트워크 연결 시간이 초과되었습니다.');
        case DioExceptionType.badResponse:
          return Exception('서버 오류: ${error.response?.statusCode}');
        case DioExceptionType.cancel:
          return Exception('요청이 취소되었습니다.');
        case DioExceptionType.connectionError:
          return Exception('네트워크 연결에 실패했습니다.');
        default:
          return Exception('알 수 없는 오류가 발생했습니다.');
      }
    }
    return Exception('알 수 없는 오류가 발생했습니다.');
  }
}

// 인증 인터셉터
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiService = ApiService();
    if (apiService._authToken != null) {
      options.headers['Authorization'] = 'Bearer ${apiService._authToken}';
    }
    super.onRequest(options, handler);
  }
}

// 로깅 인터셉터
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🚀 API Request: ${options.method} ${options.uri}');
    if (options.data != null) {
      print('📤 Request Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ API Response: ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ API Error: ${err.message}');
    super.onError(err, handler);
  }
}

// 에러 인터셉터
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 Unauthorized 처리
    if (err.response?.statusCode == 401) {
      // 로그인 페이지로 리다이렉트 또는 토큰 갱신 로직
      print('🔒 인증이 필요합니다. 로그인 페이지로 이동합니다.');
    }
    super.onError(err, handler);
  }
}

