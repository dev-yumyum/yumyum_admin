import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              '등록된 매장을 관리하고 운영 상태를 확인할 수 있습니다.',
              style: TextStyle(
                fontSize: 16.sp,
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
                  hintText: '매장명, 주소, 사업자명으로 검색',
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
            !(store.businessName?.toLowerCase().contains(searchLower) ?? false)) {
          return false;
        }
      }
      
      if (_selectedStatus != 'ALL' && store.status != _selectedStatus) {
        return false;
      }
      
      return true;
    }).toList();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '매장 목록 (${filteredStores.length}개)',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: ListView.separated(
                itemCount: filteredStores.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.border,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final store = filteredStores[index];
                  return _buildStoreItem(store);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreItem(StoreModel store) {
    return ListTile(
      onTap: () {
        context.go('${RouteNames.storeDetail}?id=${store.id}');
      },
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      leading: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Icon(
          MdiIcons.storefront,
          size: AppSizes.iconMd,
          color: AppColors.secondary,
        ),
      ),
      title: Text(
        store.storeName,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.xs),
          if (store.businessName != null)
            Text(
              '사업자: ${store.businessName}',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          Text(
            '주소: ${store.storeAddress}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.xs),
          Row(
            children: [
              if (store.isDeliveryAvailable)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.xs,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '포장',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (store.isPickupAvailable) ...[
                if (store.isDeliveryAvailable) SizedBox(width: AppSizes.xs),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.xs,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '포장',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          context.go('/store/${store.id}/menu');
        },
        icon: Icon(
          MdiIcons.silverware,
          size: AppSizes.iconSm,
          color: AppColors.warning,
        ),
        tooltip: '메뉴 관리',
      ),
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
          fontSize: 10.sp,
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
