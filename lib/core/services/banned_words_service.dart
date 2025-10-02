import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/pagination_model.dart';
import 'api_service.dart';

class BannedWordsService {
  final ApiService _apiService = ApiService();

  // 금칙어 목록 조회 (페이지네이션)
  Future<ApiResponse<PaginatedResponse<Map<String, dynamic>>>> getBannedWords({
    int page = 1,
    int limit = 10,
    String? search,
    String? type,
    String? severity,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      if (type != null && type.isNotEmpty && type != 'all') {
        queryParams['type'] = type;
      }
      
      if (severity != null && severity.isNotEmpty && severity != 'all') {
        queryParams['severity'] = severity;
      }

      final response = await _apiService.get(
        '/banned-words',
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

  // 금칙어 상세 조회
  Future<ApiResponse<Map<String, dynamic>>> getBannedWord(String bannedWordId) async {
    try {
      final response = await _apiService.get('/banned-words/$bannedWordId');
      
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

  // 금칙어 추가
  Future<ApiResponse<Map<String, dynamic>>> createBannedWord(
    Map<String, dynamic> bannedWordData,
  ) async {
    try {
      final response = await _apiService.post(
        '/banned-words',
        data: bannedWordData,
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

  // 금칙어 수정
  Future<ApiResponse<Map<String, dynamic>>> updateBannedWord(
    String bannedWordId,
    Map<String, dynamic> bannedWordData,
  ) async {
    try {
      final response = await _apiService.put(
        '/banned-words/$bannedWordId',
        data: bannedWordData,
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

  // 금칙어 삭제
  Future<ApiResponse<void>> deleteBannedWord(String bannedWordId) async {
    try {
      final response = await _apiService.delete('/banned-words/$bannedWordId');
      
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

  // 금칙어 활성/비활성 토글
  Future<ApiResponse<Map<String, dynamic>>> toggleBannedWordStatus(
    String bannedWordId,
  ) async {
    try {
      final response = await _apiService.put(
        '/banned-words/$bannedWordId/toggle',
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

  // 금칙어 검증 (텍스트에 금칙어 포함 여부 확인)
  Future<ApiResponse<Map<String, dynamic>>> validateText(
    String text,
  ) async {
    try {
      final response = await _apiService.post(
        '/banned-words/validate',
        data: {'text': text},
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

  // 금칙어 통계 조회
  Future<ApiResponse<Map<String, dynamic>>> getBannedWordsStats() async {
    try {
      final response = await _apiService.get('/banned-words/stats');
      
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

  // 금칙어 일괄 가져오기 (CSV)
  Future<ApiResponse<String>> importBannedWords(String csvData) async {
    try {
      final response = await _apiService.post(
        '/banned-words/import',
        data: {'csvData': csvData},
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

  // 금칙어 일괄 내보내기 (CSV)
  Future<ApiResponse<String>> exportBannedWords() async {
    try {
      final response = await _apiService.get('/banned-words/export');
      
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
