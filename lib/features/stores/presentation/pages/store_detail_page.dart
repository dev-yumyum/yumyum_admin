import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:math' as math;

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
  
  // 기본 정보 Controllers
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _storeAddressDetailController = TextEditingController();
  final _storePhoneController = TextEditingController();

  // 매장 소개 Controllers
  final _storeDescriptionController = TextEditingController();
  final _noticeController = TextEditingController();

  // 매장소개 이미지
  File? _storeIntroImage;
  String? _storeIntroImageName;
  String? _existingStoreIntroImageUrl;

  // 카테고리 및 정보 Controllers
  final _originInfoController = TextEditingController();
  final _nutritionInfoController = TextEditingController();
  final _allergyInfoController = TextEditingController();

  // 편의 정보 Controllers
  final _findTipController = TextEditingController();
  final _parkingInfoController = TextEditingController();

  // 선택 상태들
  String? _selectedBusinessId;
  List<String> _selectedCategories = [];
  String _parkingAvailable = 'NO'; // YES or NO

  // 파일 업로드
  List<File?> _findTipImages = [null, null, null];
  List<String?> _findTipImageNames = [null, null, null];
  List<String?> _existingImageUrls = [null, null, null]; // 기존 이미지 URL들

  // 카테고리 옵션들
  final List<String> _categoryOptions = [
    '한식', '중식', '일식', '양식', '치킨', '피자', '햄버거',
    '카페', '디저트', '분식', '술집', '고기', '해산물', '아시안',
    '멕시칸', '인도', '태국', '베트남', '샐러드', '건강식',
  ];

  // 사업자 목록 (실제로는 API에서 가져옴)
  final List<Map<String, String>> _businessOptions = [
    {'id': '1', 'name': '㈜맛있는집'},
    {'id': '2', 'name': '치킨왕 프랜차이즈'},
    {'id': '3', 'name': '피자마을'},
    {'id': '4', 'name': '햄버거킹'},
  ];

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeAddressController.dispose();
    _storeAddressDetailController.dispose();
    _storePhoneController.dispose();
    _storeDescriptionController.dispose();
    _noticeController.dispose();
    _originInfoController.dispose();
    _nutritionInfoController.dispose();
    _allergyInfoController.dispose();
    _findTipController.dispose();
    _parkingInfoController.dispose();
    super.dispose();
  }

  Future<void> _loadStoreData() async {
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
    
    // 기본 정보
    _storeNameController.text = _store!.storeName;
    _storeAddressController.text = _store!.storeAddress;
    _storeAddressDetailController.text = _store!.storeAddressDetail ?? '';
    _storePhoneController.text = _store!.storePhone ?? '';
    
    // 매장 소개 (실제로는 store 모델에서 가져와야 함, 현재는 샘플 데이터)
    _storeDescriptionController.text = _store!.storeDescription ?? '신선한 재료로 만든 맛있는 요리를 제공합니다.';
    _noticeController.text = '매장 휴무일: 매주 월요일\n배달 시간: 오전 11시 ~ 오후 9시';
    
    // 매장소개 이미지 (샘플)
    _existingStoreIntroImageUrl = _store!.storeIntroImage ?? 'https://example.com/store_intro.jpg';
    
    // 카테고리 및 정보 (샘플 데이터)
    _selectedCategories = ['한식', '치킨'];
    _originInfoController.text = '쌀: 국산, 닭고기: 국산, 야채류: 국산';
    _nutritionInfoController.text = '칼로리: 350kcal, 나트륨: 800mg, 단백질: 25g';
    _allergyInfoController.text = '대두, 밀, 달걀 함유';
    
    // 편의 정보 (샘플 데이터)
    _findTipController.text = '지하철 2호선 강남역 3번 출구에서 도보 5분\n건물 1층에 위치';
    _parkingAvailable = 'YES';
    _parkingInfoController.text = '건물 지하 1층 무료주차 (2시간)';
    
    // 사업자 ID 설정
    _selectedBusinessId = _store!.businessId;
    
    // 기존 이미지 URL (샘플)
    _existingImageUrls = [
      'https://example.com/store1.jpg',
      'https://example.com/store2.jpg', 
      null
    ];
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        // 편집 취소 시 원래 값으로 복원
        _updateControllers();
        // 매장소개 이미지도 원래 값으로 복원
        _storeIntroImage = null;
        _storeIntroImageName = null;
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '최소 1개 이상의 카테고리를 선택해주세요.',
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      // 실제로는 API 호출
      await Future.delayed(const Duration(seconds: 1));
      
      // 업데이트된 매장 정보 생성
      final updatedStore = _store!.copyWith(
        storeName: _storeNameController.text,
        storeAddress: _storeAddressController.text,
        storeAddressDetail: _storeAddressDetailController.text.isEmpty 
            ? null : _storeAddressDetailController.text,
        storePhone: _storePhoneController.text.isEmpty 
            ? null : _storePhoneController.text,
        storeDescription: _storeDescriptionController.text.isEmpty 
            ? null : _storeDescriptionController.text,
        businessId: _selectedBusinessId!,
      );

      setState(() {
        _store = updatedStore;
        _isEditMode = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '매장 정보가 성공적으로 수정되었습니다.',
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '수정 중 오류가 발생했습니다.',
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CrmLayout(
        currentRoute: RouteNames.store,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return CrmLayout(
      currentRoute: RouteNames.store,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: AppSizes.lg),
              _buildBasicInfoSection(),
              SizedBox(height: AppSizes.lg),
              _buildDescriptionSection(),
              SizedBox(height: AppSizes.lg),
              _buildCategoryInfoSection(),
              SizedBox(height: AppSizes.lg),
              _buildConvenienceSection(),
              if (_isEditMode) ...[
                SizedBox(height: AppSizes.xl),
                _buildEditActions(),
              ],
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
          icon: Icon(
            MdiIcons.arrowLeft, 
            size: AppSizes.iconMd,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _store?.storeName ?? '매장 상세정보',
                style: TextStyle(
                  fontSize: 36.sp, // 통일화된 헤더 크기
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                '매장 정보를 확인하고 수정할 수 있습니다.',
                style: TextStyle(
                  fontSize: 20.sp, // 통일화된 서브 텍스트 크기
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(),
        SizedBox(width: AppSizes.md),
        if (!_isEditMode) ...[
          OutlinedButton.icon(
            onPressed: () {
              context.go('/store/${_store!.id}/menu');
            },
            icon: Icon(MdiIcons.silverware, size: AppSizes.iconSm),
            label: Text(
              '메뉴 관리',
              style: TextStyle(fontSize: 18.sp),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
            ),
          ),
          SizedBox(width: AppSizes.md),
          ElevatedButton.icon(
            onPressed: _toggleEditMode,
            icon: Icon(MdiIcons.pencil, size: AppSizes.iconSm),
            label: Text(
              '수정',
              style: TextStyle(fontSize: 18.sp),
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
        statusText = _store!.status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기본 정보',
              style: TextStyle(
                fontSize: 24.sp, // 통일화된 카드 제목 크기
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),
            
            // 사업자 선택
            _buildInfoRow(
              '사업자',
              _isEditMode
                  ? DropdownButtonFormField<String>(
                      value: _selectedBusinessId,
                      decoration: const InputDecoration(
                        labelText: '사업자를 선택하세요',
                      ),
                      items: _businessOptions.map((business) {
                        return DropdownMenuItem<String>(
                          value: business['id'],
                          child: Text(
                            business['name']!,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBusinessId = value;
                        });
                      },
                      validator: RequiredValidator(errorText: '사업자를 선택해주세요'),
                    )
                  : null,
              _getBusinessNameById(_selectedBusinessId ?? ''),
            ),

            _buildInfoRow(
              '매장명',
              _isEditMode
                  ? TextFormField(
                      controller: _storeNameController,
                      decoration: const InputDecoration(labelText: '매장명'),
                      validator: RequiredValidator(errorText: '매장명을 입력해주세요'),
                    )
                  : null,
              _store?.storeName ?? '',
            ),

            _buildInfoRow(
              '매장주소',
              _isEditMode
                  ? TextFormField(
                      controller: _storeAddressController,
                      decoration: const InputDecoration(labelText: '매장주소'),
                      validator: RequiredValidator(errorText: '매장주소를 입력해주세요'),
                    )
                  : null,
              _store?.storeAddress ?? '',
            ),

            _buildInfoRow(
              '상세주소',
              _isEditMode
                  ? TextFormField(
                      controller: _storeAddressDetailController,
                      decoration: const InputDecoration(labelText: '상세주소'),
                    )
                  : null,
              _store?.storeAddressDetail ?? '-',
            ),

            _buildInfoRow(
              '매장 전화번호',
              _isEditMode
                  ? TextFormField(
                      controller: _storePhoneController,
                      decoration: const InputDecoration(labelText: '매장 전화번호'),
                      validator: RequiredValidator(errorText: '매장 전화번호를 입력해주세요'),
                    )
                  : null,
              _store?.storePhone ?? '-',
            ),

            // 좌표 정보
            _buildCoordinateRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '매장 소개',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),

            _buildInfoRow(
              '매장소개글',
              _isEditMode
                  ? TextFormField(
                      controller: _storeDescriptionController,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: '매장소개글',
                        alignLabelWithHint: true,
                      ),
                    )
                  : null,
              _storeDescriptionController.text.isEmpty ? '-' : _storeDescriptionController.text,
            ),

            _buildInfoRow(
              '공지사항',
              _isEditMode
                  ? TextFormField(
                      controller: _noticeController,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: '공지사항',
                        alignLabelWithHint: true,
                      ),
                    )
                  : null,
              _noticeController.text.isEmpty ? '-' : _noticeController.text,
            ),

            // 매장소개 이미지
            SizedBox(height: AppSizes.md),
            Text(
              '매장소개 사진',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            _isEditMode ? _buildStoreIntroImageUpload() : _buildStoreIntroImageDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryInfoSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '카테고리 및 정보',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),

            // 카테고리
            _buildInfoRow(
              '카테고리',
              _isEditMode ? _buildCategorySelection() : null,
              _selectedCategories.isEmpty ? '-' : _selectedCategories.join(', '),
            ),

            _buildInfoRow(
              '원산지 표시',
              _isEditMode
                  ? TextFormField(
                      controller: _originInfoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '원산지 표시',
                        alignLabelWithHint: true,
                      ),
                    )
                  : null,
              _originInfoController.text.isEmpty ? '-' : _originInfoController.text,
            ),

            _buildInfoRow(
              '영양성분 정보',
              _isEditMode
                  ? TextFormField(
                      controller: _nutritionInfoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '영양성분 정보',
                        alignLabelWithHint: true,
                      ),
                    )
                  : null,
              _nutritionInfoController.text.isEmpty ? '-' : _nutritionInfoController.text,
            ),

            _buildInfoRow(
              '알레르기 유발 정보',
              _isEditMode
                  ? TextFormField(
                      controller: _allergyInfoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '알레르기 유발 정보',
                        alignLabelWithHint: true,
                      ),
                    )
                  : null,
              _allergyInfoController.text.isEmpty ? '-' : _allergyInfoController.text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvenienceSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '편의 정보',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),

            _buildInfoRow(
              '매장찾기팁',
              _isEditMode
                  ? TextFormField(
                      controller: _findTipController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '매장찾기팁',
                        alignLabelWithHint: true,
                      ),
                    )
                  : null,
              _findTipController.text.isEmpty ? '-' : _findTipController.text,
            ),

            // 매장찾기팁 사진
            if (_isEditMode || _hasImages()) ...[
              SizedBox(height: AppSizes.md),
              Text(
                '매장찾기팁 사진',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              _isEditMode ? _buildImageUploadSection() : _buildImageDisplaySection(),
            ],

            SizedBox(height: AppSizes.lg),

            // 주차정보
            _buildInfoRow(
              '주차정보',
              _isEditMode ? _buildParkingSection() : null,
              _parkingAvailable == 'YES' 
                  ? '주차 가능${_parkingInfoController.text.isNotEmpty ? ' - ${_parkingInfoController.text}' : ''}'
                  : '주차 불가능',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, Widget? editWidget, String displayValue) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSizes.lg),
          Expanded(
            child: _isEditMode && editWidget != null
                ? editWidget
                : Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedCategories.isNotEmpty) ...[
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: _selectedCategories.map((category) {
                return Chip(
                  label: Text(
                    category,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _selectedCategories.remove(category);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: AppSizes.md),
          ],
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: _categoryOptions
                .where((category) => !_selectedCategories.contains(category))
                .map((category) {
              return FilterChip(
                label: Text(
                  category,
                  style: TextStyle(fontSize: 16.sp),
                ),
                selected: false,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategories.add(category);
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(
                  '주차 가능',
                  style: TextStyle(fontSize: 18.sp),
                ),
                value: 'YES',
                groupValue: _parkingAvailable,
                onChanged: (value) {
                  setState(() {
                    _parkingAvailable = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(
                  '주차 불가능',
                  style: TextStyle(fontSize: 18.sp),
                ),
                value: 'NO',
                groupValue: _parkingAvailable,
                onChanged: (value) {
                  setState(() {
                    _parkingAvailable = value!;
                  });
                },
              ),
            ),
          ],
        ),
        if (_parkingAvailable == 'YES') ...[
          SizedBox(height: AppSizes.md),
          TextFormField(
            controller: _parkingInfoController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: '주차 상세정보',
              hintText: '주차 가능 대수, 주차 요금, 주차 위치 등을 입력하세요',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.md),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  child: _findTipImages[index] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          child: Image.file(
                            _findTipImages[index]!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : _existingImageUrls[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                              child: Container(
                                color: AppColors.background,
                                child: Center(
                                  child: Text(
                                    '기존 이미지 ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MdiIcons.imageOutline,
                                    size: 40.r,
                                    color: AppColors.textTertiary,
                                  ),
                                  SizedBox(height: AppSizes.xs),
                                  Text(
                                    '사진 ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
              SizedBox(width: AppSizes.md),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(index),
                    icon: Icon(MdiIcons.upload, size: AppSizes.iconSm),
                    label: Text(
                      _findTipImages[index] != null || _existingImageUrls[index] != null 
                          ? '변경' : '선택',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  if (_findTipImages[index] != null || _existingImageUrls[index] != null) ...[
                    SizedBox(height: AppSizes.sm),
                    OutlinedButton.icon(
                      onPressed: () => _removeImage(index),
                      icon: Icon(MdiIcons.delete, size: AppSizes.iconSm),
                      label: Text(
                        '삭제',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageDisplaySection() {
    List<String> imageUrls = [];
    for (int i = 0; i < 3; i++) {
      if (_existingImageUrls[i] != null) {
        imageUrls.add(_existingImageUrls[i]!);
      }
    }

    if (imageUrls.isEmpty) {
      return Text(
        '등록된 이미지가 없습니다.',
        style: TextStyle(
          fontSize: 18.sp,
          color: AppColors.textTertiary,
        ),
      );
    }

    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: imageUrls.map((url) {
        return Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            color: AppColors.background,
          ),
          child: Center(
            child: Text(
              '매장 이미지',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _hasImages() {
    return _existingImageUrls.any((url) => url != null) ||
           _findTipImages.any((file) => file != null);
  }

  Widget _buildEditActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _toggleEditMode,
            icon: Icon(MdiIcons.close, size: AppSizes.iconSm),
            label: Text(
              '취소',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _saveChanges,
            icon: Icon(MdiIcons.check, size: AppSizes.iconSm),
            label: Text(
              '저장',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ),
      ],
    );
  }

  String _getBusinessNameById(String id) {
    final business = _businessOptions.firstWhere(
      (b) => b['id'] == id,
      orElse: () => {'id': '', 'name': '-'},
    );
    return business['name'] ?? '-';
  }

  Future<void> _pickImage(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _findTipImages[index] = File(result.files.single.path!);
          _findTipImageNames[index] = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '이미지 선택 중 오류가 발생했습니다.',
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _findTipImages[index] = null;
      _findTipImageNames[index] = null;
      _existingImageUrls[index] = null;
    });
  }

  Widget _buildStoreIntroImageUpload() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              child: _storeIntroImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      child: Image.file(
                        _storeIntroImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : _existingStoreIntroImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          child: Container(
                            color: AppColors.background,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MdiIcons.imageOutline,
                                    size: 40.r,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(height: AppSizes.xs),
                                  Text(
                                    '기존 매장소개 이미지',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.imageOutline,
                                size: 50.r,
                                color: AppColors.textTertiary,
                              ),
                              SizedBox(height: AppSizes.sm),
                              Text(
                                '매장소개 사진을 선택하세요',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              SizedBox(height: AppSizes.xs),
                              Text(
                                '1장만 첨부 가능',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickStoreIntroImage,
                  icon: Icon(MdiIcons.upload, size: AppSizes.iconSm),
                  label: Text(
                    _storeIntroImage != null || _existingStoreIntroImageUrl != null 
                        ? '변경' : '선택',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                if (_storeIntroImage != null || _existingStoreIntroImageUrl != null) ...[
                  SizedBox(height: AppSizes.md),
                  OutlinedButton.icon(
                    onPressed: _removeStoreIntroImage,
                    icon: Icon(MdiIcons.delete, size: AppSizes.iconSm),
                    label: Text(
                      '삭제',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreIntroImageDisplay() {
    if (_existingStoreIntroImageUrl == null) {
      return Container(
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          color: AppColors.background,
        ),
        child: Center(
          child: Text(
            '등록된 매장소개 사진이 없습니다.',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        color: AppColors.background,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.imageOutline,
                size: 40.r,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                '매장소개 이미지',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickStoreIntroImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _storeIntroImage = File(result.files.single.path!);
          _storeIntroImageName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '이미지 선택 중 오류가 발생했습니다.',
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeStoreIntroImage() {
    setState(() {
      _storeIntroImage = null;
      _storeIntroImageName = null;
      _existingStoreIntroImageUrl = null;
    });
  }

  Widget _buildCoordinateRow() {
    final latitude = _store?.latitude ?? 37.5665;
    final longitude = _store?.longitude ?? 126.9780;
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              '좌표',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '위도: ${latitude.toStringAsFixed(6)}, 경도: ${longitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    OutlinedButton.icon(
                      onPressed: () => _showMapDialog(),
                      icon: Icon(MdiIcons.map, size: AppSizes.iconSm),
                      label: Text(
                        '지도로 보기',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                if (_isEditMode) ...[
                  SizedBox(height: AppSizes.sm),
                  Text(
                    '지도에서 위치를 수정할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMapDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MapEditDialog(
          initialLatitude: _store?.latitude ?? 37.5665,
          initialLongitude: _store?.longitude ?? 126.9780,
          initialAddress: '${_store?.storeAddress ?? ''} ${_store?.storeAddressDetail ?? ''}'.trim(),
          isEditMode: _isEditMode,
          onLocationChanged: (latitude, longitude, address) {
            if (_isEditMode) {
              setState(() {
                // 실제로는 store 모델을 업데이트해야 함
                _storeAddressController.text = address;
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '위치가 업데이트되었습니다.',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
        );
      },
    );
  }

  List<StoreModel> _getSampleStores() {
    return [
      StoreModel(
        id: '1',
        businessId: '1',
        storeName: '맛있는집 강남점',
        storeAddress: '서울시 강남구 테헤란로 123',
        storeAddressDetail: '1층',
        storePhone: '02-1234-5678',
        storeDescription: '신선한 재료로 만든 맛있는 한식을 제공합니다.',
        status: 'ACTIVE',
        operatingHours: '09:00-21:00',
        deliveryRadius: '3km',
        minimumOrderAmount: '15000',
        deliveryFee: '3000',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        latitude: 37.5665,
        longitude: 126.9780,
        registrationDate: '2024-01-15',
      ),
      StoreModel(
        id: '2',
        businessId: '2',
        storeName: '치킨왕 홍대점',
        storeAddress: '서울시 마포구 홍익로 456',
        storePhone: '02-2345-6789',
        status: 'ACTIVE',
        operatingHours: '11:00-23:00',
        deliveryRadius: '2km',
        minimumOrderAmount: '20000',
        deliveryFee: '2000',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        latitude: 37.5547,
        longitude: 126.9236,
        registrationDate: '2024-02-10',
      ),
    ];
  }
}

class MapEditDialog extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final String initialAddress;
  final bool isEditMode;
  final Function(double latitude, double longitude, String address)? onLocationChanged;

  const MapEditDialog({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.initialAddress,
    required this.isEditMode,
    this.onLocationChanged,
  });

  @override
  State<MapEditDialog> createState() => _MapEditDialogState();
}

class _MapEditDialogState extends State<MapEditDialog> {
  late double _currentLatitude;
  late double _currentLongitude;
  late String _currentAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentLatitude = widget.initialLatitude;
    _currentLongitude = widget.initialLongitude;
    _currentAddress = widget.initialAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800.w,
        height: 600.h,
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogHeader(),
            SizedBox(height: AppSizes.lg),
            _buildCoordinateInfo(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: _buildMapContainer(),
            ),
            SizedBox(height: AppSizes.lg),
            _buildDialogActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      children: [
        Icon(
          MdiIcons.mapMarker,
          size: AppSizes.iconMd,
          color: AppColors.primary,
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditMode ? '매장 위치 수정' : '매장 위치 확인',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                widget.isEditMode 
                    ? '지도에서 마커를 드래그하여 위치를 변경할 수 있습니다.'
                    : '현재 매장의 위치를 확인할 수 있습니다.',
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
          icon: Icon(
            MdiIcons.close,
            size: AppSizes.iconMd,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinateInfo() {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.crosshairsGps,
                size: AppSizes.iconSm,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                '좌표 정보',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            '위도: ${_currentLatitude.toStringAsFixed(6)}, 경도: ${_currentLongitude.toStringAsFixed(6)}',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
          SizedBox(height: AppSizes.xs),
          Row(
            children: [
              Icon(
                MdiIcons.mapMarkerOutline,
                size: AppSizes.iconSm,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  _currentAddress.isNotEmpty ? _currentAddress : '주소 정보 없음',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Stack(
          children: [
            // 지도 시뮬레이션 (실제로는 Google Maps 또는 다른 지도 서비스 사용)
            _buildSimulatedMap(),
            
            // 편집 모드인 경우 편집 가능 표시
            if (widget.isEditMode)
              Positioned(
                top: AppSizes.md,
                right: AppSizes.md,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MdiIcons.cursorMove,
                        size: AppSizes.iconXs,
                        color: Colors.white,
                      ),
                      SizedBox(width: AppSizes.xs),
                      Text(
                        '편집 가능',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 로딩 오버레이
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                        SizedBox(height: AppSizes.md),
                        Text(
                          '주소를 업데이트하는 중...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatedMap() {
    // 실제 구현에서는 Google Maps 위젯을 사용
    return GestureDetector(
      onTapDown: widget.isEditMode ? _handleMapTap : null,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 격자 패턴으로 지도 느낌 연출
            CustomPaint(
              size: Size.infinite,
              painter: MapGridPainter(),
            ),
            
            // 중앙 마커
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    MdiIcons.mapMarker,
                    size: 40.r,
                    color: AppColors.error,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '매장 위치',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 지도 정보
            Positioned(
              bottom: AppSizes.md,
              left: AppSizes.md,
              child: Container(
                padding: EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Text(
                  '시뮬레이션 지도\n실제로는 Google Maps 등 실제 지도 서비스가 표시됩니다.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMapTap(TapDownDetails details) {
    if (!widget.isEditMode) return;

    // 시뮬레이션: 탭한 위치 기준으로 좌표 변경
    setState(() {
      _isLoading = true;
    });

    // 가상의 좌표 변경 (실제로는 지도 API에서 제공하는 좌표를 사용)
    final random = math.Random();
    final newLatitude = _currentLatitude + (random.nextDouble() - 0.5) * 0.01;
    final newLongitude = _currentLongitude + (random.nextDouble() - 0.5) * 0.01;

    // 역지오코딩 시뮬레이션
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentLatitude = newLatitude;
          _currentLongitude = newLongitude;
          _currentAddress = _generateSimulatedAddress(newLatitude, newLongitude);
          _isLoading = false;
        });
      }
    });
  }

  String _generateSimulatedAddress(double latitude, double longitude) {
    // 실제로는 역지오코딩 API를 호출하여 주소를 가져옴
    final addressSamples = [
      '서울시 강남구 테헤란로 152',
      '서울시 강남구 역삼동 823-24',
      '서울시 강남구 삼성동 159-1',
      '서울시 서초구 서초대로 396',
      '서울시 송파구 잠실동 40-1',
    ];
    
    final random = math.Random();
    return addressSamples[random.nextInt(addressSamples.length)];
  }

  Widget _buildDialogActions() {
    return Row(
      children: [
        if (widget.isEditMode) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // 원래 값으로 복원
                setState(() {
                  _currentLatitude = widget.initialLatitude;
                  _currentLongitude = widget.initialLongitude;
                  _currentAddress = widget.initialAddress;
                });
              },
              icon: Icon(MdiIcons.restore, size: AppSizes.iconSm),
              label: Text(
                '원래대로',
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ),
          SizedBox(width: AppSizes.md),
        ],
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(MdiIcons.close, size: AppSizes.iconSm),
            label: Text(
              '닫기',
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ),
        if (widget.isEditMode) ...[
          SizedBox(width: AppSizes.md),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () {
                      widget.onLocationChanged?.call(
                        _currentLatitude,
                        _currentLongitude,
                        _currentAddress,
                      );
                      Navigator.of(context).pop();
                    },
              icon: Icon(MdiIcons.check, size: AppSizes.iconSm),
              label: Text(
                '적용',
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 1;

    const gridSize = 50.0;

    // 세로선
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // 가로선
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}