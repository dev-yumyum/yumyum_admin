import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // 로그인
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.authEndpoint}/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );

      // 로그인 성공 시 토큰 저장
      if (apiResponse.isSuccess && apiResponse.data != null) {
        final token = apiResponse.data!['token'] as String?;
        if (token != null) {
          _apiService.setAuthToken(token);
        }
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  // 로그아웃
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _apiService.post('${ApiConfig.authEndpoint}/logout');
      
      // 토큰 제거
      _apiService.clearAuthToken();

      return ApiResponse<void>.fromJson(
        response.data,
        (data) => null,
      );
    } catch (e) {
      // 에러가 발생해도 토큰은 제거
      _apiService.clearAuthToken();
      
      return ApiResponse<void>(
        success: false,
        message: e.toString(),
      );
    }
  }

  // 토큰 갱신
  Future<ApiResponse<Map<String, dynamic>>> refreshToken() async {
    try {
      final response = await _apiService.post('${ApiConfig.authEndpoint}/refresh');
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );

      // 토큰 갱신 성공 시 새 토큰 저장
      if (apiResponse.isSuccess && apiResponse.data != null) {
        final token = apiResponse.data!['token'] as String?;
        if (token != null) {
          _apiService.setAuthToken(token);
        }
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  // 현재 사용자 정보 조회
  Future<ApiResponse<Map<String, dynamic>>> getCurrentUser() async {
    try {
      final response = await _apiService.get('${ApiConfig.authEndpoint}/me');
      
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => Map<String, dynamic>.from(data),
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  // 비밀번호 변경
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.authEndpoint}/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      return ApiResponse<void>.fromJson(
        response.data,
        (data) => null,
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: e.toString(),
      );
    }
  }
}

