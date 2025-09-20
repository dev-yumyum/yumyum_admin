import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/models/approval_request_model.dart';

class ApprovalDetailDialog extends StatefulWidget {
  final ApprovalRequestModel request;
  final Function(ApprovalRequestModel, bool, String?)? onProcessed;

  const ApprovalDetailDialog({
    super.key,
    required this.request,
    this.onProcessed,
  });

  @override
  State<ApprovalDetailDialog> createState() => _ApprovalDetailDialogState();
}

class _ApprovalDetailDialogState extends State<ApprovalDetailDialog> {
  final TextEditingController _rejectionReasonController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 800.w,
        height: 700.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfo(),
                    SizedBox(height: AppSizes.lg),
                    _buildComparisonSection(),
                    if (widget.request.status == ApprovalRequestModel.statusPending) ...[
                      SizedBox(height: AppSizes.lg),
                      _buildRejectionReasonInput(),
                    ],
                  ],
                ),
              ),
            ),
            if (widget.request.status == ApprovalRequestModel.statusPending)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          Icon(
            _getRequestTypeIcon(),
            color: AppColors.primary,
            size: AppSizes.iconMd,
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.request.displayRequestType} 승인 요청 상세',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  widget.request.requestNumber,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusChip(),
          SizedBox(width: AppSizes.sm),
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
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기본 정보',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            _buildInfoRow('요청번호', widget.request.requestNumber),
            _buildInfoRow('요청유형', widget.request.displayRequestType),
            _buildInfoRow('요청자', widget.request.requester),
            _buildInfoRow('요청내용', widget.request.requestContent),
            _buildInfoRow('요청일시', widget.request.requestDate),
            if (widget.request.description != null)
              _buildInfoRow('설명', widget.request.description!),
            if (widget.request.processedDate != null)
              _buildInfoRow('처리일시', widget.request.processedDate!),
            if (widget.request.processedBy != null)
              _buildInfoRow('처리자', widget.request.processedBy!),
            if (widget.request.rejectionReason != null) ...[
              Divider(height: AppSizes.lg),
              Text(
                '반려 사유',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Text(
                  widget.request.rejectionReason!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSection() {
    if (widget.request.asIsData == null || widget.request.toBeData == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '변경 사항 비교',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: _buildComparisonCard(
                    'AS-IS (변경 전)',
                    widget.request.asIsData!,
                    AppColors.warning,
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Icon(
                  MdiIcons.arrowRight,
                  color: AppColors.textSecondary,
                  size: AppSizes.iconLg,
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: _buildComparisonCard(
                    'TO-BE (변경 후)',
                    widget.request.toBeData!,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(String title, Map<String, dynamic> data, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          ...data.entries.map((entry) => _buildDataRow(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildDataRow(String key, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              _getDisplayName(key),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionReasonInput() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '반려 사유 (반려 시에만 작성)',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            TextFormField(
              controller: _rejectionReasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '반려 사유를 입력해주세요...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
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
          OutlinedButton(
            onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(100.w, 40.h),
            ),
            child: Text(
              '취소',
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          SizedBox(width: AppSizes.md),
          OutlinedButton(
            onPressed: _isProcessing ? null : () => _processRequest(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error),
              minimumSize: Size(100.w, 40.h),
            ),
            child: _isProcessing
                ? SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.error,
                    ),
                  )
                : Text(
                    '반려',
                    style: TextStyle(fontSize: 14.sp),
                  ),
          ),
          SizedBox(width: AppSizes.md),
          ElevatedButton(
            onPressed: _isProcessing ? null : () => _processRequest(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              minimumSize: Size(100.w, 40.h),
            ),
            child: _isProcessing
                ? SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    '승인',
                    style: TextStyle(fontSize: 14.sp),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText = widget.request.displayStatus;

    switch (widget.request.status) {
      case ApprovalRequestModel.statusPending:
        chipColor = AppColors.warning;
        break;
      case ApprovalRequestModel.statusApproved:
        chipColor = AppColors.success;
        break;
      case ApprovalRequestModel.statusRejected:
        chipColor = AppColors.error;
        break;
      default:
        chipColor = AppColors.inactive;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  IconData _getRequestTypeIcon() {
    switch (widget.request.requestType) {
      case ApprovalRequestModel.typeBusinessInfo:
        return MdiIcons.domain;
      case ApprovalRequestModel.typeStoreInfo:
        return MdiIcons.store;
      case ApprovalRequestModel.typeAccountInfo:
        return MdiIcons.bank;
      case ApprovalRequestModel.typeMenuInfo:
        return MdiIcons.food;
      default:
        return MdiIcons.fileDocument;
    }
  }

  String _getDisplayName(String key) {
    switch (key) {
      case 'businessName':
        return '사업자명';
      case 'businessNumber':
        return '사업자번호';
      case 'ownerName':
        return '대표자명';
      case 'ownerPhone':
        return '대표자 연락처';
      case 'businessAddress':
        return '사업장 주소';
      case 'storeName':
        return '매장명';
      case 'storePhone':
        return '매장 연락처';
      case 'storeAddress':
        return '매장 주소';
      case 'operatingHours':
        return '운영시간';
      case 'bankName':
        return '은행명';
      case 'accountNumber':
        return '계좌번호';
      case 'accountHolder':
        return '예금주';
      case 'menuName':
        return '메뉴명';
      case 'menuPrice':
        return '가격';
      case 'menuDescription':
        return '설명';
      case 'category':
        return '카테고리';
      default:
        return key;
    }
  }

  void _processRequest(bool isApproved) async {
    if (!isApproved && _rejectionReasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('반려 사유를 입력해주세요.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // 시뮬레이션을 위한 지연
    await Future.delayed(const Duration(seconds: 1));

    final updatedRequest = widget.request.copyWith(
      status: isApproved
          ? ApprovalRequestModel.statusApproved
          : ApprovalRequestModel.statusRejected,
      processedDate: DateTime.now().toString(),
      processedBy: '관리자', // 실제로는 현재 로그인한 사용자
      rejectionReason: isApproved ? null : _rejectionReasonController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      widget.onProcessed?.call(
        updatedRequest,
        isApproved,
        isApproved ? null : _rejectionReasonController.text.trim(),
      );

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.request.requester}의 ${widget.request.displayRequestType} 요청이 ${isApproved ? '승인' : '반려'}되었습니다.',
          ),
          backgroundColor: isApproved ? AppColors.success : AppColors.error,
        ),
      );
    }
  }
}
