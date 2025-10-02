import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/pagination_model.dart';
import 'api_service.dart';

class OrdersService {
  final ApiService _apiService = ApiService();

  // 주문 목록 조회 (페이지네이션)
  Future<ApiResponse<PaginatedResponse<Map<String, dynamic>>>> getOrders({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? storeId,
    DateTime? startDate,
    DateTime? endDate,
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
      
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get(
        ApiConfig.ordersEndpoint,
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

  // 주문 상세 조회
  Future<ApiResponse<Map<String, dynamic>>> getOrder(String orderId) async {
    try {
      final response = await _apiService.get('${ApiConfig.ordersEndpoint}/$orderId');
      
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

  // 주문 상태 변경
  Future<ApiResponse<Map<String, dynamic>>> updateOrderStatus(
    String orderId,
    String status,
    {String? note}
  ) async {
    try {
      final data = {'status': status};
      if (note != null && note.isNotEmpty) {
        data['note'] = note;
      }

      final response = await _apiService.put(
        '${ApiConfig.ordersEndpoint}/$orderId/status',
        data: data,
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

  // 주문 취소
  Future<ApiResponse<Map<String, dynamic>>> cancelOrder(
    String orderId,
    String reason,
  ) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.ordersEndpoint}/$orderId/cancel',
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

  // 주문 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getOrderStats({
    String? storeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
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

  // 주문 내역 내보내기 (CSV)
  Future<ApiResponse<String>> exportOrders({
    String? storeId,
    DateTime? startDate,
    DateTime? endDate,
    String format = 'csv',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'format': format,
      };
      
      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get(
        '${ApiConfig.ordersEndpoint}/export',
        queryParameters: queryParams,
      );
      
      return ApiResponse<String>.fromJson(
        response.data,
        (data) => data.toString(),
      );
    } catch (e) {
      return ApiResponse<String>(
        success: false,
        message: e.toString(),
      );
    }
  }
}

