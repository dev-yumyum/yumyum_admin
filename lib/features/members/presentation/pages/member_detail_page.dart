import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/member_model.dart';
import '../../data/models/customer_address_model.dart';
import '../../data/models/customer_modification_history_model.dart';

class MemberDetailPage extends StatefulWidget {
  final String? memberId;
  
  const MemberDetailPage({super.key, this.memberId});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  MemberModel? _member;
  bool _isLoading = true;
  
  // 포인트 관련 데이터
  int _currentPoints = 2450;
  int _totalEarned = 15670;
  int _totalUsed = 13220;

  // 주소록 데이터 (최대 5개)
  List<CustomerAddressModel> _addressBook = [];

  // 정보 수정 기록 데이터
  List<CustomerModificationHistoryModel> _modificationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMemberData();
  }

  Future<void> _loadMemberData() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final sampleMembers = _getSampleMembers();
    final member = sampleMembers.firstWhere(
      (m) => m.id == widget.memberId,
      orElse: () => sampleMembers.first,
    );

    if (mounted) {
      setState(() {
        _member = member;
        _addressBook = _getSampleAddressBook(member.id);
        _modificationHistory = _getSampleModificationHistory(member.id);
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.member,
      child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: AppSizes.lg),
                  _buildProfileHeader(),
                  SizedBox(height: AppSizes.lg),
                  _buildBasicInfoSection(),
                  SizedBox(height: AppSizes.lg),
                  _buildJoinInfoSection(),
                  SizedBox(height: AppSizes.lg),
                  _buildPointSection(),
                  SizedBox(height: AppSizes.lg),
                  _buildAddressBookSection(),
                  SizedBox(height: AppSizes.lg),
                  _buildModificationHistorySection(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            MdiIcons.arrowLeft,
            size: 24.r,
            color: AppColors.textPrimary,
          ),
          tooltip: '뒤로가기',
        ),
        SizedBox(width: AppSizes.sm),
        Text(
          '고객 상세',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Text(
        '활성 회원',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.success,
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (_member == null) return const SizedBox.shrink();

    return Row(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundColor: AppColors.primary,
          child: Text(
            _member!.memberName?.substring(0, 1) ?? '김',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _member!.memberName ?? '김민수',
                style: TextStyle(
                  fontSize: 32.sp, // 28.sp -> 32.sp (프로필 이름 가독성 개선)
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                _member!.memberId,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildStatCards(),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _buildStatCard('47', '총 주문'),
        SizedBox(width: AppSizes.lg),
        _buildStatCard('342,500원', '누적 결제'),
        SizedBox(width: AppSizes.lg),
        _buildStatCard('2,450P', '보유 포인트'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28.sp, // 24.sp -> 28.sp (통계 값 가독성 개선)
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 18.sp, // 12.sp -> 18.sp (가독성 개선)
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    if (_member == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기본 정보',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard('고유번호:', _member!.memberId),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildInfoCard('연락처:', _member!.phone ?? '010-1234-5678'),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildInfoCard('이메일:', _member!.email ?? 'minsu.kim@example.com'),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildInfoCard('아이디:', 'minsu_kim2024'),
            ),
          ],
        ),
        SizedBox(height: AppSizes.md),
        _buildPasswordRow(),
      ],
    );
  }

  Widget _buildJoinInfoSection() {
    if (_member == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '가입 정보',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard('가입일:', '2024년 9월 1일 (14일 전)'),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildInfoCardWithChip('가입형식:', '카카오톡', Colors.yellow),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildInfoCardWithChip('마케팅 수신동의:', '동의', AppColors.success),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildInfoCard('최근 접속:', '2024년 9월 14일 18:32'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPointSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '포인트 현황',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        Row(
          children: [
            Expanded(
              child: _buildPointCard('보유 포인트', _currentPoints, AppColors.textPrimary),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildPointCard('누적 적립', _totalEarned, AppColors.success),
            ),
            SizedBox(width: AppSizes.lg),
            Expanded(
              child: _buildPointCard('누적 사용', _totalUsed, AppColors.error),
            ),
          ],
        ),
        SizedBox(height: AppSizes.lg),
        _buildPointHistory(),
      ],
    );
  }


  Widget _buildInfoCard(String label, String value) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18.sp, // 12.sp -> 18.sp (가독성 개선)
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp, // 14.sp -> 18.sp (가독성 개선)
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCardWithChip(String label, String value, Color chipColor) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18.sp, // 12.sp -> 18.sp (가독성 개선)
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: chipColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp, // 12.sp -> 18.sp (가독성 개선)
                  fontWeight: FontWeight.w600,
                  color: value == '카카오톡' ? Colors.black : chipColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '패스워드:',
                  style: TextStyle(
                    fontSize: 18.sp, // 12.sp -> 18.sp (가독성 개선)
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  '••••••••••••',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // 패스워드 초기화 로직
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('패스워드 초기화 기능 구현 예정')),
                );
              },
              child: const Text('초기화'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointCard(String title, int points, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              '${_formatCurrency(points.toString())}P',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointHistory() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최근 포인트 내역',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            _buildPointHistoryItem('주문 완료 적립', '2024.09.14', '+250P', AppColors.success),
            _buildPointHistoryItem('결제 시 사용', '2024.09.12', '-1,500P', AppColors.error),
            _buildPointHistoryItem('주문 완료 적립', '2024.09.10', '+180P', AppColors.success),
          ],
        ),
      ),
    );
  }

  Widget _buildPointHistoryItem(String title, String date, String amount, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp, // 14.sp -> 18.sp (가독성 개선)
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 18.sp, // 12.sp -> 18.sp (가독성 개선)
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }



  String _formatCurrency(String value) {
    final num = int.tryParse(value) ?? 0;
    return num.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  List<MemberModel> _getSampleMembers() {
    return [
      MemberModel(
        id: '1',
        memberId: 'M202409010001',
        memberName: '김민수',
        email: 'minsu.kim@example.com',
        phone: '010-1234-5678',
        nickname: 'minsu_kim2024',
        registrationDate: '2024.09.01',
        lastLoginDate: '2024.09.14',
        status: 'ACTIVE',
        grade: 'VIP',
        totalOrders: 47,
        totalAmount: '342500',
        pointBalance: 2450,
        address: '서울특별시 강남구 역삼동 123-45',
        favoriteCategory: 'KOREAN',
        registrationType: '카카오톡',
      ),
      MemberModel(
        id: '2',
        memberId: 'M202408280002',
        memberName: '이서연',
        email: 'seoyeon.lee@gmail.com',
        phone: '010-9876-5432',
        registrationDate: '2024.08.28',
        lastLoginDate: '2024.09.13',
        status: 'ACTIVE',
        grade: 'GOLD',
        totalOrders: 23,
        totalAmount: '450000',
        pointBalance: 7800,
        registrationType: '이메일',
      ),
      MemberModel(
        id: '3',
        memberId: 'M202408200003',
        memberName: '박준호',
        email: 'junho.park@icloud.com',
        phone: '010-5555-7777',
        registrationDate: '2024.08.20',
        lastLoginDate: '2024.09.05',
        status: 'INACTIVE',
        grade: 'SILVER',
        totalOrders: 12,
        totalAmount: '180000',
        registrationType: '애플',
      ),
    ];
  }

  // 샘플 주소록 데이터 생성 (최대 5개)
  List<CustomerAddressModel> _getSampleAddressBook(String memberId) {
    return [
      CustomerAddressModel(
        id: 'addr_001',
        addressName: '집',
        fullAddress: '서울특별시 강남구 테헤란로 427',
        detailAddress: '위워크타워 15층',
        postalCode: '06158',
        latitude: 37.5066,
        longitude: 127.0536,
        isDefault: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        deliveryInstructions: '경비실에 맡겨주세요',
      ),
      CustomerAddressModel(
        id: 'addr_002',
        addressName: '회사',
        fullAddress: '서울특별시 서초구 서초대로 396',
        detailAddress: '강남빌딩 12층',
        postalCode: '06621',
        latitude: 37.4969,
        longitude: 127.0298,
        isDefault: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 20)),
        deliveryInstructions: '부재시 문앞에 놓아주세요',
      ),
      CustomerAddressModel(
        id: 'addr_003',
        addressName: '부모님댁',
        fullAddress: '경기도 성남시 분당구 판교역로 235',
        detailAddress: '에이치스퀘어 N동 2301호',
        postalCode: '13494',
        latitude: 37.3954,
        longitude: 127.1114,
        isDefault: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
        deliveryInstructions: '초인종 눌러주세요',
      ),
    ];
  }

  // 샘플 정보 수정 기록 데이터 생성
  List<CustomerModificationHistoryModel> _getSampleModificationHistory(String memberId) {
    return [
      CustomerModificationHistoryModel(
        id: 'hist_001',
        memberId: memberId,
        fieldName: 'phone',
        fieldDisplayName: '연락처',
        valueBefore: '010-1234-5678',
        valueAfter: '010-9876-5432',
        modifiedAt: DateTime.now().subtract(const Duration(days: 3)),
        modifiedBy: 'CUSTOMER',
        ipAddress: '192.168.1.100',
      ),
      CustomerModificationHistoryModel(
        id: 'hist_002',
        memberId: memberId,
        fieldName: 'email',
        fieldDisplayName: '이메일',
        valueBefore: 'old@example.com',
        valueAfter: 'new@example.com',
        modifiedAt: DateTime.now().subtract(const Duration(days: 7)),
        modifiedBy: 'CUSTOMER',
        ipAddress: '192.168.1.100',
      ),
      CustomerModificationHistoryModel(
        id: 'hist_003',
        memberId: memberId,
        fieldName: 'memberName',
        fieldDisplayName: '회원명',
        valueBefore: '김철수',
        valueAfter: '김철민',
        modifiedAt: DateTime.now().subtract(const Duration(days: 10)),
        modifiedBy: 'ADMIN',
        adminId: 'admin_001',
        reason: '고객 요청으로 인한 정정',
        ipAddress: '10.0.0.1',
      ),
      CustomerModificationHistoryModel(
        id: 'hist_004',
        memberId: memberId,
        fieldName: 'address',
        fieldDisplayName: '기본 배송지',
        valueBefore: '서울시 강남구 역삼동 123-45',
        valueAfter: '서울시 강남구 테헤란로 427',
        modifiedAt: DateTime.now().subtract(const Duration(days: 12)),
        modifiedBy: 'CUSTOMER',
        ipAddress: '192.168.1.100',
      ),
      CustomerModificationHistoryModel(
        id: 'hist_005',
        memberId: memberId,
        fieldName: 'nickname',
        fieldDisplayName: '닉네임',
        valueBefore: '맛집탐방러',
        valueAfter: '미식가철수',
        modifiedAt: DateTime.now().subtract(const Duration(days: 18)),
        modifiedBy: 'CUSTOMER',
        ipAddress: '192.168.1.100',
      ),
    ];
  }

  // 주소록 섹션
  Widget _buildAddressBookSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.mapMarker,
                  color: AppColors.primary,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '배송지 주소록',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_addressBook.length}/5',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            
            if (_addressBook.isEmpty) 
              _buildEmptyAddressState()
            else 
              ..._addressBook.map((address) => _buildAddressCard(address)),
          ],
        ),
      ),
    );
  }

  // 빈 주소록 상태
  Widget _buildEmptyAddressState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            MdiIcons.mapMarkerOff,
            size: 48.r,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: AppSizes.md),
          Text(
            '등록된 배송지가 없습니다',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            '고객이 앱에서 배송지를 등록하면 여기에 표시됩니다',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // 주소 카드
  Widget _buildAddressCard(CustomerAddressModel address) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: address.isDefault ? AppColors.primary : AppColors.border,
          width: address.isDefault ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        color: address.isDefault ? AppColors.primary.withOpacity(0.05) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: address.isDefault ? AppColors.primary : AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  address.addressName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (address.isDefault) ...[
                SizedBox(width: AppSizes.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '기본배송지',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              Spacer(),
              Text(
                '등록: ${address.createdAt.year}.${address.createdAt.month.toString().padLeft(2, '0')}.${address.createdAt.day.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            address.fullAddress,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          if (address.detailAddress.isNotEmpty) ...[
            SizedBox(height: AppSizes.xs),
            Text(
              address.detailAddress,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (address.deliveryInstructions != null && address.deliveryInstructions!.isNotEmpty) ...[
            SizedBox(height: AppSizes.sm),
            Container(
              padding: EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    MdiIcons.messageText,
                    size: AppSizes.iconSm,
                    color: AppColors.info,
                  ),
                  SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Text(
                      address.deliveryInstructions!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 정보 수정 기록 섹션
  Widget _buildModificationHistorySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.history,
                  color: AppColors.warning,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '정보 수정 기록',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '총 ${_modificationHistory.length}건',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            
            if (_modificationHistory.isEmpty) 
              _buildEmptyHistoryState()
            else 
              ..._modificationHistory.take(10).map((history) => _buildHistoryCard(history)),
          ],
        ),
      ),
    );
  }

  // 빈 수정 기록 상태
  Widget _buildEmptyHistoryState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            MdiIcons.clockOutline,
            size: 48.r,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: AppSizes.md),
          Text(
            '정보 수정 기록이 없습니다',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            '고객의 정보 변경 시 기록이 표시됩니다',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // 수정 기록 카드
  Widget _buildHistoryCard(CustomerModificationHistoryModel history) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: history.isCustomerModified ? AppColors.info : AppColors.warning,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  history.isCustomerModified ? '고객 수정' : '관리자 수정',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                history.fieldDisplayName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Spacer(),
              Text(
                '${history.modifiedAt.year}.${history.modifiedAt.month.toString().padLeft(2, '0')}.${history.modifiedAt.day.toString().padLeft(2, '0')} ${history.modifiedAt.hour.toString().padLeft(2, '0')}:${history.modifiedAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          
          // 변경 전후 내용
          Container(
            padding: EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      MdiIcons.arrowLeft,
                      size: AppSizes.iconSm,
                      color: AppColors.error,
                    ),
                    SizedBox(width: AppSizes.xs),
                    Text(
                      '변경 전:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(width: AppSizes.xs),
                    Expanded(
                      child: Text(
                        history.valueBefore ?? '없음',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    Icon(
                      MdiIcons.arrowRight,
                      size: AppSizes.iconSm,
                      color: AppColors.success,
                    ),
                    SizedBox(width: AppSizes.xs),
                    Text(
                      '변경 후:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.success,
                      ),
                    ),
                    SizedBox(width: AppSizes.xs),
                    Expanded(
                      child: Text(
                        history.valueAfter ?? '없음',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 관리자 수정 시 추가 정보
          if (history.isAdminModified && history.reason != null) ...[
            SizedBox(height: AppSizes.sm),
            Container(
              padding: EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    MdiIcons.accountTie,
                    size: AppSizes.iconSm,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: AppSizes.xs),
                  Text(
                    '관리자 수정 사유:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.warning,
                    ),
                  ),
                  SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Text(
                      history.reason!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

}
