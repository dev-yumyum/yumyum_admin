import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/service_locator.dart';
import '../services/auth_service.dart';
import '../services/stores_service.dart';
import '../services/orders_service.dart';
import '../services/members_service.dart';
import '../services/dashboard_service.dart';
import '../services/nicknames_service.dart';
import '../services/banned_words_service.dart';

// 서비스 로케이터 프로바이더
final serviceLocatorProvider = Provider<ServiceLocator>((ref) {
  return ServiceLocator();
});

// API 서비스 프로바이더들
final authServiceProvider = Provider<AuthService>((ref) {
  return ref.watch(serviceLocatorProvider).authService;
});

final storesServiceProvider = Provider<StoresService>((ref) {
  return ref.watch(serviceLocatorProvider).storesService;
});

final ordersServiceProvider = Provider<OrdersService>((ref) {
  return ref.watch(serviceLocatorProvider).ordersService;
});

final membersServiceProvider = Provider<MembersService>((ref) {
  return ref.watch(serviceLocatorProvider).membersService;
});

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return ref.watch(serviceLocatorProvider).dashboardService;
});

final nicknamesServiceProvider = Provider<NicknamesService>((ref) {
  return ref.watch(serviceLocatorProvider).nicknamesService;
});

final bannedWordsServiceProvider = Provider<BannedWordsService>((ref) {
  return ref.watch(serviceLocatorProvider).bannedWordsService;
});

