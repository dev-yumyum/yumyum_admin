import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../shared/widgets/searchable_dropdown.dart';
import '../../data/models/settlement_model.dart';

class SettlementsPage extends StatefulWidget {
  const SettlementsPage({super.key});

  @override
  State<SettlementsPage> createState() => _SettlementsPageState();
}

class _SettlementsPageState extends State<SettlementsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '오늘';
  List<SettlementModel> _settlements = [];
  List<SettlementModel> _filteredSettlements = [];
  String? _selectedBusiness;
  
  int _todayAmount = 1250000;
  int _todayCount = 8;
  
  // 사업자 목록
  final List<DropdownItem> _businessItems = [
    DropdownItem(value: 'ALL', label: '전체'),
    DropdownItem(value: '1', label: '㈜맛있는집'),
    DropdownItem(value: '2', label: '치킨왕 프랜차이즈'),
    DropdownItem(value: '3', label: '피자마을'),
    DropdownItem(value: '4', label: '햄버거킹'),
    DropdownItem(value: '5', label: '스타벅스'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
    _settlements = _getSampleSettlements();
    _filteredSettlements = _settlements;
  }

  String _getBusinessNameById(String id) {
    final business = _businessItems.firstWhere(
      (item) => item.value == id,
      orElse: () => DropdownItem(value: '', label: ''),
    );
    return business.label;
  }

  void _onBusinessChanged(String? businessId) {
    setState(() {
      _selectedBusiness = businessId;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.settlement,
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 1400.w, // 최대 폭 제한으로 너무 넓어지지 않도록
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.xl, // 좌우 여백을 더 넓게
            vertical: AppSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: AppSizes.md),
              _buildTodayStatus(),
              SizedBox(height: AppSizes.md),
              _buildFilters(),
              SizedBox(height: AppSizes.md),
              Expanded(
                child: _buildSettlementTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      '정산관리',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTodayStatus() {
    // 수수료를 고려한 실제 정산 금액 계산
    final grossAmount = _todayAmount;
    final paymentFee = (grossAmount * 0.033).round();
    final brokerageFee = (grossAmount * 0.01).round();
    final netSettlementAmount = grossAmount - paymentFee - brokerageFee;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                '정산',
                '${_formatCurrency(netSettlementAmount.toString())}',
                '오늘 정산 예정액 (원)',
                AppColors.primary,
                MdiIcons.calculatorVariant,
              ),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildStatusCard(
                '건수',
                '$_todayCount',
                '정산건수',
                AppColors.info,
                MdiIcons.counter,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.md),
        // 수수료 세부 정보
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
                '수수료 세부 내역',
                style: TextStyle(
                  fontSize: 20.sp, // 18.sp -> 20.sp
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFeeDetail('총 매출액', grossAmount, AppColors.textPrimary),
                  _buildFeeDetail('결제수수료 (3.3%)', paymentFee, AppColors.warning),
                  _buildFeeDetail('중개수수료 (1.0%)', brokerageFee, AppColors.info),
                  _buildFeeDetail('실제 정산액', netSettlementAmount, AppColors.success),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeDetail(String label, int amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.sp, // 16.sp -> 18.sp
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.xs),
        Text(
          '${_formatCurrency(amount.toString())}원',
          style: TextStyle(
            fontSize: 20.sp, // 18.sp -> 20.sp
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
                Icon(icon, size: AppSizes.iconMd, color: color),
                SizedBox(width: AppSizes.sm),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            isScrollable: false,
            tabs: const [
              Tab(text: '전체'),
              Tab(text: '정산전'),
              Tab(text: '정산완료'),
            ],
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Text(
          '조회 기간:',
          style: TextStyle(
            fontSize: 20.sp, // 18.sp -> 20.sp
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: AppSizes.sm),
        DropdownButton<String>(
          value: _selectedPeriod,
          items: const [
            DropdownMenuItem(value: '오늘', child: Text('오늘')),
            DropdownMenuItem(value: '어제', child: Text('어제')),
            DropdownMenuItem(value: '일주일', child: Text('일주일')),
            DropdownMenuItem(value: '한달', child: Text('한달')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedPeriod = value!;
            });
          },
        ),
        SizedBox(width: AppSizes.lg),
        // 사업자명 검색 드롭다운
        SearchableDropdown(
          labelText: '사업자명',
          value: _selectedBusiness,
          items: _businessItems,
          width: 200.w,
          hintText: '사업자를 검색하세요',
          onChanged: _onBusinessChanged,
        ),
      ],
    );
  }

  Widget _buildSettlementTable() {
    final filteredSettlements = _getFilteredSettlements();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '정산 요청 목록',
                  style: TextStyle(
                    fontSize: 24.sp, // 22.sp -> 24.sp
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '정산건 검',
                      style: TextStyle(
                        fontSize: 20.sp, // 18.sp -> 20.sp
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    ElevatedButton.icon(
                      onPressed: _exportToExcel,
                      icon: Icon(MdiIcons.fileExcel, size: AppSizes.iconSm),
                      label: const Text('엑셀다운로드'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 140.w, // 화면 폭에서 여백 제외
                  ),
                  child: DataTable(
                    showCheckboxColumn: false, // 체크박스 제거
                    columnSpacing: 25.w, // 컬럼 간격을 더 넓게
                    dataRowMinHeight: 52.h,
                    dataRowMaxHeight: 60.h,
                  columns: [
                    DataColumn(
                      label: Text(
                        '사업자명',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 20.sp -> 22.sp (가독성 개선)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '은행명',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 가독성 개선
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '계좌번호',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 가독성 개선
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '예금주',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 가독성 개선
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '요청금액',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 20.sp -> 22.sp (가독성 개선)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '요청일',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 20.sp -> 22.sp (가독성 개선)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '상태',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 20.sp -> 22.sp (가독성 개선)
                        ),
                      ),
                    ),
                  ],
                  rows: filteredSettlements.map((settlement) => _buildDataRow(settlement)).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(SettlementModel settlement) {
    return DataRow(
      onSelectChanged: (selected) {
        if (selected == true) {
          context.go('/settlement/detail/${settlement.id}');
        }
      },
      cells: [
        DataCell(
          Text(
            settlement.businessName ?? settlement.storeName ?? '-',
            style: TextStyle(fontSize: 20.sp), // 18.sp -> 20.sp (가독성 개선)
          ),
        ),
        DataCell(
          Text(
            settlement.bankName ?? '-',
            style: TextStyle(fontSize: 20.sp), // 가독성 개선
          ),
        ),
        DataCell(
          Text(
            settlement.accountNumber ?? '-',
            style: TextStyle(fontSize: 20.sp), // 가독성 개선
          ),
        ),
        DataCell(
          Text(
            settlement.accountHolder ?? '-',
            style: TextStyle(fontSize: 20.sp), // 가독성 개선
          ),
        ),
        DataCell(
          Text(
            '${_formatCurrency(settlement.settlementAmount)}원',
            style: TextStyle(fontSize: 20.sp), // 14.sp -> 20.sp (가독성 개선)
          ),
        ),
        DataCell(
          Text(
            settlement.settlementDate,
            style: TextStyle(fontSize: 20.sp), // 14.sp -> 20.sp (가독성 개선)
          ),
        ),
        DataCell(_buildStatusChip(settlement.status)),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;
    
    switch (status) {
      case 'PENDING':
        chipColor = AppColors.warning;
        statusText = '정산전';
        break;
      case 'PAID':
        chipColor = AppColors.success;
        statusText = '정산완료';
        break;
      default:
        chipColor = AppColors.inactive;
        statusText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12.sp, // 10.sp -> 12.sp
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  void _showSettlementConfirmDialog(SettlementModel settlement) {
    final grossAmount = int.tryParse(settlement.settlementAmount) ?? 0;
    final paymentFee = (grossAmount * 0.033).round();
    final brokerageFee = (grossAmount * 0.01).round();
    final netAmount = grossAmount - paymentFee - brokerageFee;

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
                MdiIcons.checkCircle,
                color: AppColors.success,
                size: AppSizes.iconMd,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                '정산 완료 확인',
                style: TextStyle(
                  fontSize: 22.sp, // 20.sp -> 22.sp
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Container(
            width: 400.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '다음 정산을 완료 처리하시겠습니까?',
                  style: TextStyle(
                    fontSize: 18.sp, // 16.sp -> 18.sp
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.md),
                Container(
                  padding: EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConfirmRow('상호명', settlement.businessName ?? settlement.storeName ?? '-'),
                      SizedBox(height: AppSizes.xs),
                      _buildConfirmRow('계좌정보', '${settlement.bankName} ${settlement.accountNumber}'),
                      SizedBox(height: AppSizes.xs),
                      _buildConfirmRow('예금주', settlement.accountHolder ?? '-'),
                      SizedBox(height: AppSizes.xs),
                      Divider(),
                      SizedBox(height: AppSizes.xs),
                      _buildConfirmRow('총 매출액', '${_formatCurrency(grossAmount.toString())}원'),
                      _buildConfirmRow('결제수수료 (3.3%)', '-${_formatCurrency(paymentFee.toString())}원'),
                      _buildConfirmRow('중개수수료 (1.0%)', '-${_formatCurrency(brokerageFee.toString())}원'),
                      SizedBox(height: AppSizes.xs),
                      Divider(thickness: 2),
                      SizedBox(height: AppSizes.xs),
                      _buildConfirmRow('실제 정산액', '${_formatCurrency(netAmount.toString())}원', isHighlight: true),
                    ],
                  ),
                ),
              ],
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
              child: Text('아니오'),
            ),
            SizedBox(width: AppSizes.sm),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _completeSettlement(settlement);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm,
                ),
              ),
              child: Text('예'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp, // 14.sp -> 16.sp
            color: AppColors.textSecondary,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp, // 14.sp -> 16.sp
            color: isHighlight ? AppColors.success : AppColors.textPrimary,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _completeSettlement(SettlementModel settlement) {
    setState(() {
      // 정산 완료 처리
      final index = _settlements.indexWhere((s) => s.id == settlement.id);
      if (index != -1) {
        _settlements[index] = settlement.copyWith(status: 'PAID');
        
        // 오늘 정산 예정액과 건수에서 차감 (총 매출액 차감)
        final grossAmount = int.tryParse(settlement.settlementAmount) ?? 0;
        _todayAmount -= grossAmount;
        _todayCount -= 1;
        
        // 0 이하로 내려가지 않도록 방지
        if (_todayAmount < 0) _todayAmount = 0;
        if (_todayCount < 0) _todayCount = 0;
      }
    });
    
    final grossAmount = int.tryParse(settlement.settlementAmount) ?? 0;
    final paymentFee = (grossAmount * 0.033).round();
    final brokerageFee = (grossAmount * 0.01).round();
    final netAmount = grossAmount - paymentFee - brokerageFee;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${settlement.businessName ?? settlement.storeName}의 정산이 완료되었습니다.\n'
          '실제 정산 금액: ${_formatCurrency(netAmount.toString())}원 '
          '(수수료 ${_formatCurrency((paymentFee + brokerageFee).toString())}원 제외)',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _exportToExcel() {
    final settlements = _getFilteredSettlements();
    
    // CSV 형식의 데이터 생성
    final csvData = <List<String>>[
      ['사업자명', '사업자번호', '요청금액', '요청일', '상태', '은행명', '계좌번호', '예금주'],
      ...settlements.map((settlement) => [
        settlement.businessName ?? settlement.storeName ?? '-',
        settlement.businessId,
        settlement.settlementAmount,
        settlement.settlementDate,
        settlement.status == 'PENDING' ? '정산전' : '정산완료',
        settlement.bankName ?? '-',
        settlement.accountNumber ?? '-',
        settlement.accountHolder ?? '-',
      ]),
    ];
    
    // CSV 문자열 생성
    final csvString = csvData.map((row) => row.join(',')).join('\n');
    
    // 파일 다운로드
    final bytes = utf8.encode(csvString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '정산목록_${DateTime.now().toString().substring(0, 10)}.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('정산 목록이 다운로드되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  List<SettlementModel> _getFilteredSettlements() {
    int currentTabIndex = _tabController.index;
    
    return _settlements.where((settlement) {
      // 탭 필터링
      bool passesTabFilter;
      switch (currentTabIndex) {
        case 0: // 전체
          passesTabFilter = true;
          break;
        case 1: // 정산전
          passesTabFilter = settlement.status == 'PENDING';
          break;
        case 2: // 정산완료
          passesTabFilter = settlement.status == 'PAID';
          break;
        default:
          passesTabFilter = true;
      }
      
      // 사업자명 필터링
      bool passesBusinessFilter;
      if (_selectedBusiness == null || _selectedBusiness == 'ALL') {
        passesBusinessFilter = true;
      } else {
        final selectedBusinessName = _getBusinessNameById(_selectedBusiness!);
        passesBusinessFilter = settlement.businessName?.contains(selectedBusinessName) == true;
      }
      
      return passesTabFilter && passesBusinessFilter;
    }).toList()..sort((a, b) {
      // 정산전을 위로, 정산완료를 아래로
      if (a.status == 'PENDING' && b.status == 'PAID') return -1;
      if (a.status == 'PAID' && b.status == 'PENDING') return 1;
      return 0;
    });
  }

  List<SettlementModel> _getSampleSettlements() {
    return [
      SettlementModel(
        id: '1',
        businessId: '123-45-67890',
        businessName: '맛있는집',
        storeId: '1',
        storeName: '맛있는집 강남점',
        settlementDate: '2024.09.14 15:30',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-15',
        totalSalesAmount: '2850000',
        platformFeeRate: '5.0',
        platformFeeAmount: '142500',
        deliveryFeeAmount: '57000',
        adjustmentAmount: '0',
        settlementAmount: '180000',
        status: 'PENDING',
        totalOrders: 95,
        completedOrders: 93,
        cancelledOrders: 2,
        bankName: '국민은행',
        accountNumber: '123456-78-901234',
        accountHolder: '김사장',
      ),
      SettlementModel(
        id: '2',
        businessId: '234-56-78901',
        businessName: '치킨왕',
        storeId: '2',
        storeName: '치킨왕 홍대점',
        settlementDate: '2024.09.14 14:15',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-15',
        totalSalesAmount: '1950000',
        platformFeeRate: '5.0',
        platformFeeAmount: '97500',
        deliveryFeeAmount: '45000',
        adjustmentAmount: '0',
        settlementAmount: '320000',
        status: 'PENDING',
        totalOrders: 78,
        completedOrders: 76,
        cancelledOrders: 2,
        bankName: '신한은행',
        accountNumber: '567890-12-345678',
        accountHolder: '이사장',
      ),
      SettlementModel(
        id: '3',
        businessId: '345-67-89012',
        businessName: '피자마을',
        storeId: '3',
        storeName: '피자마을 신촌점',
        settlementDate: '2024.09.14 13:45',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-15',
        totalSalesAmount: '3200000',
        platformFeeRate: '5.0',
        platformFeeAmount: '160000',
        deliveryFeeAmount: '75000',
        adjustmentAmount: '0',
        settlementAmount: '95000',
        status: 'PENDING',
        totalOrders: 112,
        completedOrders: 108,
        cancelledOrders: 4,
        bankName: '하나은행',
        accountNumber: '789012-34-567890',
        accountHolder: '박대표',
      ),
      SettlementModel(
        id: '4',
        businessId: '456-78-90123',
        businessName: '분식왕',
        storeId: '4',
        storeName: '분식왕 명동점',
        settlementDate: '2024.09.13 16:20',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-15',
        totalSalesAmount: '1200000',
        platformFeeRate: '5.0',
        platformFeeAmount: '60000',
        deliveryFeeAmount: '30000',
        adjustmentAmount: '0',
        settlementAmount: '180000',
        status: 'PAID',
        totalOrders: 65,
        completedOrders: 63,
        cancelledOrders: 2,
        bankName: '우리은행',
        accountNumber: '012345-67-890123',
        accountHolder: '정사장',
      ),
      SettlementModel(
        id: '5',
        businessId: '567-89-01234',
        businessName: '카페스타',
        storeId: '5',
        storeName: '카페스타 홍대점',
        settlementDate: '2024.09.12 11:10',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-15',
        totalSalesAmount: '890000',
        platformFeeRate: '5.0',
        platformFeeAmount: '44500',
        deliveryFeeAmount: '22000',
        adjustmentAmount: '0',
        settlementAmount: '150000',
        status: 'PAID',
        totalOrders: 45,
        completedOrders: 44,
        cancelledOrders: 1,
        bankName: '기업은행',
        accountNumber: '345678-90-123456',
        accountHolder: '최대표',
      ),
    ];
  }

  String _formatCurrency(String value) {
    final num = int.tryParse(value) ?? 0;
    return num.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}