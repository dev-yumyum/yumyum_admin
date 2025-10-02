import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  String _selectedFilter = '전체';
  final List<Map<String, dynamic>> _coupons = [];
  final TextEditingController _searchController = TextEditingController();
  String _currentView = 'coupons'; // 'coupons' or 'members'
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? _selectedMember;
  List<Map<String, dynamic>> _memberCoupons = [];

  // 샘플 회원 데이터
  final List<Map<String, dynamic>> _sampleMembers = [
    {
      'id': '1',
      'name': '김철수',
      'phone': '010-1234-5678',
      'email': 'kim@example.com',
      'registrationDate': '2024-01-15',
    },
    {
      'id': '2', 
      'name': '박영희',
      'phone': '010-9876-5432',
      'email': 'park@example.com',
      'registrationDate': '2024-02-20',
    },
    {
      'id': '3',
      'name': '이민수',
      'phone': '010-5555-1234',
      'email': 'lee@example.com',
      'registrationDate': '2024-03-10',
    },
    {
      'id': '4',
      'name': '최지영',
      'phone': '010-7777-8888',
      'email': 'choi@example.com',
      'registrationDate': '2024-01-25',
    },
    {
      'id': '5',
      'name': '홍길동',
      'phone': '010-1111-2222',
      'email': 'hong@example.com', 
      'registrationDate': '2024-02-05',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSampleCoupons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSampleCoupons() {
    setState(() {
      _coupons.addAll([
        {
          'id': '1',
          'name': '신규가입 환영 쿠폰',
          'type': 'DISCOUNT_AMOUNT',
          'discountAmount': 3000,
          'discountPercent': null,
          'minOrderAmount': 10000,
          'maxDiscountAmount': null,
          'validFrom': DateTime.now(),
          'validTo': DateTime.now().add(const Duration(days: 30)),
          'issuedCount': 1250,
          'usedCount': 380,
          'status': 'ACTIVE',
          'description': '신규가입 고객을 위한 3,000원 할인 쿠폰',
        },
        {
          'id': '2',
          'name': '첫 주문 20% 할인',
          'type': 'DISCOUNT_PERCENT',
          'discountAmount': null,
          'discountPercent': 20,
          'minOrderAmount': 15000,
          'maxDiscountAmount': 5000,
          'validFrom': DateTime.now().subtract(const Duration(days: 7)),
          'validTo': DateTime.now().add(const Duration(days: 23)),
          'issuedCount': 800,
          'usedCount': 156,
          'status': 'ACTIVE',
          'description': '첫 주문 고객 대상 20% 할인 쿠폰 (최대 5,000원)',
        },
        {
          'id': '3',
          'name': '주말 특가 쿠폰',
          'type': 'DISCOUNT_AMOUNT',
          'discountAmount': 5000,
          'discountPercent': null,
          'minOrderAmount': 25000,
          'maxDiscountAmount': null,
          'validFrom': DateTime.now().subtract(const Duration(days: 14)),
          'validTo': DateTime.now().subtract(const Duration(days: 1)),
          'issuedCount': 500,
          'usedCount': 320,
          'status': 'EXPIRED',
          'description': '주말 한정 5,000원 할인 쿠폰',
        },
        {
          'id': '4',
          'name': '리뷰 작성 감사 쿠폰',
          'type': 'DISCOUNT_PERCENT',
          'discountAmount': null,
          'discountPercent': 15,
          'minOrderAmount': 20000,
          'maxDiscountAmount': 3000,
          'validFrom': DateTime.now().add(const Duration(days: 1)),
          'validTo': DateTime.now().add(const Duration(days: 45)),
          'issuedCount': 0,
          'usedCount': 0,
          'status': 'SCHEDULED',
          'description': '리뷰 작성 고객 대상 15% 할인 쿠폰 (최대 3,000원)',
        },
        {
          'id': '5',
          'name': '단골 고객 특별 혜택',
          'type': 'DISCOUNT_AMOUNT',
          'discountAmount': 10000,
          'discountPercent': null,
          'minOrderAmount': 50000,
          'maxDiscountAmount': null,
          'validFrom': DateTime.now(),
          'validTo': DateTime.now().add(const Duration(days: 60)),
          'issuedCount': 200,
          'usedCount': 45,
          'status': 'ACTIVE',
          'description': 'VIP 고객 대상 10,000원 할인 쿠폰',
        },
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.coupon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppSizes.lg),
          _buildSearchBar(),
          SizedBox(height: AppSizes.lg),
          if (_currentView == 'coupons') ...[
            _buildFilterBar(),
            SizedBox(height: AppSizes.lg),
            Expanded(child: _buildCouponsTable()),
          ] else if (_currentView == 'members') ...[
            _buildMemberSearchResults(),
          ] else if (_currentView == 'member_coupons') ...[
            _buildMemberCouponsView(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (_currentView != 'coupons')
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentView = 'coupons';
                    _selectedMember = null;
                    _searchController.clear();
                    _searchResults.clear();
                  });
                },
                icon: Icon(MdiIcons.arrowLeft, size: AppSizes.iconMd),
                tooltip: '쿠폰 목록으로 돌아가기',
              ),
            Text(
              _getHeaderTitle(),
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        if (_currentView == 'coupons')
          ElevatedButton.icon(
            onPressed: _showAddCouponDialog,
            icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
            label: Text(
              '쿠폰 생성',
              style: TextStyle(fontSize: 16.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
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

  String _getHeaderTitle() {
    switch (_currentView) {
      case 'members':
        return '회원 검색 결과';
      case 'member_coupons':
        return '${_selectedMember?['name']}님의 쿠폰';
      default:
        return '쿠폰관리';
    }
  }

  Widget _buildSearchBar() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(MdiIcons.accountSearch, color: AppColors.primary, size: AppSizes.iconMd),
                SizedBox(width: AppSizes.sm),
                Text(
                  '회원별 쿠폰 조회',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '회원명 또는 연락처를 입력하세요 (예: 김철수, 010-1234-5678)',
                      prefixIcon: Icon(MdiIcons.magnify),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.md,
                      ),
                    ),
                    onFieldSubmitted: (value) => _searchMembers(),
                  ),
                ),
                SizedBox(width: AppSizes.md),
                ElevatedButton.icon(
                  onPressed: _searchMembers,
                  icon: Icon(MdiIcons.magnify, size: AppSizes.iconSm),
                  label: Text('검색'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                      vertical: AppSizes.md,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty) ...[
                  SizedBox(width: AppSizes.sm),
                  OutlinedButton.icon(
                    onPressed: _clearSearch,
                    icon: Icon(MdiIcons.close, size: AppSizes.iconSm),
                    label: Text('초기화'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.md,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (_currentView == 'coupons')
              Padding(
                padding: EdgeInsets.only(top: AppSizes.sm),
                child: Text(
                  '💡 회원명 또는 연락처로 검색하여 개별 회원의 쿠폰 사용 내역을 확인할 수 있습니다.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['전체', '활성', '만료', '예정'];
    
    return Row(
      children: [
        Icon(MdiIcons.filter, color: AppColors.textSecondary, size: AppSizes.iconSm),
        SizedBox(width: AppSizes.sm),
        Text(
          '상태 필터:',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: AppSizes.md),
        ...filters.map((filter) => Padding(
          padding: EdgeInsets.only(right: AppSizes.sm),
          child: ChoiceChip(
            label: Text(filter),
            selected: _selectedFilter == filter,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedFilter = filter);
              }
            },
            selectedColor: AppColors.primary.withOpacity(0.2),
            labelStyle: TextStyle(
              color: _selectedFilter == filter 
                ? AppColors.primary 
                : AppColors.textSecondary,
              fontWeight: _selectedFilter == filter 
                ? FontWeight.w600 
                : FontWeight.normal,
            ),
          ),
        )),
        const Spacer(),
        Text(
          '총 ${_getFilteredCoupons().length}개',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponsTable() {
    final filteredCoupons = _getFilteredCoupons();
    
    if (filteredCoupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.ticketPercent,
              size: AppSizes.iconXl * 2,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSizes.md),
            Text(
              '등록된 쿠폰이 없습니다',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: AppSizes.md,
          columns: [
            DataColumn(
              label: Text(
                '쿠폰명',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '할인 정보',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '사용 조건',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '유효 기간',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '발급/사용',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '상태',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                '관리',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: filteredCoupons.map((coupon) => DataRow(
            cells: [
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      coupon['name'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (coupon['description'] != null)
                      Text(
                        coupon['description'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (coupon['type'] == 'DISCOUNT_AMOUNT')
                      Text(
                        '${_formatNumber(coupon['discountAmount'])}원 할인',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${coupon['discountPercent']}% 할인',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          if (coupon['maxDiscountAmount'] != null)
                            Text(
                              '최대 ${_formatNumber(coupon['maxDiscountAmount'])}원',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  '${_formatNumber(coupon['minOrderAmount'])}원 이상',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDate(coupon['validFrom']),
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      '~ ${_formatDate(coupon['validTo'])}',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '발급: ${_formatNumber(coupon['issuedCount'])}개',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      '사용: ${_formatNumber(coupon['usedCount'])}개',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(_buildStatusChip(coupon['status'])),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showCouponDetail(coupon),
                      icon: Icon(
                        MdiIcons.eye,
                        size: AppSizes.iconSm,
                        color: AppColors.info,
                      ),
                      tooltip: '상세 보기',
                    ),
                    IconButton(
                      onPressed: coupon['status'] == 'ACTIVE' 
                        ? () => _editCoupon(coupon) 
                        : null,
                      icon: Icon(
                        MdiIcons.pencil,
                        size: AppSizes.iconSm,
                        color: coupon['status'] == 'ACTIVE' 
                          ? AppColors.warning 
                          : AppColors.textTertiary,
                      ),
                      tooltip: '수정',
                    ),
                    IconButton(
                      onPressed: () => _deleteCoupon(coupon),
                      icon: Icon(
                        MdiIcons.delete,
                        size: AppSizes.iconSm,
                        color: AppColors.error,
                      ),
                      tooltip: '삭제',
                    ),
                  ],
                ),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 'ACTIVE':
        chipColor = AppColors.success;
        statusText = '활성';
        break;
      case 'EXPIRED':
        chipColor = AppColors.error;
        statusText = '만료';
        break;
      case 'SCHEDULED':
        chipColor = AppColors.warning;
        statusText = '예정';
        break;
      case 'INACTIVE':
        chipColor = AppColors.inactive;
        statusText = '비활성';
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
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredCoupons() {
    if (_selectedFilter == '전체') {
      return _coupons;
    }
    
    String statusFilter;
    switch (_selectedFilter) {
      case '활성':
        statusFilter = 'ACTIVE';
        break;
      case '만료':
        statusFilter = 'EXPIRED';
        break;
      case '예정':
        statusFilter = 'SCHEDULED';
        break;
      default:
        return _coupons;
    }
    
    return _coupons.where((coupon) => coupon['status'] == statusFilter).toList();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  // 회원 검색 기능
  void _searchMembers() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('검색어를 입력해주세요.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final results = _sampleMembers.where((member) {
      final name = member['name'].toLowerCase();
      final phone = member['phone'].replaceAll('-', '');
      return name.contains(query) || phone.contains(query.replaceAll('-', ''));
    }).toList();

    setState(() {
      _searchResults = results;
      _currentView = 'members';
    });

    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('검색 결과가 없습니다.'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchResults.clear();
      _currentView = 'coupons';
      _selectedMember = null;
    });
  }

  // 회원 검색 결과 화면
  Widget _buildMemberSearchResults() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.info.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(MdiIcons.informationOutline, color: AppColors.info),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    '검색어: "${_searchController.text}" • ${_searchResults.length}명 검색됨',
                    style: TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.lg),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.accountOff,
                          size: AppSizes.iconXl * 2,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: AppSizes.md),
                        Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final member = _searchResults[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: AppSizes.sm),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              member['name'][0],
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            member['name'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: AppSizes.xs),
                              Row(
                                children: [
                                  Icon(MdiIcons.phone, size: 14.sp, color: AppColors.textSecondary),
                                  SizedBox(width: AppSizes.xs),
                                  Text(member['phone']),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(MdiIcons.email, size: 14.sp, color: AppColors.textSecondary),
                                  SizedBox(width: AppSizes.xs),
                                  Text(member['email']),
                                ],
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: AppSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                            ),
                            child: Text(
                              '쿠폰 보기',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          onTap: () => _selectMember(member),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 회원 선택
  void _selectMember(Map<String, dynamic> member) {
    setState(() {
      _selectedMember = member;
      _currentView = 'member_coupons';
    });
    _loadMemberCoupons(member['id']);
  }

  // 회원별 쿠폰 로드
  void _loadMemberCoupons(String memberId) {
    // 샘플 데이터: 회원별 쿠폰 생성
    List<Map<String, dynamic>> memberCoupons = [];
    
    // 각 회원마다 다른 쿠폰 패턴 생성
    switch (memberId) {
      case '1': // 김철수
        memberCoupons = [
          {
            'id': 'mc1',
            'couponName': '신규가입 환영 쿠폰',
            'discountType': 'AMOUNT',
            'discountValue': '3,000원',
            'issuedDate': DateTime.now().subtract(const Duration(days: 15)),
            'validTo': DateTime.now().add(const Duration(days: 15)),
            'status': 'USED',
            'usedDate': DateTime.now().subtract(const Duration(days: 5)),
            'orderAmount': 15000,
          },
          {
            'id': 'mc2',
            'couponName': '첫 주문 20% 할인',
            'discountType': 'PERCENT',
            'discountValue': '20% (최대 5,000원)',
            'issuedDate': DateTime.now().subtract(const Duration(days: 10)),
            'validTo': DateTime.now().add(const Duration(days: 20)),
            'status': 'ACTIVE',
            'usedDate': null,
            'orderAmount': null,
          },
        ];
        break;
      case '2': // 박영희
        memberCoupons = [
          {
            'id': 'mc3',
            'couponName': '신규가입 환영 쿠폰',
            'discountType': 'AMOUNT',
            'discountValue': '3,000원',
            'issuedDate': DateTime.now().subtract(const Duration(days: 12)),
            'validTo': DateTime.now().add(const Duration(days: 18)),
            'status': 'ACTIVE',
            'usedDate': null,
            'orderAmount': null,
          },
          {
            'id': 'mc4',
            'couponName': '리뷰 작성 감사 쿠폰',
            'discountType': 'PERCENT',
            'discountValue': '15% (최대 3,000원)',
            'issuedDate': DateTime.now().subtract(const Duration(days: 8)),
            'validTo': DateTime.now().add(const Duration(days: 37)),
            'status': 'ACTIVE',
            'usedDate': null,
            'orderAmount': null,
          },
        ];
        break;
      case '3': // 이민수
        memberCoupons = [
          {
            'id': 'mc5',
            'couponName': '주말 특가 쿠폰',
            'discountType': 'AMOUNT',
            'discountValue': '5,000원',
            'issuedDate': DateTime.now().subtract(const Duration(days: 20)),
            'validTo': DateTime.now().subtract(const Duration(days: 5)),
            'status': 'EXPIRED',
            'usedDate': null,
            'orderAmount': null,
          },
          {
            'id': 'mc6',
            'couponName': '단골 고객 특별 혜택',
            'discountType': 'AMOUNT',
            'discountValue': '10,000원',
            'issuedDate': DateTime.now().subtract(const Duration(days: 3)),
            'validTo': DateTime.now().add(const Duration(days: 57)),
            'status': 'USED',
            'usedDate': DateTime.now().subtract(const Duration(days: 1)),
            'orderAmount': 55000,
          },
        ];
        break;
      case '4': // 최지영
        memberCoupons = [
          {
            'id': 'mc7',
            'couponName': '첫 주문 20% 할인',
            'discountType': 'PERCENT',
            'discountValue': '20% (최대 5,000원)',
            'issuedDate': DateTime.now().subtract(const Duration(days: 7)),
            'validTo': DateTime.now().add(const Duration(days: 23)),
            'status': 'ACTIVE',
            'usedDate': null,
            'orderAmount': null,
          },
        ];
        break;
      case '5': // 홍길동
        memberCoupons = [
          {
            'id': 'mc8',
            'couponName': '신규가입 환영 쿠폰',
            'discountType': 'AMOUNT',
            'discountValue': '3,000원',
            'issuedDate': DateTime.now().subtract(const Duration(days: 25)),
            'validTo': DateTime.now().add(const Duration(days: 5)),
            'status': 'USED',
            'usedDate': DateTime.now().subtract(const Duration(days: 20)),
            'orderAmount': 12000,
          },
          {
            'id': 'mc9',
            'couponName': '리뷰 작성 감사 쿠폰',
            'discountType': 'PERCENT',
            'discountValue': '15% (최대 3,000원)',
            'issuedDate': DateTime.now().subtract(const Duration(days: 15)),
            'validTo': DateTime.now().add(const Duration(days: 30)),
            'status': 'ACTIVE',
            'usedDate': null,
            'orderAmount': null,
          },
          {
            'id': 'mc10',
            'couponName': '단골 고객 특별 혜택',
            'discountType': 'AMOUNT',
            'discountValue': '10,000원',
            'issuedDate': DateTime.now().subtract(const Duration(days: 2)),
            'validTo': DateTime.now().add(const Duration(days: 58)),
            'status': 'ACTIVE',
            'usedDate': null,
            'orderAmount': null,
          },
        ];
        break;
    }

    setState(() {
      _memberCoupons = memberCoupons;
    });
  }

  // 회원별 쿠폰 화면
  Widget _buildMemberCouponsView() {
    if (_selectedMember == null) return const SizedBox.shrink();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 회원 정보 카드
          Card(
            color: AppColors.primary.withOpacity(0.05),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Text(
                      _selectedMember!['name'][0],
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedMember!['name'],
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        Row(
                          children: [
                            Icon(MdiIcons.phone, size: 16.sp, color: AppColors.textSecondary),
                            SizedBox(width: AppSizes.xs),
                            Text(
                              _selectedMember!['phone'],
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            SizedBox(width: AppSizes.md),
                            Icon(MdiIcons.email, size: 16.sp, color: AppColors.textSecondary),
                            SizedBox(width: AppSizes.xs),
                            Text(
                              _selectedMember!['email'],
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      border: Border.all(color: AppColors.success.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '보유 쿠폰',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${_memberCoupons.length}개',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.lg),
          
          // 쿠폰 목록
          Expanded(
            child: _memberCoupons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.ticketOutline,
                          size: AppSizes.iconXl * 2,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: AppSizes.md),
                        Text(
                          '보유한 쿠폰이 없습니다',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _memberCoupons.length,
                    itemBuilder: (context, index) {
                      final coupon = _memberCoupons[index];
                      return _buildMemberCouponCard(coupon);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 회원 쿠폰 카드
  Widget _buildMemberCouponCard(Map<String, dynamic> coupon) {
    final status = coupon['status'];
    Color statusColor;
    Color cardBorderColor;
    String statusText;

    switch (status) {
      case 'ACTIVE':
        statusColor = AppColors.success;
        cardBorderColor = AppColors.success.withOpacity(0.3);
        statusText = '사용 가능';
        break;
      case 'USED':
        statusColor = AppColors.info;
        cardBorderColor = AppColors.info.withOpacity(0.3);
        statusText = '사용 완료';
        break;
      case 'EXPIRED':
        statusColor = AppColors.error;
        cardBorderColor = AppColors.error.withOpacity(0.3);
        statusText = '만료됨';
        break;
      default:
        statusColor = AppColors.inactive;
        cardBorderColor = AppColors.inactive.withOpacity(0.3);
        statusText = status;
    }

    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: cardBorderColor, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 쿠폰 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      coupon['couponName'],
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.md),
              
              // 할인 정보
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Text(
                  coupon['discountValue'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.md),
              
              // 날짜 정보
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '발급일',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _formatDate(coupon['issuedDate']),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '유효기간',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _formatDate(coupon['validTo']),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: DateTime.now().isAfter(coupon['validTo']) 
                              ? AppColors.error 
                              : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // 사용 정보 (사용된 쿠폰만)
              if (status == 'USED') ...[
                SizedBox(height: AppSizes.md),
                Container(
                  padding: EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(color: AppColors.info.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(MdiIcons.checkCircle, size: 16.sp, color: AppColors.info),
                      SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '사용일: ${_formatDate(coupon['usedDate'])}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.info,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '주문금액: ${_formatNumber(coupon['orderAmount'])}원',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCouponDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('쿠폰 생성 기능은 준비 중입니다.'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showCouponDetail(Map<String, dynamic> coupon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${coupon['name']} 상세 보기'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _editCoupon(Map<String, dynamic> coupon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${coupon['name']} 수정 기능은 준비 중입니다.'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _deleteCoupon(Map<String, dynamic> coupon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('쿠폰 삭제'),
        content: Text('${coupon['name']} 쿠폰을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _coupons.removeWhere((c) => c['id'] == coupon['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${coupon['name']} 쿠폰이 삭제되었습니다.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
