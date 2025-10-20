import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/store_model.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String _selectedStatus = 'ALL';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.store,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            _buildStatsCards(),
            SizedBox(height: AppSizes.lg),
            _buildFilters(),
            SizedBox(height: AppSizes.lg),
            Expanded(
              child: _buildStoreList(),
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
              '매장 관리',
              style: TextStyle(
                fontSize: 36.sp, // 28.sp -> 36.sp (가독성 개선)
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              '등록된 매장을 관리하고 운영 상태를 확인할 수 있습니다.',
              style: TextStyle(
                fontSize: 20.sp, // 이미 개선됨
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            context.go(RouteNames.storeRegister);
          },
          icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
          label: const Text('매장 등록'),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    final stores = _getSampleStores();
    final totalCount = stores.length;
    final activeCount = stores.where((s) => s.status == 'ACTIVE').length;
    final pendingCount = stores.where((s) => s.status == 'PENDING').length;
    final inactiveCount = stores.where((s) => s.status == 'INACTIVE').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '총 매장',
            totalCount.toString(),
            '등록된 매장',
            AppColors.primary,
            MdiIcons.store,
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '운영중',
            activeCount.toString(),
            '정상 운영중',
            AppColors.success,
            MdiIcons.checkCircle,
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '승인대기',
            pendingCount.toString(),
            '승인 대기중',
            AppColors.warning,
            MdiIcons.clockAlert,
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '운영중지',
            inactiveCount.toString(),
            '운영 중지',
            AppColors.error,
            MdiIcons.closeCircle,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 32.sp,
                color: color,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.md),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: '검색',
                  hintText: '매장명, 주소, 사업자명, 연락처로 검색',
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
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: '상태',
                ),
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('전체')),
                  DropdownMenuItem(value: 'ACTIVE', child: Text('운영중')),
                  DropdownMenuItem(value: 'INACTIVE', child: Text('운영중지')),
                  DropdownMenuItem(value: 'PENDING', child: Text('승인대기')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
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

  Widget _buildStoreList() {
    final stores = _getSampleStores();
    final filteredStores = stores.where((store) {
      if (_searchText.isNotEmpty) {
        final searchLower = _searchText.toLowerCase();
        if (!store.storeName.toLowerCase().contains(searchLower) &&
            !store.storeAddress.toLowerCase().contains(searchLower) &&
            !(store.businessName?.toLowerCase().contains(searchLower) ?? false) &&
            !(store.storePhone?.toLowerCase().contains(searchLower) ?? false)) {
          return false;
        }
      }
      
      if (_selectedStatus != 'ALL' && store.status != _selectedStatus) {
        return false;
      }
      
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '매장 목록 (${filteredStores.length}개)',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _downloadExcel(filteredStores),
              icon: Icon(MdiIcons.download, size: 18.sp),
              label: Text('엑셀 다운로드'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.md),
        Expanded(
          child: ListView.builder(
            itemCount: filteredStores.length,
            itemBuilder: (context, index) {
              return _buildStoreCard(filteredStores[index]);
            },
          ),
        ),
      ],
    );
  }

  void _downloadExcel(List<StoreModel> stores) {
    try {
      List<List<dynamic>> rows = [];
      
      rows.add([
        '매장ID',
        '매장명',
        '주소',
        '전화번호',
        '사업자명',
        '상태',
        '등록일',
      ]);
      
      for (var store in stores) {
        rows.add([
          store.id,
          store.storeName,
          store.storeAddress,
          store.storePhone ?? '-',
          store.businessName ?? '-',
          store.status == 'OPEN' ? '영업중' : store.status == 'CLOSED' ? '휴업' : '폐업',
          store.registrationDate,
        ]);
      }
      
      String csv = const ListToCsvConverter().convert(rows);
      
      final bytes = utf8.encode('\uFEFF$csv');
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', '매장_목록_${DateTime.now().millisecondsSinceEpoch}.csv')
        ..click();
      html.Url.revokeObjectUrl(url);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('엑셀 파일이 다운로드되었습니다.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('다운로드 중 오류가 발생했습니다: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildStoreCard(StoreModel store) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go('${RouteNames.storeDetail}?id=${store.id}');
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        MdiIcons.store,
                        size: 22.sp,
                        color: AppColors.textSecondary,
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
                                store.storeName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(width: AppSizes.sm),
                              _buildStatusChip(store.status),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            store.businessName ?? '-',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.md),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRow(
                            MdiIcons.mapMarker,
                            '주소',
                            '${store.storeAddress}${store.storeAddressDetail != null ? ' ${store.storeAddressDetail}' : ''}',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sm),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRow(
                            MdiIcons.phone,
                            '매장전화',
                            store.storePhone ?? '-',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
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
        statusText = '운영중';
        break;
      case 'INACTIVE':
        chipColor = AppColors.error;
        statusText = '운영중지';
        break;
      case 'PENDING':
        chipColor = AppColors.warning;
        statusText = '승인대기';
        break;
      default:
        chipColor = AppColors.inactive;
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
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 18.sp, // 14.sp -> 18.sp (가독성 개선)
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  List<StoreModel> _getSampleStores() {
    return [
      StoreModel(
        id: '1',
        businessId: '1',
        storeName: '맛있는집 강남점',
        storeAddress: '서울특별시 강남구 역삼로 123',
        storeAddressDetail: '○○빌딩 1층',
        storePhone: '02-1234-5678',
        storeDescription: '정통 한식을 맛볼 수 있는 곳',
        registrationDate: '2024-08-15',
        status: 'ACTIVE',
        operatingHours: '10:00-22:00',
        deliveryRadius: '3',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        minimumOrderAmount: '12000',
        deliveryFee: '3000',
        businessName: '㈜맛있는집',
        menuCount: 25,
        lastOrderDate: '2024-09-19',
      ),
      StoreModel(
        id: '2',
        businessId: '2',
        storeName: '치킨왕 홍대점',
        storeAddress: '서울특별시 마포구 홍익로 456',
        storeAddressDetail: '△△타워 지하 1층',
        storePhone: '02-2345-6789',
        storeDescription: '바삭바삭한 치킨 전문점',
        registrationDate: '2024-08-20',
        status: 'PENDING',
        operatingHours: '16:00-02:00',
        deliveryRadius: '5',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        minimumOrderAmount: '15000',
        deliveryFee: '2500',
        businessName: '치킨왕 프랜차이즈',
        menuCount: 18,
        lastOrderDate: '2024-09-18',
      ),
      StoreModel(
        id: '3',
        businessId: '3',
        storeName: '피자마을 신촌점',
        storeAddress: '서울특별시 서대문구 신촌로 789',
        storeAddressDetail: '□□플라자 2층',
        storePhone: '02-3456-7890',
        storeDescription: '수제 피자 전문점',
        registrationDate: '2024-09-01',
        status: 'ACTIVE',
        operatingHours: '11:00-23:00',
        deliveryRadius: '4',
        isDeliveryAvailable: true,
        isPickupAvailable: false,
        minimumOrderAmount: '18000',
        deliveryFee: '3500',
        businessName: '피자마을',
        menuCount: 32,
        lastOrderDate: '2024-09-19',
      ),
      StoreModel(
        id: '4',
        businessId: '1',
        storeName: '맛있는집 서초점',
        storeAddress: '서울특별시 서초구 서초대로 321',
        storePhone: '02-4567-8901',
        storeDescription: '맛있는집 2호점',
        registrationDate: '2024-09-10',
        status: 'INACTIVE',
        operatingHours: '10:00-22:00',
        deliveryRadius: '3',
        isDeliveryAvailable: false,
        isPickupAvailable: true,
        minimumOrderAmount: '12000',
        deliveryFee: '0',
        businessName: '㈜맛있는집',
        menuCount: 20,
        lastOrderDate: '2024-09-15',
      ),
    ];
  }
}
