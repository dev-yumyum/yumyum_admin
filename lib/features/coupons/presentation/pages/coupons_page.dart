import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../shared/widgets/responsive_text.dart';
import '../../../members/data/models/member_model.dart';
import '../../data/models/customer_coupon_model.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final _searchController = TextEditingController();
  String _selectedSearchType = '고객명';
  List<CustomerCouponModel> _customers = [];
  List<CustomerCouponModel> _filteredCustomers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDummyData() {
    // 더미 데이터 생성
    _customers = [
      CustomerCouponModel(
        id: '1',
        customerId: 'cust001',
        customerName: '김철수',
        customerPhone: '010-1234-5678',
        customerEmail: 'kim@example.com',
        coupons: [
          CouponModel(
            id: 'coupon001',
            name: '웰컴쿠폰',
            discountAmount: 3000,
            issueDate: '2024-01-15',
            isUsed: false,
            type: CouponType.welcome,
          ),
          CouponModel(
            id: 'coupon002',
            name: '웰컴쿠폰',
            discountAmount: 3000,
            issueDate: '2024-01-15',
            isUsed: true,
            useDate: '2024-01-20',
            type: CouponType.welcome,
          ),
          CouponModel(
            id: 'coupon003',
            name: '웰컴쿠폰',
            discountAmount: 3000,
            issueDate: '2024-01-15',
            isUsed: false,
            type: CouponType.welcome,
          ),
        ],
      ),
      CustomerCouponModel(
        id: '2',
        customerId: 'cust002',
        customerName: '이영희',
        customerPhone: '010-5678-9012',
        customerEmail: 'lee@example.com',
        coupons: [
          CouponModel(
            id: 'coupon004',
            name: '친구초대쿠폰',
            discountAmount: 5000,
            issueDate: '2024-02-01',
            isUsed: false,
            type: CouponType.referral,
          ),
        ],
      ),
      CustomerCouponModel(
        id: '3',
        customerId: 'cust003',
        customerName: '박민수',
        customerPhone: '010-3456-7890',
        customerEmail: 'park@example.com',
        coupons: [],
      ),
      CustomerCouponModel(
        id: '4',
        customerId: 'cust004',
        customerName: '최지은',
        customerPhone: '010-9876-5432',
        customerEmail: 'choi@example.com',
        coupons: [
          CouponModel(
            id: 'coupon005',
            name: '웰컴쿠폰',
            discountAmount: 3000,
            issueDate: '2024-03-10',
            isUsed: false,
            type: CouponType.welcome,
          ),
          CouponModel(
            id: 'coupon006',
            name: '친구초대쿠폰',
            discountAmount: 5000,
            issueDate: '2024-03-15',
            isUsed: true,
            useDate: '2024-03-20',
            type: CouponType.referral,
          ),
        ],
      ),
    ];
    _filteredCustomers = _customers;
  }

  void _performSearch() {
    final query = _searchController.text.trim().toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _filteredCustomers = _customers;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredCustomers = _customers.where((customer) {
        switch (_selectedSearchType) {
          case '고객명':
            return customer.customerName.toLowerCase().contains(query);
          case '연락처':
            return customer.customerPhone.replaceAll('-', '').contains(query.replaceAll('-', ''));
          case '이메일':
            return customer.customerEmail.toLowerCase().contains(query);
          default:
            return false;
        }
      }).toList();
    });
  }

  void _showCustomerDetail(CustomerCouponModel customer) {
    showDialog(
      context: context,
      builder: (context) => CustomerCouponDetailDialog(customer: customer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: '/coupons',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 페이지 헤더
          Row(
            children: [
              Icon(
                MdiIcons.ticket,
                size: AppSizes.iconLg,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSizes.sm),
              ResponsiveText(
                '쿠폰 관리',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.lg),

          // 검색 영역
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '고객 검색',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.md),
                  Row(
                    children: [
                      // 검색 타입 선택
                      Container(
                        width: 150.w,
                        child: DropdownButtonFormField<String>(
                          value: _selectedSearchType,
                          decoration: InputDecoration(
                            labelText: '검색 유형',
                            border: OutlineInputBorder(),
                          ),
                          items: ['고객명', '연락처', '이메일'].map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSearchType = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: AppSizes.md),
                      
                      // 검색 입력
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: '검색어를 입력하세요',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(MdiIcons.magnify),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(MdiIcons.close),
                                    onPressed: () {
                                      _searchController.clear();
                                      _performSearch();
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) => _performSearch(),
                          onFieldSubmitted: (value) => _performSearch(),
                        ),
                      ),
                      SizedBox(width: AppSizes.md),
                      
                      // 검색 버튼
                      ElevatedButton.icon(
                        onPressed: _performSearch,
                        icon: Icon(MdiIcons.magnify),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.lg),

          // 검색 결과
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '검색 결과',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: AppSizes.sm),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_filteredCustomers.length}명',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.md),
                    
                    if (_filteredCustomers.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.accountSearch,
                                size: 64.sp,
                                color: AppColors.textTertiary,
                              ),
                              SizedBox(height: AppSizes.md),
                              Text(
                                _isSearching ? '검색 결과가 없습니다.' : '검색어를 입력해주세요.',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final customer = _filteredCustomers[index];
                            return _buildCustomerCard(customer);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(CustomerCouponModel customer) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppSizes.md),
        leading: CircleAvatar(
          radius: 24.r,
          backgroundColor: AppColors.primary,
          child: Text(
            customer.customerName.isNotEmpty ? customer.customerName[0] : '?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              customer.customerName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSizes.sm),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: customer.hasCoupons ? AppColors.success : AppColors.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                customer.hasCoupons ? 'O' : 'X',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.xs),
            Text(
              customer.customerPhone,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              customer.customerEmail,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            if (customer.hasCoupons) ...[
              SizedBox(height: AppSizes.xs),
              Text(
                '보유 쿠폰: ${customer.coupons.length}장 (미사용: ${customer.coupons.where((c) => !c.isUsed).length}장)',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(
          MdiIcons.chevronRight,
          color: AppColors.textSecondary,
        ),
        onTap: () => _showCustomerDetail(customer),
      ),
    );
  }
}

class CustomerCouponDetailDialog extends StatelessWidget {
  final CustomerCouponModel customer;

  const CustomerCouponDetailDialog({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600.w,
        height: 700.h,
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    customer.customerName.isNotEmpty ? customer.customerName[0] : '?',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.customerName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '고객 상세 정보',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(MdiIcons.close),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),

            // 고객 정보
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '고객 정보',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),
                  _buildInfoRow('이름', customer.customerName),
                  _buildInfoRow('연락처', customer.customerPhone),
                  _buildInfoRow('이메일', customer.customerEmail),
                  _buildInfoRow('고객ID', customer.customerId),
                ],
              ),
            ),
            SizedBox(height: AppSizes.lg),

            // 보유 쿠폰
            Text(
              '보유 쿠폰 (${customer.coupons.length}장)',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),

            Expanded(
              child: customer.coupons.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.ticketOutline,
                            size: 48.sp,
                            color: AppColors.textTertiary,
                          ),
                          SizedBox(height: AppSizes.sm),
                          Text(
                            '보유한 쿠폰이 없습니다.',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: customer.coupons.length,
                      itemBuilder: (context, index) {
                        final coupon = customer.coupons[index];
                        return _buildCouponCard(coupon);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
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

  Widget _buildCouponCard(CouponModel coupon) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      child: Container(
        padding: EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: coupon.isUsed ? AppColors.error : AppColors.success,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: coupon.isUsed ? AppColors.error : AppColors.success,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        coupon.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: AppSizes.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: coupon.type == CouponType.welcome 
                              ? AppColors.primary 
                              : AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          coupon.type.displayName,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.xs),
                  Text(
                    coupon.discountAmountText,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: coupon.isUsed ? AppColors.error : AppColors.success,
                    ),
                  ),
                  SizedBox(height: AppSizes.xs),
                  Text(
                    '발급일: ${coupon.issueDate}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (coupon.isUsed && coupon.useDate != null) ...[
                    Text(
                      '사용일: ${coupon.useDate}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: coupon.isUsed ? AppColors.error : AppColors.success,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                coupon.isUsed ? '사용완료' : '사용가능',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
