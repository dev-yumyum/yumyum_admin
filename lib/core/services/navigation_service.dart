import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/business/presentation/pages/business_page.dart';
import '../../features/business/presentation/pages/business_detail_page.dart';
import '../../features/business/presentation/pages/business_register_page.dart';
import '../../features/stores/presentation/pages/stores_page.dart';
import '../../features/stores/presentation/pages/store_detail_page.dart';
import '../../features/stores/presentation/pages/store_register_page.dart';
import '../../features/stores/presentation/pages/store_menu_page.dart';
import '../../features/approval/presentation/pages/approval_page.dart';
import '../../features/approval/presentation/pages/approval_detail_page.dart';
import '../../features/sales/presentation/pages/sales_page.dart';
import '../../features/settlements/presentation/pages/settlements_page.dart';
import '../../features/settlements/presentation/pages/settlement_detail_page.dart';
import '../../features/members/presentation/pages/members_page.dart';
import '../../features/members/presentation/pages/member_detail_page.dart';
import '../../features/managers/presentation/pages/managers_page.dart';
import '../../features/nicknames/presentation/pages/nickname_management_page.dart';
import '../../features/nicknames/presentation/pages/banned_words_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: RouteNames.dashboard,
    routes: [
      // 인증
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      
      // 대시보드
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      
      // 사업자 관리
      GoRoute(
        path: RouteNames.business,
        builder: (context, state) => const BusinessPage(),
      ),
      GoRoute(
        path: RouteNames.businessDetail,
        builder: (context, state) {
          final businessId = state.uri.queryParameters['id'];
          return BusinessDetailPage(businessId: businessId);
        },
      ),
      GoRoute(
        path: RouteNames.businessRegister,
        builder: (context, state) => const BusinessRegisterPage(),
      ),
      
      // 매장 관리
      GoRoute(
        path: RouteNames.store,
        builder: (context, state) => const StoresPage(),
      ),
      GoRoute(
        path: RouteNames.storeDetail,
        builder: (context, state) {
          final storeId = state.uri.queryParameters['id'];
          return StoreDetailPage(storeId: storeId);
        },
      ),
      GoRoute(
        path: RouteNames.storeRegister,
        builder: (context, state) => const StoreRegisterPage(),
      ),
      
      // 메뉴 관리
      GoRoute(
        path: '/store/:storeId/menu',
        builder: (context, state) {
          final storeId = state.pathParameters['storeId']!;
          return StoreMenuPage(storeId: storeId);
        },
      ),
      GoRoute(
        path: '/store/:storeId/menu/register',
        builder: (context, state) {
          final storeId = state.pathParameters['storeId']!;
          return StoreMenuPage(storeId: storeId, isRegisterMode: true);
        },
      ),
      
      // 승인 관리
      GoRoute(
        path: RouteNames.approval,
        builder: (context, state) => const ApprovalPage(),
      ),
      GoRoute(
        path: RouteNames.approvalDetail,
        builder: (context, state) {
          final approvalId = state.uri.queryParameters['id'];
          final approvalType = state.uri.queryParameters['type'];
          return ApprovalDetailPage(
            approvalId: approvalId,
            approvalType: approvalType,
          );
        },
      ),
      
      // 매출 관리
      GoRoute(
        path: RouteNames.sales,
        builder: (context, state) => const SalesPage(),
      ),
      
      // 정산 관리
      GoRoute(
        path: RouteNames.settlement,
        builder: (context, state) => const SettlementsPage(),
      ),
      GoRoute(
        path: '/settlement/detail/:settlementId',
        builder: (context, state) {
          final settlementId = state.pathParameters['settlementId']!;
          return SettlementDetailPage(settlementId: settlementId);
        },
      ),
      
      // 회원 관리
      GoRoute(
        path: RouteNames.member,
        builder: (context, state) => const MembersPage(),
      ),
      GoRoute(
        path: RouteNames.memberDetail,
        builder: (context, state) {
          final memberId = state.uri.queryParameters['id'];
          return MemberDetailPage(memberId: memberId);
        },
      ),
      
      // 관리자 관리
      GoRoute(
        path: RouteNames.manager,
        builder: (context, state) => const ManagersPage(),
      ),
      
      // 닉네임 관리
      GoRoute(
        path: '/nickname-management',
        builder: (context, state) => const NicknameManagementPage(),
      ),
      
      // 금칙어 관리
      GoRoute(
        path: '/banned-words',
        builder: (context, state) => const BannedWordsPage(),
      ),
    ],
  );
}
