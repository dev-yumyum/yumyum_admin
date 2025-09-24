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
    // 선택된 날짜 기준으로 1달간 데이터 필터링
    final endDate = widget.selectedDate;
    final startDate = endDate.subtract(const Duration(days: 28)); // 4주
    
    final filteredSales = sales.where((sale) {
      final orderDate = DateTime.parse(sale.orderDate);
      return orderDate.isAfter(startDate) && orderDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    
    setState(() {
      _salesData = DashboardDataService.aggregateWeeklySales(filteredSales);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
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
                    final weekLabel = _formatWeekLabel(weekStartDate);
                    return Text(
                      weekLabel,
                      style: TextStyle(
                        fontSize: 11.sp,
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
  
  /// 주어진 날짜를 "월 N째주" 형태로 포맷
  String _formatWeekLabel(DateTime weekStartDate) {
    final month = weekStartDate.month;
    
    // 해당 월의 첫 번째 월요일 찾기
    final firstDayOfMonth = DateTime(weekStartDate.year, month, 1);
    final firstMonday = _getFirstMondayOfMonth(firstDayOfMonth);
    
    // 현재 주가 해당 월의 몇 번째 주인지 계산
    final daysDiff = weekStartDate.difference(firstMonday).inDays;
    final weekNumber = (daysDiff / 7).floor() + 1;
    
    // 만약 weekNumber가 0 이하면 이전 달의 주차
    if (weekNumber <= 0) {
      final prevMonth = month == 1 ? 12 : month - 1;
      return '${_getMonthName(prevMonth)}${4 + weekNumber}째주'; // 대략적으로 이전 달 마지막 주
    }
    
    return '${_getMonthName(month)}${weekNumber}째주';
  }
  
  /// 해당 월의 첫 번째 월요일 찾기
  DateTime _getFirstMondayOfMonth(DateTime firstDay) {
    DateTime monday = firstDay;
    while (monday.weekday != DateTime.monday) {
      monday = monday.add(const Duration(days: 1));
    }
    return monday;
  }
  
  /// 월 번호를 월 이름으로 변환
  String _getMonthName(int month) {
    const monthNames = [
      '', '1월', '2월', '3월', '4월', '5월', '6월',
      '7월', '8월', '9월', '10월', '11월', '12월'
    ];
    return monthNames[month];
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
