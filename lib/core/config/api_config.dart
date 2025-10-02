class ApiConfig {
  // 개발 환경 설정
  static const String baseUrl = 'http://localhost:5001/api';
  static const String devBaseUrl = 'http://localhost:5001/api';
  static const String prodBaseUrl = 'https://api.yumyum.com/api';
  
  // API 엔드포인트
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String storesEndpoint = '/stores';
  static const String ordersEndpoint = '/orders';
  static const String membersEndpoint = '/members';
  static const String salesEndpoint = '/sales';
  static const String settlementsEndpoint = '/settlements';
  static const String couponsEndpoint = '/coupons';
  static const String businessEndpoint = '/business';
  static const String managersEndpoint = '/managers';
  static const String approvalEndpoint = '/approval';
  
  // 타임아웃 설정
  static const int connectTimeout = 30000; // 30초
  static const int receiveTimeout = 30000; // 30초
  static const int sendTimeout = 30000; // 30초
  
  // 헤더 설정
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // 현재 환경 (개발/운영)
  static bool get isDevelopment => true; // 개발 환경으로 설정
  static String get currentBaseUrl => isDevelopment ? devBaseUrl : prodBaseUrl;
}
