import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/store_model.dart';

class StoreDetailPage extends StatefulWidget {
  final String? storeId;
  
  const StoreDetailPage({super.key, this.storeId});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  StoreModel? _store;
  bool _isLoading = true;
  bool _isEditMode = false;
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _storeNameController;
  late TextEditingController _storeAddressController;
  late TextEditingController _storeAddressDetailController;
  late TextEditingController _storePhoneController;
  late TextEditingController _storeDescriptionController;
  late TextEditingController _operatingHoursController;
  late TextEditingController _deliveryRadiusController;
  late TextEditingController _minimumOrderAmountController;
  late TextEditingController _deliveryFeeController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadStoreData();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeAddressController.dispose();
    _storeAddressDetailController.dispose();
    _storePhoneController.dispose();
    _storeDescriptionController.dispose();
    _operatingHoursController.dispose();
    _deliveryRadiusController.dispose();
    _minimumOrderAmountController.dispose();
    _deliveryFeeController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _storeNameController = TextEditingController();
    _storeAddressController = TextEditingController();
    _storeAddressDetailController = TextEditingController();
    _storePhoneController = TextEditingController();
    _storeDescriptionController = TextEditingController();
    _operatingHoursController = TextEditingController();
    _deliveryRadiusController = TextEditingController();
    _minimumOrderAmountController = TextEditingController();
    _deliveryFeeController = TextEditingController();
  }

  Future<void> _loadStoreData() async {
    // TODO: 실제 API 호출로 데이터 가져오기
    // 현재는 샘플 데이터 사용
    await Future.delayed(const Duration(seconds: 1));
    
    final sampleStores = _getSampleStores();
    final store = sampleStores.firstWhere(
      (s) => s.id == widget.storeId,
      orElse: () => sampleStores.first,
    );

    if (mounted) {
      setState(() {
        _store = store;
        _isLoading = false;
      });
      _updateControllers();
    }
  }

  void _updateControllers() {
    if (_store == null) return;
    
    _storeNameController.text = _store!.storeName;
    _storeAddressController.text = _store!.storeAddress;
    _storeAddressDetailController.text = _store!.storeAddressDetail ?? '';
    _storePhoneController.text = _store!.storePhone ?? '';
    _storeDescriptionController.text = _store!.storeDescription ?? '';
    _operatingHoursController.text = _store!.operatingHours ?? '';
    _deliveryRadiusController.text = _store!.deliveryRadius ?? '';
    _minimumOrderAmountController.text = _store!.minimumOrderAmount ?? '';
    _deliveryFeeController.text = _store!.deliveryFee ?? '';
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        // 수정 모드 종료시 원래 데이터로 복원
        _updateControllers();
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO: 실제 API 호출로 데이터 저장
    await Future.delayed(const Duration(seconds: 1));

    if (_store != null) {
      final updatedStore = _store!.copyWith(
        storeName: _storeNameController.text,
        storeAddress: _storeAddressController.text,
        storeAddressDetail: _storeAddressDetailController.text.isEmpty ? null : _storeAddressDetailController.text,
        storePhone: _storePhoneController.text.isEmpty ? null : _storePhoneController.text,
        storeDescription: _storeDescriptionController.text.isEmpty ? null : _storeDescriptionController.text,
        operatingHours: _operatingHoursController.text.isEmpty ? null : _operatingHoursController.text,
        deliveryRadius: _deliveryRadiusController.text.isEmpty ? null : _deliveryRadiusController.text,
        minimumOrderAmount: _minimumOrderAmountController.text.isEmpty ? null : _minimumOrderAmountController.text,
        deliveryFee: _deliveryFeeController.text.isEmpty ? null : _deliveryFeeController.text,
      );

      setState(() {
        _store = updatedStore;
        _isEditMode = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('매장 정보가 성공적으로 수정되었습니다.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.store,
      child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: AppSizes.lg),
                    _buildContent(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go(RouteNames.store),
          icon: Icon(MdiIcons.arrowLeft, size: AppSizes.iconMd),
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '매장 상세정보',
                style: TextStyle(
                  fontSize: 30.sp, // 28.sp -> 30.sp
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                '${_store?.storeName ?? '매장'} 정보',
                style: TextStyle(
                  fontSize: 18.sp, // 16.sp -> 18.sp
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(),
        SizedBox(width: AppSizes.md),
        if (_isEditMode) ...[
          ElevatedButton.icon(
            onPressed: _saveChanges,
            icon: Icon(MdiIcons.check, size: AppSizes.iconSm),
            label: const Text('저장'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(width: AppSizes.sm),
          OutlinedButton.icon(
            onPressed: _toggleEditMode,
            icon: Icon(MdiIcons.close, size: AppSizes.iconSm),
            label: const Text('취소'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: _toggleEditMode,
            icon: Icon(MdiIcons.pencil, size: AppSizes.iconSm),
            label: const Text('수정'),
          ),
          SizedBox(width: AppSizes.sm),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/store/${widget.storeId}/menu');
            },
            icon: Icon(MdiIcons.silverware, size: AppSizes.iconSm),
            label: const Text('메뉴 관리'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusChip() {
    if (_store == null) return const SizedBox.shrink();
    
    Color chipColor;
    String statusText;
    
    switch (_store!.status) {
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
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 14.sp, // 12.sp -> 14.sp
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_store == null) return const SizedBox.shrink();

    return Column(
      children: [
        _buildBasicInfoCard(),
        SizedBox(height: AppSizes.lg),
        _buildBusinessInfoCard(),
        SizedBox(height: AppSizes.lg),
        _buildDeliveryInfoCard(),
        SizedBox(height: AppSizes.lg),
        _buildOperationInfoCard(),
      ],
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.storefront,
                  size: AppSizes.iconMd,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '기본 정보',
                  style: TextStyle(
                    fontSize: 20.sp, // 18.sp -> 20.sp
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildInfoRow(
              '매장명', 
              _store!.storeName,
              controller: _storeNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '매장명은 필수입니다.';
                }
                return null;
              },
            ),
            _buildInfoRow('사업자', _store!.businessName ?? '-'),
            _buildInfoRow(
              '매장 주소', 
              _store!.storeAddress,
              controller: _storeAddressController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '매장 주소는 필수입니다.';
                }
                return null;
              },
            ),
            _buildInfoRow(
              '상세주소', 
              _store!.storeAddressDetail ?? '',
              controller: _storeAddressDetailController,
            ),
            _buildInfoRow(
              '매장 전화번호', 
              _store!.storePhone ?? '',
              controller: _storePhoneController,
            ),
            _buildInfoRow(
              '매장 설명', 
              _store!.storeDescription ?? '',
              controller: _storeDescriptionController,
            ),
            _buildInfoRow('등록일', _store!.registrationDate),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.domain,
                  size: AppSizes.iconMd,
                  color: AppColors.secondary,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '사업 정보',
                  style: TextStyle(
                    fontSize: 20.sp, // 18.sp -> 20.sp
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildInfoRow(
              '운영시간', 
              _store!.operatingHours ?? '',
              controller: _operatingHoursController,
            ),
            _buildInfoRow('서비스 타입', _buildServiceTypeText()),
            _buildInfoRow('메뉴 개수', _store!.menuCount != null ? '${_store!.menuCount}개' : '-'),
            if (_store!.lastOrderDate != null)
              _buildInfoRow('최근 주문일', _store!.lastOrderDate!),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.truckDelivery,
                  size: AppSizes.iconMd,
                  color: AppColors.info,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '포장 정보',
                  style: TextStyle(
                    fontSize: 20.sp, // 18.sp -> 20.sp
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildInfoRow('배달 가능', _store!.isDeliveryAvailable ? '가능' : '불가능'),
            if (_store!.isDeliveryAvailable) ...[
              _buildInfoRow(
                '배달 범위', 
                _store!.deliveryRadius != null ? '${_store!.deliveryRadius}km' : '',
                controller: _deliveryRadiusController,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final radius = double.tryParse(value);
                    if (radius == null || radius <= 0) {
                      return '올바른 숫자를 입력하세요.';
                    }
                  }
                  return null;
                },
              ),
              _buildInfoRow(
                '배달 수수료', 
                _store!.deliveryFee != null ? '${_formatCurrency(_store!.deliveryFee!)}원' : '',
                controller: _deliveryFeeController,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final fee = int.tryParse(value.replaceAll(',', ''));
                    if (fee == null || fee < 0) {
                      return '올바른 금액을 입력하세요.';
                    }
                  }
                  return null;
                },
              ),
            ],
            _buildInfoRow('포장 가능', _store!.isPickupAvailable ? '가능' : '불가능'),
            _buildInfoRow(
              '최소 주문금액', 
              _store!.minimumOrderAmount != null ? '${_formatCurrency(_store!.minimumOrderAmount!)}원' : '',
              controller: _minimumOrderAmountController,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final amount = int.tryParse(value.replaceAll(',', ''));
                  if (amount == null || amount < 0) {
                    return '올바른 금액을 입력하세요.';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.chartLine,
                  size: AppSizes.iconMd,
                  color: AppColors.warning,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '운영 현황',
                  style: TextStyle(
                    fontSize: 20.sp, // 18.sp -> 20.sp
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildStatCard('총 주문 수', '1,234', '건', AppColors.primary),
            SizedBox(height: AppSizes.md),
            _buildStatCard('월 매출', '2,500,000', '원', AppColors.success),
            SizedBox(height: AppSizes.md),
            _buildStatCard('평균 주문 금액', '25,000', '원', AppColors.info),
            SizedBox(height: AppSizes.md),
            _buildStatCard('리뷰 평점', '4.5', '점', AppColors.warning),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextEditingController? controller, String? Function(String?)? validator}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Padding(
              padding: EdgeInsets.only(top: _isEditMode ? 14.h : 0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp, // 14.sp -> 16.sp
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: _isEditMode && controller != null
                ? TextFormField(
                    controller: controller,
                    validator: validator,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.sm,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16.sp, // 14.sp -> 16.sp
                      color: AppColors.textPrimary,
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp, // 14.sp -> 16.sp
                      color: AppColors.textPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp, // 12.sp -> 14.sp
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20.sp, // 18.sp -> 20.sp
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(width: AppSizes.xs),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 14.sp, // 12.sp -> 14.sp
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildServiceTypeText() {
    List<String> services = [];
    if (_store!.isDeliveryAvailable) services.add('포장');
    if (_store!.isPickupAvailable) services.add('포장');
    return services.isEmpty ? '-' : services.join(', ');
  }

  String _formatCurrency(String value) {
    final num = int.tryParse(value) ?? 0;
    return num.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
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