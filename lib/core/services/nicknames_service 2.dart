import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/pagination_model.dart';
import 'api_service.dart';

class NicknamesService {
  final ApiService _apiService = ApiService();

  // 닉네임 목록 조회 (페이지네이션)
  Future<ApiResponse<PaginatedResponse<Map<String, dynamic>>>> getNicknames({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }

      final response = await _apiService.get(
        '/nicknames',
        queryParameters: queryParams,
      );

      return ApiResponse<PaginatedResponse<Map<String, dynamic>>>.fromJson(
        response.data,
        (data) => PaginatedResponse<Map<String, dynamic>>.fromJson(
          data,
          (item) => Map<String, dynamic>.from(item),
        ),
      );
    } catch (e) {
      return ApiResponse<PaginatedResponse<Map<String, dynamic>>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  // 닉네임 상세 조회
  Future<ApiResponse<Map<String, dynamic>>> getNickname(String nicknameId) async {
    try {
      final response = await _apiService.get('/nicknames/$nicknameId');
      
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

  // 닉네임 수정
  Future<ApiResponse<Map<String, dynamic>>> updateNickname(
    String nicknameId,
    Map<String, dynamic> nicknameData,
  ) async {
    try {
      final response = await _apiService.put(
        '/nicknames/$nicknameId',
        data: nicknameData,
      );

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

  // 닉네임 상태 변경
  Future<ApiResponse<Map<String, dynamic>>> updateNicknameStatus(
    String nicknameId,
    String status,
    String reason,
  ) async {
    try {
      final response = await _apiService.put(
        '/nicknames/$nicknameId/status',
        data: {
          'status': status,
          'reason': reason,
        },
      );

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

  // 닉네임 차단
  Future<ApiResponse<Map<String, dynamic>>> banNickname(
    String nicknameId,
    String reason,
  ) async {
    try {
      final response = await _apiService.post(
        '/nicknames/$nicknameId/ban',
        data: {'reason': reason},
      );

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

  // 닉네임 차단 해제
  Future<ApiResponse<Map<String, dynamic>>> unbanNickname(
    String nicknameId,
    String reason,
  ) async {
    try {
      final response = await _apiService.post(
        '/nicknames/$nicknameId/unban',
        data: {'reason': reason},
      );

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

  // 닉네임 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getNicknameStats() async {
    try {
      final response = await _apiService.get('/nicknames/stats');
      
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
}
