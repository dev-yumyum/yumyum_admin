import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱 전체에서 사용되는 색상 정의
class AppColors {
  // 기본 브랜드 색상
  static const Color primary = Color(0xFFFF6B35);      // 주황색 (YumYum 브랜드 컬러)
  static const Color primaryLight = Color(0xFFFF8A65);
  static const Color primaryDark = Color(0xFFE65100);
  
  // 보조 색상
  static const Color secondary = Color(0xFF4CAF50);     // 녹색
  static const Color accent = Color(0xFF2196F3);        // 파란색
  
  // 상태 색상
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // 배경 색상
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // 텍스트 색상
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color textInverse = Color(0xFFFFFFFF);
  
  // 기타 색상
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  
  // 상태별 색상 (승인, 대기, 거부 등)
  static const Color approved = Color(0xFF4CAF50);
  static const Color pending = Color(0xFFFFC107);
  static const Color rejected = Color(0xFFF44336);
  static const Color inactive = Color(0xFF9E9E9E);
}

/// 앱 전체에서 사용되는 크기 정의
class AppSizes {
  // 패딩 및 마진
  static double xs = 5.0.w;
  static double sm = 10.0.w;
  static double md = 18.0.w;
  static double lg = 28.0.w;
  static double xl = 36.0.w;
  static double xxl = 52.0.w;
  
  // 아이콘 크기
  static double iconXs = 14.0.w;
  static double iconSm = 18.0.w;
  static double iconMd = 28.0.w;
  static double iconLg = 36.0.w;
  static double iconXl = 52.0.w;
  
  // 버튼 크기
  static double buttonHeight = 52.0.h;
  static double buttonSmall = 40.0.h;
  static double buttonLarge = 60.0.h;
  
  // 카드 및 컨테이너
  static double borderRadius = 8.0.r;
  static double borderRadiusLarge = 16.0.r;
  static double elevation = 2.0;
  
  // 사이드바
  static double sidebarWidth = 280.0.w;
  static double sidebarCollapsedWidth = 80.0.w;
  
  // 기타
  static double appBarHeight = 64.0.h;
  static double bottomNavHeight = 80.0.h;
}

/// 앱에서 사용되는 라우트 이름
class RouteNames {
  // 인증
  static const String login = '/login';
  
  // 메인
  static const String dashboard = '/dashboard';
  
  // 사업자 관리
  static const String business = '/business';
  static const String businessDetail = '/business/detail';
  static const String businessRegister = '/business/register';
  
  // 매장 관리
  static const String store = '/store';
  static const String storeDetail = '/store/detail';
  static const String storeRegister = '/store/register';
  
  // 메뉴 관리
  static const String menu = '/menu';
  static const String menuRegister = '/menu/register';
  static const String storeMenu = '/store/:storeId/menu';
  static const String storeMenuRegister = '/store/:storeId/menu/register';
  
  // 승인 관리
  static const String approval = '/approval';
  static const String approvalDetail = '/approval/detail';
  
  // 매출 관리
  static const String sales = '/sales';
  
  // 정산 관리
  static const String settlement = '/settlement';
  
  // 회원 관리
  static const String member = '/member';
  static const String memberDetail = '/member/detail';
  
  // 리뷰 관리
  static const String review = '/review';
  
  // 관리자 관리
  static const String manager = '/manager';
  static const String managerDetail = '/manager/detail';
}

/// 앱에서 사용되는 문자열 상수
class AppStrings {
  // 앱 정보
  static const String appName = 'YumYum CRM';
  static const String appDescription = '포장 서비스 관리자 페이지';
  
  // 공통
  static const String confirm = '확인';
  static const String cancel = '취소';
  static const String save = '저장';
  static const String edit = '수정';
  static const String delete = '삭제';
  static const String search = '검색';
  static const String filter = '필터';
  static const String refresh = '새로고침';
  static const String loading = '로딩 중...';
  static const String noData = '데이터가 없습니다';
  
  // 네비게이션
  static const String dashboard = '대시보드';
  static const String businessManagement = '사업자 관리';
  static const String storeManagement = '매장 관리';
  static const String menuManagement = '메뉴 관리';
  static const String approvalManagement = '승인 관리';
  static const String salesManagement = '매출 관리';
  static const String settlementManagement = '정산 관리';
  static const String memberManagement = '고객관리';
  static const String managerManagement = '관리자 관리';
  
  // 상태
  static const String statusApproved = '승인완료';
  static const String statusPending = '승인대기';
  static const String statusRejected = '승인거부';
  static const String statusActive = '활성';
  static const String statusInactive = '비활성';
}
