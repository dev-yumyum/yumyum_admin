import '../config/api_config.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  // 대시보드 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getDashboardStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get(
        '/dashboard/stats',
        queryParameters: queryParams,
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

  // 매출 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getSalesStats({
    DateTime? startDate,
    DateTime? endDate,
    String? storeId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }

      final response = await _apiService.get(
        '${ApiConfig.salesEndpoint}/stats',
        queryParameters: queryParams,
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

  // 주문 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getOrderStats({
    DateTime? startDate,
    DateTime? endDate,
    String? storeId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }

      final response = await _apiService.get(
        '${ApiConfig.ordersEndpoint}/stats',
        queryParameters: queryParams,
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

  // 회원 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getMemberStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get(
        '${ApiConfig.membersEndpoint}/stats',
        queryParameters: queryParams,
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

  // 차트 데이터 조회
  Future<ApiResponse<Map<String, dynamic>>> getChartData({
    required String chartType,
    DateTime? startDate,
    DateTime? endDate,
    String? storeId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'chartType': chartType,
      };
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }

      final response = await _apiService.get(
        '/dashboard/charts',
        queryParameters: queryParams,
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

  // 실시간 데이터 조회
  Future<ApiResponse<Map<String, dynamic>>> getRealtimeData() async {
    try {
      final response = await _apiService.get('/dashboard/realtime');
      
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
