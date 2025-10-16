import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/services/dashboard_data_service.dart';

class SalesChartWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  
  const SalesChartWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<SalesChartWidget> createState() => _SalesChartWidgetState();
}

class _SalesChartWidgetState extends State<SalesChartWidget> {
  List<WeeklySalesData> _salesData = [];
  
  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }
  
  @override
  void didUpdateWidget(SalesChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadSalesData();
    }
  }
  
  void _loadSalesData() {
    final sales = DashboardDataService.getSampleSalesData();
    // 선택된 날짜 기준으로 4주간 데이터 필터링
    final endDate = widget.selectedDate;
    final startDate = endDate.subtract(const Duration(days: 28)); // 4주
    
    final filteredSales = sales.where((sale) {
      final orderDate = DateTime.parse(sale.orderDate);
      return orderDate.isAfter(startDate) && orderDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    
    final aggregatedData = DashboardDataService.aggregateWeeklySales(filteredSales);
    
    // 정확히 4주의 데이터만 유지하고 중복 제거
    final uniqueWeeks = <String, WeeklySalesData>{};
    
    for (final data in aggregatedData) {
      final weekStart = DateTime.parse(data.weekStart);
      final weekLabel = _formatWeekDateRange(weekStart);
      
      // 같은 주차 라벨이면 매출을 합산
      if (uniqueWeeks.containsKey(weekLabel)) {
        final existing = uniqueWeeks[weekLabel]!;
        uniqueWeeks[weekLabel] = WeeklySalesData(
          weekStart: existing.weekStart,
          totalSales: existing.totalSales + data.totalSales,
        );
      } else {
        uniqueWeeks[weekLabel] = data;
      }
    }
    
    // 최신 4주만 유지
    final sortedData = uniqueWeeks.values.toList()
      ..sort((a, b) => DateTime.parse(a.weekStart).compareTo(DateTime.parse(b.weekStart)));
    
    final last4Weeks = sortedData.length > 4 
        ? sortedData.sublist(sortedData.length - 4)
        : sortedData;
    
    setState(() {
      _salesData = last4Weeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
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
              '매출 현황',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '주간별 매출 추이 (4주)',
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
                  _formatDateRange(),
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
    if (_salesData.isEmpty) {
      return Container(
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
      height: 300.h,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10000000, // 1000만원 단위로 격자선
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.border,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10000000, // 1000만원 단위
                getTitlesWidget: (value, meta) {
                  final thousand = (value / 10000000).round(); // 1000만원 단위로 계산
                  if (thousand == 0) {
                    return Text(
                      '0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textTertiary,
                      ),
                    );
                  }
                  return Text(
                    '${thousand}000만',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
                reservedSize: 60.w, // 텍스트가 길어져서 공간 확장
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < _salesData.length) {
                    final weekData = _salesData[index];
                    final weekStartDate = DateTime.parse(weekData.weekStart);
                    final weekLabel = _formatWeekDateRange(weekStartDate);
                    return Text(
                      weekLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textTertiary,
                      ),
                    );
                  }
                  return Text('');
                },
                reservedSize: 40.h,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
              left: BorderSide(color: AppColors.border),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _salesData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.totalSales,
                );
              }).toList(),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(0.1),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
          minY: 0,
          maxY: 100000000, // 1억원 고정 최대값
        ),
      ),
    );
  }
  
  String _formatDateRange() {
    final endDate = widget.selectedDate;
    final startDate = endDate.subtract(const Duration(days: 28));
    return '${startDate.month}/${startDate.day} - ${endDate.month}/${endDate.day}';
  }
  
  /// 주 시작 날짜를 "MM/DD~MM/DD" 형태로 포맷
  String _formatWeekDateRange(DateTime weekStartDate) {
    final weekEndDate = weekStartDate.add(const Duration(days: 6));
    
    final startMonth = weekStartDate.month.toString().padLeft(2, '0');
    final startDay = weekStartDate.day.toString().padLeft(2, '0');
    final endMonth = weekEndDate.month.toString().padLeft(2, '0');
    final endDay = weekEndDate.day.toString().padLeft(2, '0');
    
    return '$startMonth/$startDay~$endMonth/$endDay';
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
