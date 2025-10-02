# 백엔드 연결 기본 셋팅 완료

## 📁 생성된 파일 구조

```
lib/core/
├── config/
│   └── api_config.dart              # API 설정 (URL, 타임아웃, 헤더)
├── models/
│   ├── api_response.dart           # API 응답 모델
│   └── pagination_model.dart       # 페이지네이션 모델
├── services/
│   ├── api_service.dart            # HTTP 클라이언트 (Dio)
│   ├── auth_service.dart          # 인증 서비스
│   ├── stores_service.dart         # 매장 관리 서비스
│   ├── orders_service.dart         # 주문 관리 서비스
│   ├── members_service.dart        # 회원 관리 서비스
│   ├── dashboard_service.dart      # 대시보드 서비스
│   └── service_locator.dart       # 서비스 로케이터
├── providers/
│   └── api_providers.dart         # Riverpod 프로바이더
└── utils/
    └── network_utils.dart         # 네트워크 유틸리티
```

## 🚀 주요 기능

### 1. API 설정 (`api_config.dart`)
- 개발/운영 환경 분리
- 기본 URL: `http://localhost:5001/api`
- 타임아웃 설정 (30초)
- 기본 헤더 설정

### 2. HTTP 클라이언트 (`api_service.dart`)
- Dio 기반 HTTP 클라이언트
- 자동 인증 토큰 관리
- 요청/응답 로깅
- 에러 처리 및 재시도 로직

### 3. 서비스 클래스들
- **AuthService**: 로그인, 로그아웃, 토큰 갱신
- **StoresService**: 매장 CRUD, 메뉴 관리
- **OrdersService**: 주문 조회, 상태 변경, 통계
- **MembersService**: 회원 관리, 포인트 관리
- **DashboardService**: 대시보드 통계, 차트 데이터

### 4. 모델 클래스들
- **ApiResponse**: 표준 API 응답 형식
- **PaginationModel**: 페이지네이션 지원
- **PaginatedResponse**: 페이지네이션된 응답

## 🔧 사용 방법

### 1. 서비스 사용 예시
```dart
// Riverpod 프로바이더 사용
final authService = ref.watch(authServiceProvider);

// 로그인
final response = await authService.login(
  email: 'admin@example.com',
  password: 'password123',
);

if (response.isSuccess) {
  // 로그인 성공
  print('로그인 성공: ${response.data}');
} else {
  // 로그인 실패
  print('로그인 실패: ${response.message}');
}
```

### 2. 매장 목록 조회
```dart
final storesService = ref.watch(storesServiceProvider);

final response = await storesService.getStores(
  page: 1,
  limit: 10,
  search: '검색어',
  status: 'active',
);

if (response.isSuccess) {
  final stores = response.data!.items;
  final pagination = response.data!.pagination;
  // 매장 목록 처리
}
```

### 3. 주문 통계 조회
```dart
final ordersService = ref.watch(ordersServiceProvider);

final response = await ordersService.getOrderStats(
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now(),
);

if (response.isSuccess) {
  final stats = response.data!;
  // 통계 데이터 처리
}
```

## 🌐 백엔드 서버 설정

### 개발 환경
- **URL**: `http://localhost:5001/api`
- **포트**: 5001
- **프로토콜**: HTTP

### API 엔드포인트 구조
```
/api
├── /auth
│   ├── POST /login
│   ├── POST /logout
│   ├── POST /refresh
│   └── GET /me
├── /stores
│   ├── GET /
│   ├── GET /:id
│   ├── POST /
│   ├── PUT /:id
│   └── DELETE /:id
├── /orders
│   ├── GET /
│   ├── GET /:id
│   ├── PUT /:id/status
│   └── GET /stats
├── /members
│   ├── GET /
│   ├── GET /:id
│   ├── PUT /:id
│   └── GET /:id/orders
└── /dashboard
    ├── GET /stats
    ├── GET /charts
    └── GET /realtime
```

## 🔒 인증 시스템

### JWT 토큰 기반 인증
- 로그인 시 토큰 자동 저장
- 요청 시 자동 토큰 첨부
- 401 에러 시 자동 로그아웃 처리

### 보안 기능
- 자동 토큰 갱신
- 인증 실패 시 자동 리다이렉트
- 요청/응답 로깅

## 📊 에러 처리

### 표준 에러 응답 형식
```json
{
  "success": false,
  "message": "에러 메시지",
  "statusCode": 400,
  "errors": {
    "field": "필드별 에러 메시지"
  }
}
```

### 네트워크 에러 처리
- 연결 시간 초과
- 서버 오류 (5xx)
- 클라이언트 오류 (4xx)
- 네트워크 연결 실패

## 🚀 다음 단계

1. **백엔드 서버 구축**: Node.js/Express 또는 Spring Boot
2. **데이터베이스 연동**: MongoDB, PostgreSQL 등
3. **실제 API 엔드포인트 구현**
4. **인증 시스템 구현**: JWT 토큰 발급/검증
5. **테스트**: API 연동 테스트

## 📝 참고사항

- 모든 API 호출은 비동기 처리
- 에러 처리는 표준화된 형식 사용
- 페이지네이션은 모든 목록 API에 적용
- 로깅은 개발 환경에서만 활성화
- 프로덕션 환경에서는 로깅 비활성화 권장

