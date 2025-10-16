import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/services/dashboard_data_service.dart';

class OrderStatusChartWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  
  const OrderStatusChartWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<OrderStatusChartWidget> createState() => _OrderStatusChartWidgetState();
}

class _OrderStatusChartWidgetState extends State<OrderStatusChartWidget> {
  OrderStatusData? _orderData;
  int _touchedIndex = -1;
  
  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }
  
  @override
  void didUpdateWidget(OrderStatusChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadOrderData();
    }
  }
  
  void _loadOrderData() {
    final settlements = DashboardDataService.getSampleSettlementData();
    // 선택된 날짜 기준으로 필터링 로직을 추가할 수 있음
    setState(() {
      _orderData = DashboardDataService.aggregateOrderStatus(settlements);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.info.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            _buildChart(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주문 현황',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '주문 상태별 분포',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: _showDatePicker,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  MdiIcons.calendar,
                  size: AppSizes.iconSm,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppSizes.xs),
                Text(
                  _formatSelectedDate(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildChart() {
    if (_orderData == null || _orderData!.total == 0) {
      return Container(
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
                '데이터가 없습니다',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      height: 250.h,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 45.w,
                sections: _buildPieChartSections(),
              ),
            ),
          ),
          SizedBox(width: AppSizes.lg),
          Expanded(
            flex: 1,
            child: _buildLegend(),
          ),
        ],
      ),
    );
  }
  
  List<PieChartSectionData> _buildPieChartSections() {
    if (_orderData == null) return [];
    
    final data = _orderData!;
    final total = data.total.toDouble();
    
    return [
      // 완료된 주문
      PieChartSectionData(
        color: AppColors.success,
        value: data.completed.toDouble(),
        title: _touchedIndex == 0 ? '${data.completed}건' : '${(data.completed / total * 100).toStringAsFixed(1)}%',
        radius: _touchedIndex == 0 ? 65.w : 55.w,
        titleStyle: TextStyle(
          fontSize: _touchedIndex == 0 ? 14.sp : 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      // 취소된 주문
      PieChartSectionData(
        color: AppColors.error,
        value: data.cancelled.toDouble(),
        title: _touchedIndex == 1 ? '${data.cancelled}건' : '${(data.cancelled / total * 100).toStringAsFixed(1)}%',
        radius: _touchedIndex == 1 ? 65.w : 55.w,
        titleStyle: TextStyle(
          fontSize: _touchedIndex == 1 ? 14.sp : 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      // 대기중 주문
      PieChartSectionData(
        color: AppColors.warning,
        value: data.pending.toDouble(),
        title: _touchedIndex == 2 ? '${data.pending}건' : '${(data.pending / total * 100).toStringAsFixed(1)}%',
        radius: _touchedIndex == 2 ? 65.w : 55.w,
        titleStyle: TextStyle(
          fontSize: _touchedIndex == 2 ? 14.sp : 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }
  
  Widget _buildLegend() {
    if (_orderData == null) return Container();
    
    final data = _orderData!;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem(
          color: AppColors.success,
          label: '완료',
          value: data.completed,
          icon: MdiIcons.checkCircle,
        ),
        SizedBox(height: AppSizes.md),
        _buildLegendItem(
          color: AppColors.error,
          label: '취소',
          value: data.cancelled,
          icon: MdiIcons.closeCircle,
        ),
        SizedBox(height: AppSizes.md),
        _buildLegendItem(
          color: AppColors.warning,
          label: '대기',
          value: data.pending,
          icon: MdiIcons.clockOutline,
        ),
        SizedBox(height: AppSizes.lg),
        Divider(color: AppColors.border),
        SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Icon(
              MdiIcons.cartOutline,
              size: AppSizes.iconSm,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: AppSizes.xs),
            Text(
              '총 ${data.total}건',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLegendItem({
    required Color color,
    required String label,
    required int value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Icon(
          icon,
          size: AppSizes.iconSm,
          color: color,
        ),
        SizedBox(width: AppSizes.xs),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          '$value건',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
  
  String _formatSelectedDate() {
    return '${widget.selectedDate.year}.${widget.selectedDate.month}.${widget.selectedDate.day}';
  }
  
  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != widget.selectedDate) {
      widget.onDateChanged(picked);
    }
  }
}
