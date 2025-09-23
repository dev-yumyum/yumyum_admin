import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_chart_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.dashboard,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCards(),
            SizedBox(height: AppSizes.lg),
            Column(
              children: [
                _buildSalesChart(),
                SizedBox(height: AppSizes.lg),
                _buildOrderChart(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: DashboardStatCard(
            title: '총 매출',
            value: '₩15,840,000',
            subtitle: '이번 달',
            icon: MdiIcons.currencyKrw,
            color: AppColors.success,
            trend: '+12.5%',
            isPositive: true,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: DashboardStatCard(
            title: '신규 주문',
            value: '1,247',
            subtitle: '오늘',
            icon: MdiIcons.cartPlus,
            color: AppColors.info,
            trend: '+8.2%',
            isPositive: true,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: DashboardStatCard(
            title: '가입 사업자',
            value: '342',
            subtitle: '전체',
            icon: MdiIcons.domain,
            color: AppColors.primary,
            trend: '+5.1%',
            isPositive: true,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: DashboardStatCard(
            title: '승인 대기',
            value: '23',
            subtitle: '처리 필요',
            icon: MdiIcons.clockAlert,
            color: AppColors.warning,
            trend: '-2.3%',
            isPositive: false,
          ),
        ),
      ],
    );
  }

  Widget _buildSalesChart() {
    return DashboardChartCard(
      title: '매출 현황',
      subtitle: '최근 7일간 매출 추이',
      child: Container(
        height: 300.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.chartLine,
                size: 48.w,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                '매출 차트 영역',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                'fl_chart 라이브러리를 사용하여 구현 예정',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderChart() {
    return DashboardChartCard(
      title: '주문 현황',
      subtitle: '주문 상태별 분포',
      child: Container(
        height: 250.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.chartPie,
                size: 48.w,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                '주문 상태 원형 차트',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
