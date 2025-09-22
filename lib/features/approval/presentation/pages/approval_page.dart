import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/approval_request_model.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatus = 'ALL';
  List<ApprovalRequestModel> _approvalRequests = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadApprovalRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadApprovalRequests() {
    setState(() {
      _approvalRequests = _getSampleApprovalRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.approval,
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
              _buildStatsCards(),
              SizedBox(height: AppSizes.md),
              _buildTabBar(),
              SizedBox(height: AppSizes.md),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildApprovalTable('BUSINESS_INFO'),
                    _buildApprovalTable('BANK_ACCOUNT'),
                    _buildApprovalTable('STORE_INFO'),
                    _buildApprovalTable('MENU_ITEM'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      '승인관리',
      style: TextStyle(
        fontSize: 36.sp, // 30.sp -> 36.sp (가독성 개선)
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatsCards() {
    final pendingCount = _approvalRequests.where((req) => req.status == 'PENDING').length;
    final approvedCount = _approvalRequests.where((req) => req.status == 'APPROVED').length;
    final rejectedCount = _approvalRequests.where((req) => req.status == 'REJECTED').length;
    final totalCount = _approvalRequests.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            '전체',
            '$totalCount',
            '승인요청',
            AppColors.textPrimary,
            MdiIcons.clipboardListOutline,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: _buildStatusCard(
            '대기',
            '$pendingCount',
            '승인대기',
            AppColors.warning,
            MdiIcons.clockOutline,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: _buildStatusCard(
            '승인',
            '$approvedCount',
            '승인완료',
            AppColors.success,
            MdiIcons.checkCircleOutline,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: _buildStatusCard(
            '반려',
            '$rejectedCount',
            '반려처리',
            AppColors.error,
            MdiIcons.closeCircleOutline,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp, // 18.sp -> 20.sp
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 34.sp, // 32.sp -> 34.sp
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 18.sp, // 16.sp -> 18.sp
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                Icon(
                  icon,
                  size: AppSizes.iconLg,
                  color: color.withOpacity(0.7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child:               Text(
                '사업자 승인',
              style: TextStyle(
                  fontSize: 18.sp, // 16.sp -> 18.sp
                  fontWeight: FontWeight.w600,
                ),
              ),
          ),
          Tab(
            child:               Text(
                '통장 승인',
                style: TextStyle(
                  fontSize: 18.sp, // 16.sp -> 18.sp
                  fontWeight: FontWeight.w600,
                ),
              ),
          ),
          Tab(
            child:               Text(
                '매장 승인',
                style: TextStyle(
                  fontSize: 18.sp, // 16.sp -> 18.sp
                  fontWeight: FontWeight.w600,
                ),
              ),
          ),
          Tab(
            child:               Text(
                '메뉴 승인',
                style: TextStyle(
                  fontSize: 18.sp, // 16.sp -> 18.sp
                  fontWeight: FontWeight.w600,
                ),
              ),
          ),
        ],
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        isScrollable: false,
      ),
    );
  }

  Widget _buildApprovalTable(String requestType) {
    final filteredRequests = _getFilteredRequestsByType(requestType);
    
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
                  '승인 요청 목록',
                  style: TextStyle(
                    fontSize: 24.sp, // 22.sp -> 24.sp
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '총 ${filteredRequests.length}건',
                  style: TextStyle(
                    fontSize: 20.sp, // 18.sp -> 20.sp
                    color: AppColors.textSecondary,
                  ),
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
                    columnSpacing: 25.w, // 컬럼 간격을 더 넓게
                    dataRowMinHeight: 52.h,
                    dataRowMaxHeight: 60.h,
                    columns: [
                      DataColumn(
                        label: Text(
                          '요청번호',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp, // 18.sp -> 20.sp
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청유형',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp, // 18.sp -> 20.sp
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청자',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp, // 18.sp -> 20.sp
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청내용',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp, // 18.sp -> 20.sp
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청일',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp, // 18.sp -> 20.sp
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '상태',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp, // 18.sp -> 20.sp
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '작업',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp, // 18.sp -> 20.sp
                          ),
                        ),
                      ),
                    ],
                    rows: filteredRequests.map((request) => _buildDataRow(request)).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(ApprovalRequestModel request) {
    return DataRow(
      onSelectChanged: (_) => _showApprovalDetailDialog(request),
      cells: [
        DataCell(
          InkWell(
            onTap: () => _showApprovalDetailDialog(request),
            child:             Text(
            request.requestNumber,
              style: TextStyle(
                fontSize: 18.sp, // 16.sp -> 18.sp
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => _showApprovalDetailDialog(request),
            child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: _getTypeColor(request.requestType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
              child:               Text(
              request.displayRequestType,
              style: TextStyle(
                  fontSize: 16.sp, // 14.sp -> 16.sp
                fontWeight: FontWeight.w600,
                color: _getTypeColor(request.requestType),
                ),
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => _showApprovalDetailDialog(request),
            child:             Text(
            request.requester,
              style: TextStyle(fontSize: 18.sp), // 16.sp -> 18.sp
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => _showApprovalDetailDialog(request),
            child: SizedBox(
            width: 200.w,
              child:               Text(
              request.requestContent,
                style: TextStyle(fontSize: 18.sp), // 16.sp -> 18.sp
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => _showApprovalDetailDialog(request),
            child:             Text(
            request.requestDate,
              style: TextStyle(fontSize: 18.sp), // 16.sp -> 18.sp
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => _showApprovalDetailDialog(request),
            child: _buildStatusChip(request.status),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () => _showApprovalDetailDialog(request),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.xs,
              ),
            ),
            child:             Text(
              '상세보기',
              style: TextStyle(fontSize: 16.sp), // 14.sp -> 16.sp
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;
    
    switch (status) {
      case 'PENDING':
        chipColor = AppColors.warning;
        statusText = '승인대기';
        break;
      case 'APPROVED':
        chipColor = AppColors.success;
        statusText = '승인완료';
        break;
      case 'REJECTED':
        chipColor = AppColors.error;
        statusText = '반려';
        break;
      default:
        chipColor = AppColors.textSecondary;
        statusText = '알 수 없음';
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
          fontSize: 16.sp, // 14.sp -> 16.sp
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'BUSINESS_INFO':
        return AppColors.primary;
      case 'STORE_INFO':
        return AppColors.secondary;
      case 'BANK_ACCOUNT':
        return AppColors.info;
      case 'MENU_ITEM':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  List<ApprovalRequestModel> _getFilteredRequestsByType(String requestType) {
    return _approvalRequests.where((req) => req.requestType == requestType).toList();
  }

  void _showApprovalDetailDialog(ApprovalRequestModel request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          child: Container(
            width: 800.w,
            height: 600.h,
            padding: EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '승인 요청 상세',
                      style: TextStyle(
                        fontSize: 26.sp, // 24.sp -> 26.sp
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(MdiIcons.close),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.lg),
                
                // 요청 정보
                _buildRequestInfo(request),
                SizedBox(height: AppSizes.lg),
                
                // AS-IS / TO-BE 비교
                Expanded(child: _buildComparisonSection(request)),
                SizedBox(height: AppSizes.lg),
                
                // 승인/반려 버튼
                if (request.status == 'PENDING') _buildApprovalActions(request),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestInfo(ApprovalRequestModel request) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '요청 정보',
              style: TextStyle(
                fontSize: 20.sp, // 18.sp -> 20.sp
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow('요청번호', request.requestNumber),
                ),
                Expanded(
                  child: _buildInfoRow('요청유형', request.displayRequestType),
                ),
              ],
            ),
            SizedBox(height: AppSizes.xs),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow('요청자', request.requester),
                ),
                Expanded(
                  child: _buildInfoRow('요청일', request.requestDate),
                ),
              ],
            ),
            SizedBox(height: AppSizes.xs),
            _buildInfoRow('요청내용', request.requestContent),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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

  Widget _buildComparisonSection(ApprovalRequestModel request) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '변경 내용 비교',
              style: TextStyle(
                fontSize: 20.sp, // 18.sp -> 20.sp
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: Row(
                children: [
                  // AS-IS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            border: Border.all(color: Colors.red[300]!),
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: Text(
                            'AS-IS (기존)',
                            style: TextStyle(
                              fontSize: 18.sp, // 16.sp -> 18.sp
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: AppSizes.sm),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSizes.sm),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                            ),
                            child: SingleChildScrollView(
                              child: _buildDataDisplay(request.asIsData),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSizes.md),
                  // TO-BE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green[300]!),
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: Text(
                            'TO-BE (변경)',
                            style: TextStyle(
                              fontSize: 18.sp, // 16.sp -> 18.sp
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: AppSizes.sm),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSizes.sm),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                            ),
                            child: SingleChildScrollView(
                              child: _buildDataDisplay(request.toBeData),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataDisplay(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return Text(
        '변경 사항 없음',
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textTertiary,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                entry.value.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildApprovalActions(ApprovalRequestModel request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showRejectConfirmDialog(request),
          icon: Icon(MdiIcons.close, size: AppSizes.iconSm),
          label: Text('반려'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
          ),
        ),
        SizedBox(width: AppSizes.lg),
        ElevatedButton.icon(
          onPressed: () => _showApproveConfirmDialog(request),
          icon: Icon(MdiIcons.check, size: AppSizes.iconSm),
          label: Text('승인'),
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

  void _approveRequest(ApprovalRequestModel request) {
    // 실제 데이터 변경 처리
    _applyDataChanges(request);
    
    setState(() {
      final index = _approvalRequests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _approvalRequests[index] = request.copyWith(
          status: 'APPROVED',
          processedDate: DateTime.now().toString().substring(0, 10),
          processedBy: '관리자',
        );
      }
    });
    
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.displayRequestType} 요청이 승인되어 데이터가 변경되었습니다.'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _rejectRequest(ApprovalRequestModel request) {
    setState(() {
      final index = _approvalRequests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _approvalRequests[index] = request.copyWith(
          status: 'REJECTED',
          processedDate: DateTime.now().toString().substring(0, 10),
          processedBy: '관리자',
          rejectionReason: '관리자에 의해 반려되었습니다.',
        );
      }
    });
    
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.displayRequestType} 요청이 반려되었습니다.'),
        backgroundColor: AppColors.error,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // 승인 시 실제 데이터 변경 처리
  void _applyDataChanges(ApprovalRequestModel request) {
    if (request.toBeData == null) return;
    
    switch (request.requestType) {
      case 'BUSINESS_INFO':
        _applyBusinessInfoChanges(request);
        break;
      case 'STORE_INFO':
        _applyStoreInfoChanges(request);
        break;
      case 'BANK_ACCOUNT':
        _applyBankAccountChanges(request);
        break;
      case 'MENU_ITEM':
        _applyMenuItemChanges(request);
        break;
    }
  }

  void _applyBusinessInfoChanges(ApprovalRequestModel request) {
    // 실제 프로젝트에서는 비즈니스 데이터베이스에서 해당 데이터를 업데이트
    print('사업자 정보 변경 적용: ${request.toBeData}');
    // 예시: 주소 변경, 사업자번호 변경 등
    // BusinessService.updateBusinessInfo(request.businessId, request.toBeData);
  }

  void _applyStoreInfoChanges(ApprovalRequestModel request) {
    // 실제 프로젝트에서는 매장 데이터베이스에서 해당 데이터를 업데이트
    print('매장 정보 변경 적용: ${request.toBeData}');
    // 예시: 운영시간 변경, 전화번호 변경 등
    // StoreService.updateStoreInfo(request.storeId, request.toBeData);
  }

  void _applyBankAccountChanges(ApprovalRequestModel request) {
    // 실제 프로젝트에서는 계좌 정보를 업데이트
    print('계좌 정보 변경 적용: ${request.toBeData}');
    // 예시: 정산 계좌 변경
    // BankAccountService.updateAccount(request.businessId, request.toBeData);
  }

  void _applyMenuItemChanges(ApprovalRequestModel request) {
    // 실제 프로젝트에서는 메뉴 데이터베이스에서 해당 데이터를 업데이트
    print('메뉴 정보 변경 적용: ${request.toBeData}');
    // 예시: 신메뉴 추가, 메뉴 가격 변경 등
    // MenuService.updateMenuItem(request.storeId, request.toBeData);
  }

  // 승인 확인 다이얼로그
  void _showApproveConfirmDialog(ApprovalRequestModel request) {
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
                '승인 확인',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '다음 요청을 승인하시겠습니까?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.md),
              Container(
                padding: EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConfirmRow('요청번호', request.requestNumber),
                    _buildConfirmRow('요청유형', request.displayRequestType),
                    _buildConfirmRow('요청자', request.requester),
                    _buildConfirmRow('요청내용', request.requestContent),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                '승인 시 해당 데이터가 변경됩니다.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _approveRequest(request);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
              ),
              child: Text(
                '승인',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  // 반려 확인 다이얼로그
  void _showRejectConfirmDialog(ApprovalRequestModel request) {
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
                MdiIcons.closeCircle,
                color: AppColors.error,
                size: AppSizes.iconMd,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                '반려 확인',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '다음 요청을 반려하시겠습니까?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.md),
              Container(
                padding: EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConfirmRow('요청번호', request.requestNumber),
                    _buildConfirmRow('요청유형', request.displayRequestType),
                    _buildConfirmRow('요청자', request.requester),
                    _buildConfirmRow('요청내용', request.requestContent),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                '반려 시 요청된 변경사항이 적용되지 않습니다.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectRequest(request);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text(
                '반려',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
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

  List<ApprovalRequestModel> _getSampleApprovalRequests() {
    return [
      ApprovalRequestModel(
        id: '1',
        requestNumber: 'AR-2024-001',
        requestType: 'BUSINESS_INFO',
        requester: '김영희 (도미노피자 강남점)',
        requestContent: '사업자 주소 변경 요청 - 서울시 강남구 테헤란로 123',
        requestDate: '2024-09-15',
        status: 'PENDING',
        businessId: '1',
        description: '사업장 이전으로 인한 주소 변경',
        asIsData: {
          'address': '서울시 강남구 역삼동 456',
          'detailAddress': '2층',
        },
        toBeData: {
          'address': '서울시 강남구 테헤란로 123',
          'detailAddress': '1층',
        },
      ),
      ApprovalRequestModel(
        id: '2',
        requestNumber: 'AR-2024-002',
        requestType: 'STORE_INFO',
        requester: '이철수 (맥도날드 홍대점)',
        requestContent: '매장 운영시간 변경 요청 - 09:00~23:00',
        requestDate: '2024-09-14',
        status: 'APPROVED',
        storeId: '2',
        description: '고객 요청에 따른 운영시간 연장',
        asIsData: {
          'openTime': '10:00',
          'closeTime': '22:00',
        },
        toBeData: {
          'openTime': '09:00',
          'closeTime': '23:00',
        },
        processedDate: '2024-09-14',
        processedBy: '관리자',
      ),
      ApprovalRequestModel(
        id: '3',
        requestNumber: 'AR-2024-003',
        requestType: 'BANK_ACCOUNT',
        requester: '박민수 (버거킹 신촌점)',
        requestContent: '정산 계좌 변경 요청 - 우리은행 1002-123-456789',
        requestDate: '2024-09-13',
        status: 'PENDING',
        businessId: '3',
        description: '기존 계좌 해지로 인한 계좌 변경',
        asIsData: {
          'bankName': '신한은행',
          'accountNumber': '110-123-456789',
          'accountHolder': '박민수',
        },
        toBeData: {
          'bankName': '우리은행',
          'accountNumber': '1002-123-456789',
          'accountHolder': '박민수',
        },
      ),
      ApprovalRequestModel(
        id: '4',
        requestNumber: 'AR-2024-004',
        requestType: 'MENU_ITEM',
        requester: '최지영 (피자헛 잠실점)',
        requestContent: '신메뉴 등록 요청 - 불고기 피자 L사이즈 28,900원',
        requestDate: '2024-09-12',
        status: 'REJECTED',
        storeId: '4',
        description: '시즌 한정 메뉴 출시',
        asIsData: null,
        toBeData: {
          'menuName': '불고기 피자',
          'price': '28900',
          'description': '한국식 불고기와 채소를 올린 피자',
          'category': '프리미엄 피자',
        },
        processedDate: '2024-09-12',
        processedBy: '관리자',
        rejectionReason: '메뉴 이미지와 상세 설명이 부족합니다.',
      ),
      ApprovalRequestModel(
        id: '5',
        requestNumber: 'AR-2024-005',
        requestType: 'BUSINESS_INFO',
        requester: '정수민 (스타벅스 명동점)',
        requestContent: '사업자등록번호 변경 요청 - 123-45-67890',
        requestDate: '2024-09-11',
        status: 'PENDING',
        businessId: '5',
        description: '법인 전환으로 인한 사업자번호 변경',
        asIsData: {
          'businessNumber': '123-45-12345',
          'businessType': '개인사업자',
        },
        toBeData: {
          'businessNumber': '123-45-67890',
          'businessType': '법인',
        },
      ),
      ApprovalRequestModel(
        id: '6',
        requestNumber: 'AR-2024-006',
        requestType: 'STORE_INFO',
        requester: '한지수 (서브웨이 강남역점)',
        requestContent: '매장 전화번호 변경 요청 - 02-1234-5678',
        requestDate: '2024-09-10',
        status: 'APPROVED',
        storeId: '6',
        description: '기존 번호 장애로 인한 번호 변경',
        asIsData: {
          'phoneNumber': '02-9876-5432',
        },
        toBeData: {
          'phoneNumber': '02-1234-5678',
        },
        processedDate: '2024-09-10',
        processedBy: '관리자',
      ),
    ];
  }
}

