import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/sales_chart_widget.dart';
import '../widgets/order_status_chart_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDate = DateTime.now();

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SalesChartWidget(
                    selectedDate: _selectedDate,
                    onDateChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
                SizedBox(width: AppSizes.lg),
                Expanded(
                  child: OrderStatusChartWidget(
                    selectedDate: _selectedDate,
                    onDateChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
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
            value: '₩12,450,000',
            subtitle: '어제',
            icon: MdiIcons.currencyKrw,
            color: AppColors.success,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: DashboardStatCard(
            title: '신규 주문',
            value: '89',
            subtitle: '진행중인 주문',
            icon: MdiIcons.cartPlus,
            color: AppColors.info,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: DashboardStatCard(
            title: '가입 사업자',
            value: '342/5',
            subtitle: '전체/오늘(신규등록)',
            icon: MdiIcons.domain,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: DashboardStatCard(
            title: '승인 대기',
            value: '23',
            subtitle: '',
            icon: MdiIcons.clockAlert,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }


}
