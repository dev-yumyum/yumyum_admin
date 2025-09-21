import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../shared/widgets/searchable_dropdown.dart';
import '../../data/models/sales_model.dart';
import '../widgets/order_detail_dialog.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedStore;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<SalesModel> _sales = [];
  List<SalesModel> _filteredSales = [];
  
  // 상점 목록
  final List<DropdownItem> _storeItems = [
    DropdownItem(value: 'ALL', label: '전체'),
    DropdownItem(value: '1', label: '맛있는집 강남점'),
    DropdownItem(value: '2', label: '치킨왕 홍대점'),
    DropdownItem(value: '3', label: '피자마을 신촌점'),
    DropdownItem(value: '4', label: '맛있는집 서초점'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _updateDateRange(_tabController.index);
        });
      }
    });
    _sales = _getSampleSales();
    _filteredSales = _sales;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateDateRange(int index) {
    final now = DateTime.now();
    switch (index) {
      case 0: // 오늘
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      case 1: // 어제
        final yesterday = now.subtract(const Duration(days: 1));
        _startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        _endDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        break;
      case 2: // 일주일
        _startDate = now.subtract(const Duration(days: 6));
        _endDate = now;
        break;
      case 3: // 한달
        _startDate = DateTime(now.year, now.month - 1, now.day);
        _endDate = now;
        break;
    }
  }

  void _filterSales() {
    setState(() {
      if (_selectedStore == null || _selectedStore == 'ALL') {
        _filteredSales = _sales;
      } else {
        _filteredSales = _sales.where((sale) => sale.storeId == _selectedStore).toList();
      }
    });
  }

  void _onStoreChanged(String? storeId) {
    setState(() {
      _selectedStore = storeId;
    });
    _filterSales();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.sales,
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 1400.w, // 최대 폭 제한으로 너무 넓어지지 않도록
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.xl, // 좌우 여백을 더 넓게
            vertical: AppSizes.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: AppSizes.lg),
              _buildTodayStatus(),
              SizedBox(height: AppSizes.lg),
              _buildFilters(),
              SizedBox(height: AppSizes.lg),
              Expanded(
                child: _buildSalesTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      '매출관리',
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTodayStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 현황',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                '주문',
                '27',
                '주문건수',
                AppColors.primary,
                MdiIcons.shoppingOutline,
              ),
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: _buildStatusCard(
                '매출',
                '485,000',
                '주문금액(원)',
                AppColors.success,
                MdiIcons.cashMultiple,
              ),
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: _buildStatusCard(
                '취소',
                '3',
                '취소건수',
                AppColors.warning,
                MdiIcons.cancel,
              ),
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: _buildStatusCard(
                '환불',
                '45,000',
                '환불금액(원)',
                AppColors.error,
                MdiIcons.cashRefund,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.lg),
        // 수수료 및 정산 정보
        Container(
          padding: EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '수수료 및 정산 정보',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFeeInfo('결제수수료 (3.3%)', 16005, AppColors.warning),
                  _buildFeeInfo('중개수수료 (1.0%)', 4850, AppColors.info),
                  _buildFeeInfo('실제 정산금액', 464145, AppColors.success),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeInfo(String label, int amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.xs),
        Text(
          '${_formatCurrency(amount.toString())}원',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(icon, size: AppSizes.iconMd, color: color),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Text(
              value,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 탭 버튼들
            Row(
              children: [
                _buildTabButton('오늘', 0),
                SizedBox(width: AppSizes.sm),
                _buildTabButton('어제', 1),
                SizedBox(width: AppSizes.sm),
                _buildTabButton('일주일', 2),
                SizedBox(width: AppSizes.sm),
                _buildTabButton('한달', 3),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            // 날짜 선택기와 조회 버튼
            Row(
              children: [
                Expanded(
                  child: _buildDateField('시작일', _startDate),
                ),
                SizedBox(width: AppSizes.md),
                Text(
                  '~',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: _buildDateField('종료일', _endDate),
                ),
                SizedBox(width: AppSizes.lg),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 조회 기능
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(80.w, 48.h),
                  ),
                  child: const Text('조회'),
                ),
                SizedBox(width: AppSizes.lg),
                // 상점명 검색 드롭다운
                SearchableDropdown(
                  labelText: '상점명',
                  value: _selectedStore,
                  items: _storeItems,
                  width: 200.w,
                  hintText: '매장을 검색하세요',
                  onChanged: _onStoreChanged,
                ),
                SizedBox(width: AppSizes.md),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 검색 기능
                  },
                  icon: Icon(MdiIcons.magnify, size: AppSizes.iconSm),
                  label: const Text('검색'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
          _updateDateRange(index);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected ? Colors.black : AppColors.border,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(MdiIcons.calendar),
      ),
      controller: TextEditingController(
        text: '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
      ),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          setState(() {
            if (label == '시작일') {
              _startDate = pickedDate;
            } else {
              _endDate = pickedDate;
            }
          });
        }
      },
    );
  }

  Widget _buildSalesTable() {
    final sales = _getSampleSales();
    final period = _getDisplayPeriod();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '매출 목록',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 140.w, // 화면 폭에서 여백 제외
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      AppColors.backgroundSecondary,
                    ),
                    columnSpacing: 25.w, // 컬럼 간격을 더 넓게
                    dataRowMinHeight: 52.h,
                    dataRowMaxHeight: 60.h,
                  columns: [
                    DataColumn(
                      label: Text(
                        '주문번호',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '매장명',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '고객명',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '결제금액',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '주문상태',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '최종변경시간',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                  rows: _filteredSales.map((sale) => _buildDataRow(sale)).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(SalesModel sale) {
    return DataRow(
      onSelectChanged: (_) => _showOrderDetail(sale),
      cells: [
        DataCell(
          Text(
            sale.orderNumber,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        DataCell(
          Text(
            sale.storeName ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        DataCell(
          Text(
            sale.customerName ?? sale.memberName ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        DataCell(
          Text(
            '${_formatCurrency(sale.paymentAmount.toString())}원',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataCell(_buildStatusChip(sale.status)),
        DataCell(
          Text(
            sale.orderDate,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _getDisplayPeriod() {
    final formatter = (DateTime date) => 
        '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    
    final start = formatter(_startDate);
    final end = formatter(_endDate);
    
    if (_startDate.isAtSameMomentAs(_endDate)) {
      return start;
    }
    
    final period = _tabController.index == 2 ? '(일주일)' : 
                   _tabController.index == 3 ? '(한달)' : '';
    
    return '$start ~ $end $period';
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;
    
    switch (status) {
      case 'PICKUP_COMPLETED':
        chipColor = AppColors.success;
        statusText = '포장완료';
        break;
      case 'PREPARING':
        chipColor = AppColors.warning;
        statusText = '준비중';
        break;
      case 'CANCELLED':
        chipColor = AppColors.error;
        statusText = '취소';
        break;
      case 'COMPLETED':
        chipColor = AppColors.success;
        statusText = '완료';
        break;
      default:
        chipColor = AppColors.inactive;
        statusText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  void _showOrderDetail(SalesModel order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailDialog(order: order),
    );
  }

  String _formatCurrency(String value) {
    final num = int.tryParse(value) ?? 0;
    return num.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  List<SalesModel> _getSampleSales() {
    return [
      SalesModel(
        id: '1',
        orderId: '020240914001',
        orderNumber: 'O202409140001',
        storeId: '1',
        storeName: '맛있는집 강남점',
        memberName: '김민수',
        customerName: '김민수',
        customerPhone: '010-1234-5678',
        orderDate: '2024.09.14 14:45',
        orderType: 'PICKUP',
        status: 'PICKUP_COMPLETED',
        orderAmount: 25000,
        totalAmount: '25000',
        discountAmount: 1500,
        finalAmount: '23500',
        paymentAmount: 23500,
        paymentMethod: 'CARD',
        paymentStatus: 'COMPLETED',
        menuItems: '치킨 버거 세트, 콜라 추가',
        paymentCompleteTime: '2024.09.14 13:45',
        orderAcceptTime: '2024.09.14 13:47',
        cookingCompleteTime: '2024.09.14 14:25',
        pickupCompleteTime: '2024.09.14 14:45',
      ),
      SalesModel(
        id: '2',
        orderId: '020240914002',
        orderNumber: 'O202409140002',
        storeId: '2',
        storeName: '치킨왕 홍대점',
        memberName: '이영희',
        customerName: '이영희',
        customerPhone: '010-9876-5432',
        orderDate: '2024.09.14 15:30',
        orderType: 'PICKUP',
        status: 'PICKUP_COMPLETED',
        orderAmount: 35000,
        totalAmount: '35000',
        finalAmount: '35000',
        paymentAmount: 35000,
        paymentMethod: 'MOBILE_PAY',
        paymentStatus: 'COMPLETED',
        menuItems: '후라이드 치킨, 양념치킨',
        paymentCompleteTime: '2024.09.14 14:30',
        orderAcceptTime: '2024.09.14 14:32',
        cookingCompleteTime: '2024.09.14 15:15',
        pickupCompleteTime: '2024.09.14 15:30',
      ),
      SalesModel(
        id: '3',
        orderId: '020240914003',
        orderNumber: 'O202409140003',
        storeId: '3',
        storeName: '피자마을 신촌점',
        memberName: '박철수',
        customerName: '박철수',
        customerPhone: '010-5555-7777',
        orderDate: '2024.09.14 16:15',
        orderType: 'PICKUP',
        status: 'PICKUP_COMPLETED',
        orderAmount: 42000,
        totalAmount: '42000',
        finalAmount: '42000',
        paymentAmount: 42000,
        paymentMethod: 'CARD',
        paymentStatus: 'COMPLETED',
        menuItems: '페퍼로니 피자, 콜라 2개',
        paymentCompleteTime: '2024.09.14 15:30',
        orderAcceptTime: '2024.09.14 15:32',
        cookingCompleteTime: '2024.09.14 16:00',
        pickupCompleteTime: '2024.09.14 16:15',
      ),
      SalesModel(
        id: '4',
        orderId: '020240914004',
        orderNumber: 'O202409140004',
        storeId: '1',
        storeName: '맛있는집 강남점',
        memberName: '정소영',
        customerName: '정소영',
        customerPhone: '010-2222-8888',
        orderDate: '2024.09.14 17:20',
        orderType: 'PICKUP',
        status: 'COOKING_COMPLETED',
        orderAmount: 28000,
        totalAmount: '28000',
        finalAmount: '28000',
        paymentAmount: 28000,
        paymentMethod: 'CARD',
        paymentStatus: 'COMPLETED',
        menuItems: '불고기 버거 세트',
        paymentCompleteTime: '2024.09.14 16:45',
        orderAcceptTime: '2024.09.14 16:47',
        cookingCompleteTime: '2024.09.14 17:20',
      ),
      SalesModel(
        id: '5',
        orderId: '020240914005',
        orderNumber: 'O202409140005',
        storeId: '2',
        storeName: '치킨왕 홍대점',
        memberName: '최동훈',
        customerName: '최동훈',
        customerPhone: '010-3333-9999',
        orderDate: '2024.09.14 18:10',
        orderType: 'PICKUP',
        status: 'CANCELLED',
        orderAmount: 18000,
        totalAmount: '18000',
        finalAmount: '0',
        paymentAmount: 0,
        paymentMethod: 'MOBILE_PAY',
        paymentStatus: 'REFUNDED',
        menuItems: '치킨 텐더',
        paymentCompleteTime: '2024.09.14 17:45',
        orderAcceptTime: '2024.09.14 17:47',
      ),
    ];
  }
}
