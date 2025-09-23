import '../../../sales/data/models/sales_model.dart';
import '../../../settlements/data/models/settlement_model.dart';

class DashboardDataService {
  // 매출 데이터 - 일주일 단위로 1달간 데이터
  static List<SalesModel> getSampleSalesData() {
    final now = DateTime.now();
    final sales = <SalesModel>[];
    
    // 1달간의 샘플 매출 데이터 생성 (일별)
    for (int i = 30; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailySales = _generateDailySales(date, i);
      sales.addAll(dailySales);
    }
    
    return sales;
  }
  
  // 정산 데이터 - 주문 상태별 집계
  static List<SettlementModel> getSampleSettlementData() {
    final now = DateTime.now();
    final settlements = <SettlementModel>[];
    
    // 1달간의 주간 정산 데이터 생성
    for (int week = 4; week >= 0; week--) {
      final startDate = now.subtract(Duration(days: (week * 7) + 7));
      final endDate = now.subtract(Duration(days: week * 7));
      
      settlements.add(SettlementModel(
        id: 'settlement_week_$week',
        businessId: 'business_$week',
        businessName: '사업자 ${week + 1}',
        storeId: 'store_$week',
        storeName: '매장 ${week + 1}',
        settlementDate: _formatDate(endDate),
        periodStart: _formatDate(startDate),
        periodEnd: _formatDate(endDate),
        totalSalesAmount: '${(800000 + (week * 50000))}',
        platformFeeRate: '3.5',
        platformFeeAmount: '${((800000 + (week * 50000)) * 0.035).round()}',
        deliveryFeeAmount: '15000',
        adjustmentAmount: '0',
        settlementAmount: '${((800000 + (week * 50000)) * 0.965).round() - 15000}',
        status: week == 0 ? 'PENDING' : 'PAID',
        totalOrders: 45 + (week * 5),
        completedOrders: 40 + (week * 4),
        cancelledOrders: 5 + week,
      ));
    }
    
    return settlements;
  }
  
  // 일별 매출 데이터 생성
  static List<SalesModel> _generateDailySales(DateTime date, int dayIndex) {
    final sales = <SalesModel>[];
    final dailyOrderCount = 8 + (dayIndex % 7) * 2; // 8-20개 주문/일
    
    for (int order = 0; order < dailyOrderCount; order++) {
      final orderTime = date.add(Duration(
        hours: 10 + (order % 12),
        minutes: (order * 15) % 60,
      ));
      
      final orderAmount = 15000 + ((dayIndex + order) % 10) * 3000; // 15,000~42,000원
      
      sales.add(SalesModel(
        id: 'order_${_formatDate(date)}_$order',
        orderId: 'order_${dayIndex}_$order',
        orderNumber: 'O${_formatDate(date).replaceAll('-', '')}${order.toString().padLeft(3, '0')}',
        storeId: 'store_${(dayIndex + order) % 4 + 1}',
        storeName: _getStoreName((dayIndex + order) % 4 + 1),
        businessId: 'business_${(dayIndex + order) % 3 + 1}',
        businessName: '사업자 ${(dayIndex + order) % 3 + 1}',
        customerName: '고객 ${order + 1}',
        orderDate: _formatDateTime(orderTime),
        orderType: order % 3 == 0 ? 'DINE_IN' : 'PICKUP',
        status: _getOrderStatus(order),
        orderAmount: orderAmount,
        totalAmount: '$orderAmount',
        finalAmount: '$orderAmount',
        paymentAmount: orderAmount,
        paymentMethod: _getPaymentMethod(order),
        paymentStatus: 'COMPLETED',
        menuItems: _getMenuItems(order),
      ));
    }
    
    return sales;
  }
  
  // 매출 데이터를 주간별로 집계
  static List<WeeklySalesData> aggregateWeeklySales(List<SalesModel> sales) {
    final Map<String, double> weeklyData = {};
    
    for (final sale in sales) {
      final orderDate = DateTime.parse(sale.orderDate);
      final weekStart = _getWeekStartDate(orderDate);
      final weekKey = _formatDate(weekStart);
      
      weeklyData[weekKey] = (weeklyData[weekKey] ?? 0) + sale.paymentAmount;
    }
    
    return weeklyData.entries
        .map((entry) => WeeklySalesData(
              weekStart: entry.key,
              totalSales: entry.value,
            ))
        .toList()
      ..sort((a, b) => a.weekStart.compareTo(b.weekStart));
  }
  
  // 정산 데이터를 주문 상태별로 집계
  static OrderStatusData aggregateOrderStatus(List<SettlementModel> settlements) {
    int totalCompleted = 0;
    int totalCancelled = 0;
    int totalPending = 0;
    
    for (final settlement in settlements) {
      totalCompleted += settlement.completedOrders;
      totalCancelled += settlement.cancelledOrders;
      // 대기중 = 전체 - 완료 - 취소
      final pending = settlement.totalOrders - settlement.completedOrders - settlement.cancelledOrders;
      totalPending += pending;
    }
    
    return OrderStatusData(
      completed: totalCompleted,
      cancelled: totalCancelled,
      pending: totalPending,
    );
  }
  
  // 헬퍼 메서드들
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  static String _formatDateTime(DateTime date) {
    return '${_formatDate(date)}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:00';
  }
  
  static DateTime _getWeekStartDate(DateTime date) {
    final difference = date.weekday - 1; // 월요일을 주 시작으로
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: difference));
  }
  
  static String _getStoreName(int index) {
    switch (index) {
      case 1: return '맛있는집 강남점';
      case 2: return '치킨왕 홍대점';
      case 3: return '피자마을 신촌점';
      case 4: return '맛있는집 서초점';
      default: return '매장 $index';
    }
  }
  
  static String _getOrderStatus(int index) {
    final statuses = ['PICKUP_COMPLETED', 'PICKUP_COMPLETED', 'PICKUP_COMPLETED', 'CANCELLED'];
    return statuses[index % statuses.length];
  }
  
  static String _getPaymentMethod(int index) {
    final methods = ['CARD', 'MOBILE_PAY', 'CARD', 'CASH'];
    return methods[index % methods.length];
  }
  
  static String _getMenuItems(int index) {
    final menus = [
      '밤바피자 L 1개',
      '후라이드 치킨 M 1개, 콜라 1개',
      '크림 파스타 L 1개',
      '김치찌개 M 1개, 백미밥 1개',
      '짜장면 L 1개',
      '초밥 세트 M 1개',
      '아메리카노 L 2개',
    ];
    return menus[index % menus.length];
  }
}

// 데이터 클래스들
class WeeklySalesData {
  final String weekStart;
  final double totalSales;
  
  WeeklySalesData({
    required this.weekStart,
    required this.totalSales,
  });
}

class OrderStatusData {
  final int completed;
  final int cancelled;
  final int pending;
  
  OrderStatusData({
    required this.completed,
    required this.cancelled,
    required this.pending,
  });
  
  int get total => completed + cancelled + pending;
}
