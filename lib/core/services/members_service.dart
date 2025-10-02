import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/pagination_model.dart';
import 'api_service.dart';

class MembersService {
  final ApiService _apiService = ApiService();

  // 회원 목록 조회 (페이지네이션)
  Future<ApiResponse<PaginatedResponse<Map<String, dynamic>>>> getMembers({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? membershipLevel,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      
      if (membershipLevel != null && membershipLevel.isNotEmpty) {
        queryParams['membershipLevel'] = membershipLevel;
      }

      final response = await _apiService.get(
        ApiConfig.membersEndpoint,
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

  // 회원 상세 조회
  Future<ApiResponse<Map<String, dynamic>>> getMember(String memberId) async {
    try {
      final response = await _apiService.get('${ApiConfig.membersEndpoint}/$memberId');
      
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

  // 회원 정보 수정
  Future<ApiResponse<Map<String, dynamic>>> updateMember(
    String memberId,
    Map<String, dynamic> memberData,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.membersEndpoint}/$memberId',
        data: memberData,
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

  // 회원 상태 변경
  Future<ApiResponse<Map<String, dynamic>>> updateMemberStatus(
    String memberId,
    String status,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.membersEndpoint}/$memberId/status',
        data: {'status': status},
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

  // 회원 주문 내역 조회
  Future<ApiResponse<PaginatedResponse<Map<String, dynamic>>>> getMemberOrders(
    String memberId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.membersEndpoint}/$memberId/orders',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
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

  // 회원 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getMemberStats(String memberId) async {
    try {
      final response = await _apiService.get('${ApiConfig.membersEndpoint}/$memberId/stats');
      
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

  // 회원 등급 변경
  Future<ApiResponse<Map<String, dynamic>>> updateMemberLevel(
    String memberId,
    String level,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.membersEndpoint}/$memberId/level',
        data: {'level': level},
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

  // 회원 포인트 조회
  Future<ApiResponse<Map<String, dynamic>>> getMemberPoints(String memberId) async {
    try {
      final response = await _apiService.get('${ApiConfig.membersEndpoint}/$memberId/points');
      
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

  // 회원 포인트 조정
  Future<ApiResponse<Map<String, dynamic>>> adjustMemberPoints(
    String memberId,
    int points,
    String reason,
  ) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.membersEndpoint}/$memberId/points/adjust',
        data: {
          'points': points,
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
}
