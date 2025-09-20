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
              _buildFilters(),
              SizedBox(height: AppSizes.md),
              Expanded(
                child: _buildApprovalTable(),
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
        fontSize: 28.sp,
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
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16.sp,
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

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '필터',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 'ALL', child: Text('전체 상태')),
                    DropdownMenuItem(value: 'PENDING', child: Text('승인대기')),
                    DropdownMenuItem(value: 'APPROVED', child: Text('승인완료')),
                    DropdownMenuItem(value: 'REJECTED', child: Text('반려')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalTable() {
    final filteredRequests = _getFilteredRequests();
    
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
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '총 ${filteredRequests.length}건',
                  style: TextStyle(
                    fontSize: 18.sp,
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
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청유형',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청자',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청내용',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '요청일',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '상태',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '작업',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
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
      cells: [
        DataCell(
          Text(
            request.requestNumber,
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: _getTypeColor(request.requestType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: Text(
              request.displayRequestType,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: _getTypeColor(request.requestType),
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            request.requester,
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        DataCell(
          SizedBox(
            width: 200.w,
            child: Text(
              request.requestContent,
              style: TextStyle(fontSize: 16.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Text(
            request.requestDate,
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        DataCell(
          _buildStatusChip(request.status),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () {
              context.go('/approval/detail?id=${request.id}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.xs,
              ),
            ),
            child: Text(
              '상세보기',
              style: TextStyle(fontSize: 14.sp),
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
          fontSize: 14.sp,
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

  List<ApprovalRequestModel> _getFilteredRequests() {
    if (_selectedStatus == 'ALL') {
      return _approvalRequests;
    }
    return _approvalRequests.where((req) => req.status == _selectedStatus).toList();
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
