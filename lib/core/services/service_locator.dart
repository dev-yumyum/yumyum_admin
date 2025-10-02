import 'api_service.dart';
import 'auth_service.dart';
import 'stores_service.dart';
import 'orders_service.dart';
import 'members_service.dart';
import 'dashboard_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // 서비스 인스턴스들
  late final ApiService _apiService;
  late final AuthService _authService;
  late final StoresService _storesService;
  late final OrdersService _ordersService;
  late final MembersService _membersService;
  late final DashboardService _dashboardService;

  // 초기화
  void initialize() {
    _apiService = ApiService();
    _apiService.initialize();
    
    _authService = AuthService();
    _storesService = StoresService();
    _ordersService = OrdersService();
    _membersService = MembersService();
    _dashboardService = DashboardService();
  }

  // 서비스 인스턴스 접근자들
  ApiService get apiService => _apiService;
  AuthService get authService => _authService;
  StoresService get storesService => _storesService;
  OrdersService get ordersService => _ordersService;
  MembersService get membersService => _membersService;
  DashboardService get dashboardService => _dashboardService;
}
