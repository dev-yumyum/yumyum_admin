import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/settlement_model.dart';

class SettlementDetailPage extends StatefulWidget {
  final String settlementId;
  
  const SettlementDetailPage({
    super.key,
    required this.settlementId,
  });

  @override
  State<SettlementDetailPage> createState() => _SettlementDetailPageState();
}

class _SettlementDetailPageState extends State<SettlementDetailPage> {
  SettlementModel? _settlement;

  @override
  void initState() {
    super.initState();
    _loadSettlement();
  }

  void _loadSettlement() {
    // 실제로는 API 호출해서 데이터를 가져옴
    final settlements = _getSampleSettlements();
    _settlement = settlements.firstWhere(
      (s) => s.id == widget.settlementId,
      orElse: () => settlements.first,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_settlement == null) {
      return const CrmLayout(
        currentRoute: RouteNames.settlement,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CrmLayout(
      currentRoute: RouteNames.settlement,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            Expanded(
              child: _buildContent(),
            ),
            SizedBox(height: AppSizes.lg),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go(RouteNames.settlement),
          icon: Icon(
            MdiIcons.arrowLeft,
            size: AppSizes.iconMd,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Text(
          '정산 상세정보',
          style: TextStyle(
            fontSize: 36.sp, // 가독성 개선
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정산 요청 정보',
              style: TextStyle(
                fontSize: 24.sp, // 가독성 개선
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInfoRow('사업자명', _settlement!.businessName ?? _settlement!.storeName ?? '-'),
                    _buildInfoRow('은행명', _settlement!.bankName ?? '-'),
                    _buildInfoRow('계좌번호', _settlement!.accountNumber ?? '-'),
                    _buildInfoRow('예금주', _settlement!.accountHolder ?? '-'),
                    _buildInfoRow('요청금액', '${_formatCurrency(_settlement!.settlementAmount)}원'),
                    _buildInfoRow('요청일', _settlement!.settlementDate),
                    _buildInfoRow('상태', _getStatusText(_settlement!.status)),
                    SizedBox(height: AppSizes.lg),
                    _buildAmountBreakdown(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountBreakdown() {
    final grossAmount = int.tryParse(_settlement!.settlementAmount) ?? 0;
    final paymentFee = (grossAmount * 0.033).round();
    final brokerageFee = (grossAmount * 0.01).round();
    final netAmount = grossAmount - paymentFee - brokerageFee;

    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '정산 금액 상세',
            style: TextStyle(
              fontSize: 22.sp, // 가독성 개선
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.md),
          _buildAmountRow('총 매출액', grossAmount, false),
          _buildAmountRow('결제 수수료 (3.3%)', -paymentFee, true),
          _buildAmountRow('중개 수수료 (1.0%)', -brokerageFee, true),
          Divider(color: AppColors.border, thickness: 1),
          _buildAmountRow('실 정산액', netAmount, false, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, int amount, bool isNegative, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 22.sp : 20.sp, // 가독성 개선
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '${isNegative ? '-' : ''}${_formatCurrency(amount.abs().toString())}원',
            style: TextStyle(
              fontSize: isTotal ? 22.sp : 20.sp, // 가독성 개선
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal 
                ? AppColors.primary 
                : isNegative 
                  ? AppColors.error 
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => context.go(RouteNames.settlement),
          icon: Icon(MdiIcons.arrowLeft, size: AppSizes.iconSm),
          label: Text('뒤로가기'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
          ),
        ),
        SizedBox(width: AppSizes.md),
        if (_settlement!.status == 'PENDING')
          ElevatedButton.icon(
            onPressed: () => _showSettlementCompleteDialog(),
            icon: Icon(MdiIcons.checkCircle, size: AppSizes.iconSm),
            label: Text('정산완료하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
                vertical: AppSizes.md,
              ),
            ),
          ),
      ],
    );
  }

  void _showSettlementCompleteDialog() {
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
                '정산완료 확인',
                style: TextStyle(
                  fontSize: 24.sp, // 가독성 개선
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '정산완료처리를 하시겠습니까?',
                style: TextStyle(
                  fontSize: 20.sp, // 가독성 개선
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.md),
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '사업자명: ${_settlement!.businessName ?? _settlement!.storeName ?? '-'}',
                      style: TextStyle(
                        fontSize: 18.sp, // 가독성 개선
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      '정산금액: ${_formatCurrency(_settlement!.settlementAmount)}원',
                      style: TextStyle(
                        fontSize: 18.sp, // 가독성 개선
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(fontSize: 18.sp), // 가독성 개선
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _completeSettlement();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
              ),
              child: Text(
                '확인',
                style: TextStyle(fontSize: 18.sp), // 가독성 개선
              ),
            ),
          ],
        );
      },
    );
  }

  void _completeSettlement() {
    setState(() {
      _settlement = _settlement!.copyWith(status: 'PAID');
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '정산이 완료되었습니다.',
          style: TextStyle(fontSize: 18.sp), // 가독성 개선
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return '정산전';
      case 'PAID':
        return '정산완료';
      default:
        return status;
    }
  }

  String _formatCurrency(String amount) {
    final number = int.tryParse(amount) ?? 0;
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  List<SettlementModel> _getSampleSettlements() {
    return [
      SettlementModel(
        id: '1',
        businessId: '1',
        businessName: '㈜맛있는집',
        storeId: '1',
        storeName: '맛있는집 강남점',
        settlementDate: '2024-09-22',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-21',
        totalSalesAmount: '500000',
        platformFeeRate: '3.3',
        platformFeeAmount: '16500',
        deliveryFeeAmount: '33500',
        adjustmentAmount: '0',
        settlementAmount: '450000',
        status: 'PENDING',
        bankName: '국민은행',
        accountNumber: '12345678901234',
        accountHolder: '주식회사맛있는집',
        totalOrders: 25,
        completedOrders: 23,
        cancelledOrders: 2,
      ),
      SettlementModel(
        id: '2',
        businessId: '2',
        businessName: '치킨왕 프랜차이즈',
        storeId: '2',
        storeName: '치킨왕 홍대점',
        settlementDate: '2024-09-22',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-21',
        totalSalesAmount: '350000',
        platformFeeRate: '3.3',
        platformFeeAmount: '11550',
        deliveryFeeAmount: '18450',
        adjustmentAmount: '0',
        settlementAmount: '320000',
        status: 'PENDING',
        bankName: '신한은행',
        accountNumber: '98765432109876',
        accountHolder: '박치킨',
        totalOrders: 18,
        completedOrders: 16,
        cancelledOrders: 2,
      ),
      SettlementModel(
        id: '3',
        businessId: '3',
        businessName: '피자마을',
        storeId: '3',
        storeName: '피자마을 신촌점',
        settlementDate: '2024-09-21',
        periodStart: '2024-09-01',
        periodEnd: '2024-09-20',
        totalSalesAmount: '300000',
        platformFeeRate: '3.3',
        platformFeeAmount: '9900',
        deliveryFeeAmount: '10100',
        adjustmentAmount: '0',
        settlementAmount: '280000',
        status: 'PAID',
        bankName: '우리은행',
        accountNumber: '11111222223333',
        accountHolder: '이피자',
        totalOrders: 15,
        completedOrders: 14,
        cancelledOrders: 1,
      ),
    ];
  }
}
