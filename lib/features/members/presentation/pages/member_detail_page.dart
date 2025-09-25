import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/member_model.dart';

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

}
