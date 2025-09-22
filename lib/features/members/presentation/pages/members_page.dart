import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/member_model.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'ALL';
  int _currentPage = 1;
  int _itemsPerPage = 25;
  List<MemberModel> _allMembers = [];
  List<MemberModel> _filteredMembers = [];
  
  // 통계 데이터
  int _totalCount = 1247;
  int _activeCount = 1108;
  int _inactiveCount = 127;
  int _bannedCount = 12;

  @override
  void initState() {
    super.initState();
    _allMembers = _getSampleMembers();
    _filteredMembers = _allMembers;
    _searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers() {
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        bool matchesSearch = true;
        bool matchesStatus = true;

        // 검색어 필터
        if (_searchController.text.isNotEmpty) {
          final searchTerm = _searchController.text.toLowerCase();
          matchesSearch = (member.memberName?.toLowerCase().contains(searchTerm) ?? false) ||
                         (member.phone?.toLowerCase().contains(searchTerm) ?? false);
        }

        // 상태 필터
        if (_selectedStatus != 'ALL') {
          matchesStatus = member.status == _selectedStatus;
        }

        return matchesSearch && matchesStatus;
      }).toList();
      
      _currentPage = 1; // 필터링 시 첫 페이지로 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.member,
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
              _buildSearchAndFilters(),
              SizedBox(height: AppSizes.md),
              Expanded(
                child: _buildMemberTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      '고객관리',
      style: TextStyle(
        fontSize: 36.sp, // 28.sp -> 36.sp (헤더 통일화)
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '전체',
            _totalCount,
            '전체 회원',
            AppColors.primary,
            MdiIcons.accountGroup,
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '활성',
            _activeCount,
            '활성 회원',
            AppColors.success,
            MdiIcons.accountCheck,
            backgroundColor: const Color(0xFFE7F5E7),
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '비활성',
            _inactiveCount,
            '비활성 회원',
            AppColors.warning,
            MdiIcons.accountMinus,
            backgroundColor: const Color(0xFFFFF8E1),
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '차단',
            _bannedCount,
            '차단 회원',
            AppColors.error,
            MdiIcons.accountCancel,
            backgroundColor: const Color(0xFFFFEBEE),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, String subtitle, Color color, IconData icon, {Color? backgroundColor}) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  child: Icon(icon, size: AppSizes.iconMd, color: color),
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Text(
              count.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              ),
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
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

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '회원명, 연락처',
              prefixIcon: Icon(MdiIcons.magnify),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              suffixIcon: Container(
                margin: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed: _filterMembers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  child: Text(
                    '검색',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.lg),
        DropdownButton<String>(
          value: _selectedStatus,
          items: const [
            DropdownMenuItem(value: 'ALL', child: Text('전체 회원')),
            DropdownMenuItem(value: 'ACTIVE', child: Text('활성')),
            DropdownMenuItem(value: 'INACTIVE', child: Text('비활성')),
            DropdownMenuItem(value: 'BANNED', child: Text('차단')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedStatus = value!;
              _filterMembers();
            });
          },
        ),
      ],
    );
  }

  Widget _buildMemberTable() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final currentPageMembers = _filteredMembers.skip(startIndex).take(_itemsPerPage).toList();
    
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
                  '회원 목록',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                DropdownButton<int>(
                  value: _itemsPerPage,
                  items: const [
                    DropdownMenuItem(value: 25, child: Text('25개씩 보기')),
                    DropdownMenuItem(value: 50, child: Text('50개씩 보기')),
                    DropdownMenuItem(value: 100, child: Text('100개씩 보기')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _itemsPerPage = value!;
                      _currentPage = 1;
                    });
                  },
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
                        '고유번호',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '회원명',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '연락처',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '이메일',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '가입일',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '상태',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '가입형식',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '최근접속',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp, // 18.sp -> 22.sp (테이블 헤더 통일화)
                        ),
                      ),
                    ),
                  ],
                  rows: currentPageMembers.map((member) => _buildDataRow(member)).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.md),
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(MemberModel member) {
    return DataRow(
      onSelectChanged: (_) {
        context.go('${RouteNames.memberDetail}?id=${member.id}');
      },
      cells: [
        DataCell(
          Text(
            member.memberId,
            style: TextStyle(fontSize: 20.sp), // 12.sp -> 20.sp (데이터 행 통일화)
          ),
        ),
        DataCell(
          Text(
            member.memberName ?? '-',
            style: TextStyle(fontSize: 20.sp), // 12.sp -> 20.sp (데이터 행 통일화)
          ),
        ),
        DataCell(
          Text(
            member.phone ?? '-',
            style: TextStyle(fontSize: 20.sp), // 12.sp -> 20.sp (데이터 행 통일화)
          ),
        ),
        DataCell(
          Text(
            member.email ?? '-',
            style: TextStyle(fontSize: 20.sp), // 12.sp -> 20.sp (데이터 행 통일화)
          ),
        ),
        DataCell(
          Text(
            member.registrationDate,
            style: TextStyle(fontSize: 20.sp), // 12.sp -> 20.sp (데이터 행 통일화)
          ),
        ),
        DataCell(_buildStatusChip(member.status)),
        DataCell(_buildRegistrationTypeChip(member.registrationType)),
        DataCell(
          Text(
            member.lastLoginDate ?? '-',
            style: TextStyle(fontSize: 20.sp), // 12.sp -> 20.sp (데이터 행 통일화)
          ),
        ),
      ],
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
      case 'INACTIVE':
        chipColor = AppColors.warning;
        statusText = '비활성';
        break;
      case 'BANNED':
        chipColor = AppColors.error;
        statusText = '차단';
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
          fontSize: 16.sp, // 10.sp -> 16.sp (칩 텍스트 가독성 개선)
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildRegistrationTypeChip(String? registrationType) {
    if (registrationType == null) return Text('-', style: TextStyle(fontSize: 12.sp));
    
    Color chipColor;
    String typeText;
    
    switch (registrationType) {
      case '카카오톡':
        chipColor = const Color(0xFFFFE500);
        typeText = '카카오톡';
        break;
      case '이메일':
        chipColor = AppColors.info;
        typeText = '이메일';
        break;
      case '애플':
        chipColor = AppColors.textPrimary;
        typeText = '애플';
        break;
      default:
        chipColor = AppColors.inactive;
        typeText = registrationType;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Text(
        typeText,
        style: TextStyle(
          fontSize: 16.sp, // 10.sp -> 16.sp (칩 텍스트 가독성 개선)
          fontWeight: FontWeight.w600,
          color: registrationType == '카카오톡' ? Colors.black : chipColor,
        ),
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_filteredMembers.length / _itemsPerPage).ceil();
    final startItem = (_currentPage - 1) * _itemsPerPage + 1;
    final endItem = (_currentPage * _itemsPerPage).clamp(0, _filteredMembers.length);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '총 ${_filteredMembers.length}명 중 $startItem-${endItem}명 표시',
          style: TextStyle(
                      fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _currentPage > 1 ? () {
                setState(() {
                  _currentPage--;
                });
              } : null,
              icon: Icon(MdiIcons.chevronLeft),
            ),
            ...List.generate(
              totalPages.clamp(0, 10),
              (index) {
                final pageNumber = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPage = pageNumber;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: _currentPage == pageNumber ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      pageNumber.toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: _currentPage == pageNumber ? Colors.white : AppColors.textPrimary,
                        fontWeight: _currentPage == pageNumber ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (totalPages > 10) ...[
              Text('...'),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = totalPages;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    totalPages.toString(),
                    style: TextStyle(fontSize: 20.sp), // 12.sp -> 20.sp (데이터 행 통일화)
                  ),
                ),
              ),
            ],
            IconButton(
              onPressed: _currentPage < totalPages ? () {
                setState(() {
                  _currentPage++;
                });
              } : null,
              icon: Icon(MdiIcons.chevronRight),
            ),
          ],
        ),
      ],
    );
  }

  List<MemberModel> _getSampleMembers() {
    return [
      MemberModel(
        id: '1',
        memberId: 'M202409010001',
        memberName: '김민수',
        phone: '010-1234-5678',
        email: 'minsu.kim@example.com',
        registrationDate: '2024.09.01',
        status: 'ACTIVE',
        registrationType: '카카오톡',
        lastLoginDate: '2024.09.14',
      ),
      MemberModel(
        id: '2',
        memberId: 'M202408280002',
        memberName: '이서연',
        phone: '010-9876-5432',
        email: 'seoyeon.lee@gmail.com',
        registrationDate: '2024.08.28',
        status: 'ACTIVE',
        registrationType: '이메일',
        lastLoginDate: '2024.09.13',
      ),
      MemberModel(
        id: '3',
        memberId: 'M202408200003',
        memberName: '박준호',
        phone: '010-5555-7777',
        email: 'junho.park@icloud.com',
        registrationDate: '2024.08.20',
        status: 'INACTIVE',
        registrationType: '애플',
        lastLoginDate: '2024.09.05',
      ),
      MemberModel(
        id: '4',
        memberId: 'M202408150004',
        memberName: '최영희',
        phone: '010-3333-9999',
        email: 'younghee.choi@naver.com',
        registrationDate: '2024.08.15',
        status: 'ACTIVE',
        registrationType: '카카오톡',
        lastLoginDate: '2024.09.14',
      ),
      MemberModel(
        id: '5',
        memberId: 'M202408100005',
        memberName: '정민석',
        phone: '010-7777-1111',
        email: 'minseok.jung@example.com',
        registrationDate: '2024.08.10',
        status: 'BANNED',
        registrationType: '이메일',
        lastLoginDate: '2024.08.25',
      ),
      MemberModel(
        id: '6',
        memberId: 'M202408050006',
        memberName: '한지영',
        phone: '010-2222-4444',
        email: 'jiyoung.han@gmail.com',
        registrationDate: '2024.08.05',
        status: 'ACTIVE',
        registrationType: '애플',
        lastLoginDate: '2024.09.12',
      ),
      MemberModel(
        id: '7',
        memberId: 'M202407250007',
        memberName: '송민재',
        phone: '010-8888-5555',
        email: 'minjae.song@example.com',
        registrationDate: '2024.07.25',
        status: 'ACTIVE',
        registrationType: '카카오톡',
        lastLoginDate: '2024.09.13',
      ),
      MemberModel(
        id: '8',
        memberId: 'M202407200008',
        memberName: '김수진',
        phone: '010-4444-6666',
        email: 'sujin.kim@gmail.com',
        registrationDate: '2024.07.20',
        status: 'INACTIVE',
        registrationType: '이메일',
        lastLoginDate: '2024.08.30',
      ),
      MemberModel(
        id: '9',
        memberId: 'M202407150009',
        memberName: '안진우',
        phone: '010-9999-3333',
        email: 'jinwoo.an@icloud.com',
        registrationDate: '2024.07.15',
        status: 'ACTIVE',
        registrationType: '애플',
        lastLoginDate: '2024.09.14',
      ),
      MemberModel(
        id: '10',
        memberId: 'M202407100010',
        memberName: '윤하늘',
        phone: '010-1111-7777',
        email: 'haneul.yoon@example.com',
        registrationDate: '2024.07.10',
        status: 'ACTIVE',
        registrationType: '카카오톡',
        lastLoginDate: '2024.09.12',
      ),
      // 추가 회원들 (총 30명 정도로 페이지네이션 테스트)
      ...List.generate(20, (index) {
        final memberId = 'M20240${(700 + index).toString().padLeft(2, '0')}${(index + 11).toString().padLeft(4, '0')}';
        final names = ['이동현', '박소영', '최민호', '신예진', '강태현', '임수연', '오민규', '홍지은', '백현우', '서아름',
                      '조성민', '노하영', '유준석', '문지혜', '장도윤', '남상미', '심재혁', '배은지', '권민수', '전유리'];
        final statuses = ['ACTIVE', 'ACTIVE', 'INACTIVE', 'ACTIVE', 'BANNED'];
        final types = ['카카오톡', '이메일', '애플'];
        
        return MemberModel(
          id: (index + 11).toString(),
          memberId: memberId,
          memberName: names[index % names.length],
          phone: '010-${(1000 + index).toString()}-${(2000 + index).toString()}',
          email: '${names[index % names.length].toLowerCase()}@example.com',
          registrationDate: '2024.07.${(5 + index % 25).toString().padLeft(2, '0')}',
          status: statuses[index % statuses.length],
          registrationType: types[index % types.length],
          lastLoginDate: '2024.09.${(1 + index % 14).toString().padLeft(2, '0')}',
        );
      }),
    ];
  }
}
