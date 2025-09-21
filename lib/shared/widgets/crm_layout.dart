import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../core/constants/app_constants.dart';

class CrmLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const CrmLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<CrmLayout> createState() => _CrmLayoutState();
}

class _CrmLayoutState extends State<CrmLayout> with TickerProviderStateMixin {
  bool _isCollapsed = false;
  bool _isMobile = false;
  bool _showMobileMenu = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 웹 반응형 처리
        _isMobile = constraints.maxWidth < 768;
        
        // 모바일에서는 자동으로 사이드바 숨김
        if (_isMobile && !_isCollapsed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isCollapsed = true;
            });
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          // 웹에서는 드로어 사용 안함, 모바일에서만 사용
          drawer: _isMobile ? _buildMobileDrawer() : null,
          body: kIsWeb ? _buildWebLayout() : _buildMobileLayout(),
        );
      },
    );
  }

  Widget _buildWebLayout() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.lg),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: _buildSidebarMenu(),
          ),
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final sidebarWidth = _isCollapsed 
        ? AppSizes.sidebarCollapsedWidth 
        : AppSizes.sidebarWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: sidebarWidth,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: const Offset(2, 0),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildSidebarHeader(),
            Expanded(
              child: _buildSidebarMenu(),
            ),
            _buildSidebarFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      height: AppSizes.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Icon(
            MdiIcons.foodForkDrink,
            size: AppSizes.iconLg,
            color: AppColors.primary,
          ),
          if (!_isCollapsed) ...[
            SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
          IconButton(
            onPressed: () {
              setState(() {
                _isCollapsed = !_isCollapsed;
              });
            },
            icon: Icon(
              _isCollapsed ? MdiIcons.menuRight : MdiIcons.menuLeft,
              size: AppSizes.iconMd,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarMenu() {
    final menuItems = [
      _MenuItem(
        icon: MdiIcons.viewDashboard,
        title: AppStrings.dashboard,
        route: RouteNames.dashboard,
      ),
      _MenuItem(
        icon: MdiIcons.domain,
        title: AppStrings.businessManagement,
        route: RouteNames.business,
      ),
      _MenuItem(
        icon: MdiIcons.storefront,
        title: AppStrings.storeManagement,
        route: RouteNames.store,
      ),
      _MenuItem(
        icon: MdiIcons.checkCircle,
        title: AppStrings.approvalManagement,
        route: RouteNames.approval,
      ),
      _MenuItem(
        icon: MdiIcons.chartLine,
        title: AppStrings.salesManagement,
        route: RouteNames.sales,
      ),
      _MenuItem(
        icon: MdiIcons.calculator,
        title: AppStrings.settlementManagement,
        route: RouteNames.settlement,
      ),
      _MenuItem(
        icon: MdiIcons.accountGroup,
        title: AppStrings.memberManagement,
        route: RouteNames.member,
      ),
      _MenuItem(
        icon: MdiIcons.accountTie,
        title: AppStrings.managerManagement,
        route: RouteNames.manager,
      ),
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final isActive = widget.currentRoute.startsWith(item.route);

        return _buildMenuItem(
          icon: item.icon,
          title: item.title,
          route: item.route,
          isActive: isActive,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isActive,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: AppSizes.xs / 2,
      ),
      child: Material(
        color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: InkWell(
          onTap: () {
            context.go(route);
            // 모바일에서 드로어 닫기
            if (_isMobile) {
              Navigator.of(context).pop();
            }
          },
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          // 웹에서 호버 효과
          hoverColor: kIsWeb ? AppColors.primary.withOpacity(0.05) : null,
          highlightColor: AppColors.primary.withOpacity(0.1),
          splashColor: AppColors.primary.withOpacity(0.2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.md,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    size: AppSizes.iconMd,
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                if (!_isCollapsed) ...[
                  SizedBox(width: AppSizes.md),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? AppColors.primary : AppColors.textPrimary,
                      ),
                      child: Text(title),
                    ),
                  ),
                ],
                // 활성 상태 표시
                if (isActive && !_isCollapsed)
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.primary,
            child: Icon(
              MdiIcons.account,
              size: AppSizes.iconMd,
              color: Colors.white,
            ),
          ),
          if (!_isCollapsed) ...[
            SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '김관리자',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '시스템관리팀',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: AppSizes.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
        // 웹에서 그림자 효과
        boxShadow: kIsWeb ? [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ] : null,
      ),
      child: Row(
        children: [
          // 모바일에서 햄버거 메뉴
          if (_isMobile) ...[
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                MdiIcons.menu,
                size: AppSizes.iconMd,
                color: AppColors.textSecondary,
              ),
              // 웹에서 호버 효과
              hoverColor: kIsWeb ? AppColors.primary.withOpacity(0.1) : null,
            ),
            SizedBox(width: AppSizes.sm),
          ],
          Expanded(
            child: Text(
              _getPageTitle(),
              style: TextStyle(
                fontSize: _isMobile ? 24.sp : 28.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // 사용자 정보와 로그아웃 (웹에서만)
          if (kIsWeb && !_isMobile) ...[
            Text(
              '김관리자',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSizes.md),
            ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: Icon(
                MdiIcons.logout,
                size: AppSizes.iconSm,
              ),
              label: Text('로그아웃'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          title: Row(
            children: [
              Icon(
                MdiIcons.logout,
                color: AppColors.error,
                size: AppSizes.iconMd,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            '정말로 로그아웃하시겠습니까?',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm,
                ),
              ),
              child: Text('취소'),
            ),
            SizedBox(width: AppSizes.sm),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 로그인 페이지로 이동
                context.go(RouteNames.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm,
                ),
              ),
              child: Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }

  String _getPageTitle() {
    switch (widget.currentRoute) {
      case RouteNames.dashboard:
        return AppStrings.dashboard;
      case RouteNames.business:
        return AppStrings.businessManagement;
      case RouteNames.store:
        return AppStrings.storeManagement;
      case RouteNames.approval:
        return AppStrings.approvalManagement;
      case RouteNames.sales:
        return AppStrings.salesManagement;
      case RouteNames.settlement:
        return AppStrings.settlementManagement;
      case RouteNames.member:
        return AppStrings.memberManagement;
      case RouteNames.manager:
        return AppStrings.managerManagement;
      default:
        return AppStrings.appName;
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String route;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}
