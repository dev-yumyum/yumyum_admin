import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/business_model.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.business,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            _buildFilters(),
            SizedBox(height: AppSizes.lg),
            Expanded(
              child: _buildBusinessList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '사업자 관리',
              style: TextStyle(
                fontSize: 36.sp, // 28.sp -> 36.sp (가독성 개선)
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              '등록된 사업자를 관리하고 승인 상태를 확인할 수 있습니다.',
              style: TextStyle(
                fontSize: 20.sp, // 16.sp -> 20.sp (가독성 개선)
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            context.go(RouteNames.businessRegister);
          },
          icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
          label: const Text('사업자 등록'),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: '검색',
                  hintText: '사업자명, 사업자번호, 대표자명으로 검색',
                  prefixIcon: Icon(MdiIcons.magnify),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchText = '';
                            });
                          },
                          icon: Icon(MdiIcons.close),
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
            SizedBox(width: AppSizes.md),
            IconButton(
              onPressed: () {
                // TODO: 데이터 새로고침
              },
              icon: Icon(MdiIcons.refresh),
              tooltip: '새로고침',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessList() {
    final businesses = _getSampleBusinesses();
    final filteredBusinesses = businesses.where((business) {
      if (_searchText.isEmpty) return true;
      return business.businessName
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          business.businessNumber
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          business.ownerName
              .toLowerCase()
              .contains(_searchText.toLowerCase());
    }).toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '사업자 목록 (${filteredBusinesses.length}개)',
              style: TextStyle(
                fontSize: 24.sp, // 18.sp -> 24.sp (가독성 개선)
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 64,
                  ),
                  child: SingleChildScrollView(
                    child: _buildBusinessTable(filteredBusinesses),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessTable(List<BusinessModel> businesses) {
    return DataTable(
      showCheckboxColumn: false, // 체크박스 제거
      headingRowHeight: 60.h,
      dataRowHeight: 80.h,
      columnSpacing: 40.w,
      horizontalMargin: 20.w,
      headingTextStyle: TextStyle(
        fontSize: 22.sp, // 가독성 개선
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      dataTextStyle: TextStyle(
        fontSize: 20.sp, // 가독성 개선
        color: AppColors.textPrimary,
      ),
      columns: [
        DataColumn(
          label: Text('사업자명'),
        ),
        DataColumn(
          label: Text('사업자번호'),
        ),
        DataColumn(
          label: Text('대표자'),
        ),
        DataColumn(
          label: Text('소재지'),
        ),
        DataColumn(
          label: Text('등록일'),
        ),
      ],
      rows: businesses.map((business) => _buildDataRow(business)).toList(),
    );
  }

  DataRow _buildDataRow(BusinessModel business) {
    return DataRow(
      onSelectChanged: (selected) {
        if (selected == true) {
          context.go('${RouteNames.businessDetail}?id=${business.id}');
        }
      },
      cells: [
        DataCell(
          Container(
            width: 200.w,
            child: Text(
              business.businessName,
              style: TextStyle(
                fontSize: 20.sp, // 가독성 개선
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Container(
            width: 180.w,
            child: Text(
              business.businessNumber,
              style: TextStyle(
                fontSize: 20.sp, // 가독성 개선
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: 120.w,
            child: Text(
              business.ownerName,
              style: TextStyle(
                fontSize: 20.sp, // 가독성 개선
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Container(
            width: 300.w,
            child: Text(
              business.businessLocation ?? '-',
              style: TextStyle(
                fontSize: 20.sp, // 가독성 개선
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        DataCell(
          Container(
            width: 120.w,
            child: Text(
              business.registrationDate,
              style: TextStyle(
                fontSize: 20.sp, // 가독성 개선
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BusinessModel> _getSampleBusinesses() {
    return [
      BusinessModel(
        id: '1',
        businessName: '㈜맛있는집',
        businessNumber: '123-45-67890',
        businessType: 'CORPORATION',
        ownerName: '김맛있',
        businessLocation: '서울특별시 강남구 역삼동 123-45',
        businessLocationDetail: '○○빌딩 3층',
        businessAddress: '서울특별시 강남구 역삼동 123-45',
        businessAddressDetail: '○○빌딩 3층',
        businessCategory: '음식점업',
        businessItem: '한식음식점업',
        ownerPhone: '010-1234-5678',
        ownerEmail: 'kim@delicious.com',
        registrationDate: '2024-08-15',
        status: 'APPROVED',
        businessLicenseFileName: '맛있는집_사업자등록증.jpg',
        bankName: '국민은행',
        accountNumber: '12345678901234',
        accountHolder: '주식회사맛있는집',
        accountVerified: true,
      ),
      BusinessModel(
        id: '2',
        businessName: '치킨왕 프랜차이즈',
        businessNumber: '234-56-78901',
        businessType: 'CORPORATION',
        ownerName: '박치킨',
        businessLocation: '서울특별시 홍대구 홍익동 456-78',
        businessLocationDetail: '△△타워 2층',
        businessAddress: '서울특별시 홍대구 홍익동 456-78',
        businessAddressDetail: '△△타워 2층',
        businessCategory: '음식점업',
        businessItem: '치킨전문점',
        ownerPhone: '010-2345-6789',
        ownerEmail: 'park@chicken.com',
        registrationDate: '2024-08-20',
        status: 'PENDING',
        businessLicenseFileName: '치킨왕_사업자등록증.png',
        bankName: '신한은행',
        accountNumber: '98765432109876',
        accountHolder: '박치킨',
        accountVerified: false,
      ),
      BusinessModel(
        id: '3',
        businessName: '피자마을',
        businessNumber: '345-67-89012',
        businessType: 'INDIVIDUAL',
        ownerName: '이피자',
        businessLocation: '서울특별시 신촌구 신촌동 789-12',
        businessLocationDetail: '□□플라자 1층',
        businessAddress: '서울특별시 신촌구 신촌동 789-12',
        businessAddressDetail: '□□플라자 1층',
        businessCategory: '음식점업',
        businessItem: '피자전문점',
        ownerPhone: '010-3456-7890',
        ownerEmail: 'lee@pizza.com',
        registrationDate: '2024-09-01',
        status: 'APPROVED',
        bankName: '우리은행',
        accountNumber: '11111222223333',
        accountHolder: '이피자',
        accountVerified: false,
      ),
    ];
  }
}
