import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/pagination_model.dart';
import 'api_service.dart';

class StoresService {
  final ApiService _apiService = ApiService();

  // 매장 목록 조회 (페이지네이션)
  Future<ApiResponse<PaginatedResponse<Map<String, dynamic>>>> getStores({
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
      
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _apiService.get(
        ApiConfig.storesEndpoint,
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

  // 매장 상세 조회
  Future<ApiResponse<Map<String, dynamic>>> getStore(String storeId) async {
    try {
      final response = await _apiService.get('${ApiConfig.storesEndpoint}/$storeId');
      
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

  // 매장 등록
  Future<ApiResponse<Map<String, dynamic>>> createStore(Map<String, dynamic> storeData) async {
    try {
      final response = await _apiService.post(
        ApiConfig.storesEndpoint,
        data: storeData,
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

  // 매장 수정
  Future<ApiResponse<Map<String, dynamic>>> updateStore(
    String storeId,
    Map<String, dynamic> storeData,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.storesEndpoint}/$storeId',
        data: storeData,
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

  // 매장 삭제
  Future<ApiResponse<void>> deleteStore(String storeId) async {
    try {
      final response = await _apiService.delete('${ApiConfig.storesEndpoint}/$storeId');
      
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

  // 매장 상태 변경
  Future<ApiResponse<Map<String, dynamic>>> updateStoreStatus(
    String storeId,
    String status,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.storesEndpoint}/$storeId/status',
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

  // 매장 메뉴 조회
  Future<ApiResponse<List<Map<String, dynamic>>>> getStoreMenus(String storeId) async {
    try {
      final response = await _apiService.get('${ApiConfig.storesEndpoint}/$storeId/menus');
      
      return ApiResponse<List<Map<String, dynamic>>>.fromJson(
        response.data,
        (data) => (data as List<dynamic>)
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } catch (e) {
      return ApiResponse<List<Map<String, dynamic>>>(
        success: false,
        message: e.toString(),
      );
    }
  }

  // 매장 메뉴 추가
  Future<ApiResponse<Map<String, dynamic>>> addStoreMenu(
    String storeId,
    Map<String, dynamic> menuData,
  ) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.storesEndpoint}/$storeId/menus',
        data: menuData,
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

  // 매장 메뉴 수정
  Future<ApiResponse<Map<String, dynamic>>> updateStoreMenu(
    String storeId,
    String menuId,
    Map<String, dynamic> menuData,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.storesEndpoint}/$storeId/menus/$menuId',
        data: menuData,
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

  // 매장 메뉴 삭제
  Future<ApiResponse<void>> deleteStoreMenu(String storeId, String menuId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConfig.storesEndpoint}/$storeId/menus/$menuId',
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

