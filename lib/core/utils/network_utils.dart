import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkUtils {
  // 네트워크 연결 상태 확인
  static Future<bool> isConnected() async {
    try {
      if (kIsWeb) {
        // 웹에서는 항상 연결된 것으로 간주
        return true;
      }
      
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // API URL 유효성 검사
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // 에러 메시지 포맷팅
  static String formatErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    }
    
    if (error.toString().contains('SocketException')) {
      return '네트워크 연결을 확인해주세요.';
    }
    
    if (error.toString().contains('TimeoutException')) {
      return '요청 시간이 초과되었습니다.';
    }
    
    if (error.toString().contains('FormatException')) {
      return '데이터 형식이 올바르지 않습니다.';
    }
    
    return '알 수 없는 오류가 발생했습니다.';
  }

  // HTTP 상태 코드에 따른 메시지
  static String getHttpStatusMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return '요청이 성공적으로 처리되었습니다.';
      case 201:
        return '리소스가 성공적으로 생성되었습니다.';
      case 400:
        return '잘못된 요청입니다.';
      case 401:
        return '인증이 필요합니다.';
      case 403:
        return '접근 권한이 없습니다.';
      case 404:
        return '요청한 리소스를 찾을 수 없습니다.';
      case 409:
        return '리소스 충돌이 발생했습니다.';
      case 422:
        return '입력 데이터가 올바르지 않습니다.';
      case 500:
        return '서버 내부 오류가 발생했습니다.';
      case 502:
        return '게이트웨이 오류가 발생했습니다.';
      case 503:
        return '서비스를 사용할 수 없습니다.';
      default:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }

  // 재시도 로직
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    
    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay);
      }
    }
    
    throw Exception('최대 재시도 횟수를 초과했습니다.');
  }
}
