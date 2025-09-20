import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/models/sales_model.dart';

class OrderDetailDialog extends StatelessWidget {
  final SalesModel order;

  const OrderDetailDialog({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600.w,
        height: 700.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfo(),
                    SizedBox(height: AppSizes.lg),
                    _buildOrderInfo(),
                    SizedBox(height: AppSizes.lg),
                    _buildOrderProgress(),
                  ],
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.borderRadius),
          topRight: Radius.circular(AppSizes.borderRadius),
        ),
      ),
      child: Row(
        children: [
          Text(
            '주문 상세정보',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              MdiIcons.close,
              size: AppSizes.iconMd,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기본 정보',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        _buildInfoRow('주문번호:', order.orderNumber),
        _buildInfoRow('매장명:', order.storeName ?? '-'),
        _buildInfoRow('고객명:', order.customerName ?? '-'),
        _buildInfoRow('고객연락처:', order.customerPhone ?? '-'),
      ],
    );
  }

  Widget _buildOrderInfo() {
    final paymentFee = _calculatePaymentFee(order.paymentAmount);
    final brokerageFee = _calculateBrokerageFee(order.paymentAmount);
    final totalFees = paymentFee + brokerageFee;
    final settlementAmount = order.paymentAmount - totalFees;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주문 정보',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        _buildInfoRow('주문메뉴:', order.menuItems ?? '치킨 버거 세트, 콜라 추가'),
        _buildInfoRow('주문금액:', '${_formatCurrency(order.orderAmount)}원'),
        _buildInfoRow('할인금액:', '${_formatCurrency(order.discountAmount ?? 0)}원'),
        _buildInfoRow('결제금액:', '${_formatCurrency(order.paymentAmount)}원'),
        Divider(height: AppSizes.lg),
        _buildInfoRow('결제수수료 (3.3%):', '${_formatCurrency(paymentFee)}원', isHighlight: true),
        _buildInfoRow('중개수수료 (1.0%):', '${_formatCurrency(brokerageFee)}원', isHighlight: true),
        _buildInfoRow('총 수수료:', '${_formatCurrency(totalFees)}원', isHighlight: true),
        _buildInfoRow('정산금액:', '${_formatCurrency(settlementAmount)}원', isHighlight: true, color: AppColors.success),
      ],
    );
  }

  Widget _buildOrderProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주문 진행 상황',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.lg),
        _buildProgressItem('결제완료', order.paymentCompleteTime ?? '2024.09.14 13:45', true),
        _buildProgressItem('주문접수', order.orderAcceptTime ?? '2024.09.14 13:47', _isStepCompleted('ORDER_RECEIVED')),
        _buildProgressItem('조리완료', order.cookingCompleteTime ?? '2024.09.14 14:25', _isStepCompleted('COOKING_COMPLETED')),
        _buildProgressItem('픽업완료', order.pickupCompleteTime ?? '2024.09.14 14:45', _isStepCompleted('PICKUP_COMPLETED')),
      ],
    );
  }

  Widget _buildProgressItem(String title, String time, bool isCompleted) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.md),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? Icon(
                    MdiIcons.check,
                    color: Colors.white,
                    size: 16.sp,
                  )
                : null,
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                if (isCompleted)
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textSecondary,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                color: color ?? (isHighlight ? AppColors.textPrimary : AppColors.textPrimary),
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.borderRadius),
          bottomRight: Radius.circular(AppSizes.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              minimumSize: Size(100.w, 40.h),
            ),
            child: Text(
              '닫기',
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ],
      ),
    );
  }

  bool _isStepCompleted(String step) {
    switch (step) {
      case 'ORDER_RECEIVED':
        return order.status != 'PAYMENT_COMPLETED';
      case 'COOKING_COMPLETED':
        return order.status == 'COOKING_COMPLETED' || order.status == 'PICKUP_COMPLETED';
      case 'PICKUP_COMPLETED':
        return order.status == 'PICKUP_COMPLETED';
      default:
        return false;
    }
  }

  int _calculatePaymentFee(int amount) {
    return (amount * 0.033).round();
  }

  int _calculateBrokerageFee(int amount) {
    return (amount * 0.01).round();
  }

  String _formatCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
