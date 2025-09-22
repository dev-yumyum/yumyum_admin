import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/store_model.dart';

class StoreRegisterPage extends StatefulWidget {
  const StoreRegisterPage({super.key});

  @override
  State<StoreRegisterPage> createState() => _StoreRegisterPageState();
}

class _StoreRegisterPageState extends State<StoreRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // 기본 정보 Controllers
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _storeAddressDetailController = TextEditingController();
  final _storePhoneController = TextEditingController();

  // 매장 소개 Controllers
  final _storeDescriptionController = TextEditingController();
  final _noticeController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: AppSizes.xl),
              _buildActions(),
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
                '매장 등록',
                style: TextStyle(
                  fontSize: 36.sp, // 통일화된 헤더 크기
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                '새로운 매장을 등록하여 운영을 시작하세요.',
                style: TextStyle(
                  fontSize: 20.sp, // 통일화된 서브 텍스트 크기
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
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
            Text(
              '사업자 선택',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            DropdownButtonFormField<String>(
              value: _selectedBusinessId,
              decoration: const InputDecoration(
                labelText: '사업자를 선택하세요',
                hintText: '사업자를 선택하세요',
              ),
              items: _businessOptions.map((business) {
                return DropdownMenuItem<String>(
                  value: business['id'],
                  child: Text(
                    business['name']!,
                    style: TextStyle(fontSize: 20.sp), // 통일화된 드롭다운 텍스트
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBusinessId = value;
                });
              },
              validator: RequiredValidator(errorText: '사업자를 선택해주세요'),
            ),
            SizedBox(height: AppSizes.lg),

            // 매장명
            TextFormField(
              controller: _storeNameController,
              decoration: const InputDecoration(
                labelText: '매장명',
                hintText: '매장명을 입력하세요',
              ),
              validator: RequiredValidator(errorText: '매장명을 입력해주세요'),
            ),
            SizedBox(height: AppSizes.md),

            // 매장주소
            TextFormField(
              controller: _storeAddressController,
              decoration: const InputDecoration(
                labelText: '매장주소',
                hintText: '매장주소를 입력하세요',
              ),
              validator: RequiredValidator(errorText: '매장주소를 입력해주세요'),
            ),
            SizedBox(height: AppSizes.md),

            // 상세주소
            TextFormField(
              controller: _storeAddressDetailController,
              decoration: const InputDecoration(
                labelText: '상세주소',
                hintText: '상세주소를 입력하세요 (선택사항)',
              ),
            ),
            SizedBox(height: AppSizes.md),

            // 매장 전화번호
            TextFormField(
              controller: _storePhoneController,
              decoration: const InputDecoration(
                labelText: '매장 전화번호',
                hintText: '매장 전화번호를 입력하세요',
              ),
              validator: RequiredValidator(errorText: '매장 전화번호를 입력해주세요'),
            ),
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
                fontSize: 24.sp, // 통일화된 카드 제목 크기
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),

            // 매장소개글
            TextFormField(
              controller: _storeDescriptionController,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: '매장소개글',
                hintText: '매장에 대한 소개를 작성해주세요 (최대 500자)',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: AppSizes.lg),

            // 공지사항
            TextFormField(
              controller: _noticeController,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: '공지사항',
                hintText: '고객에게 알릴 공지사항을 작성해주세요 (최대 500자)',
                alignLabelWithHint: true,
              ),
            ),
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
                fontSize: 24.sp, // 통일화된 카드 제목 크기
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),

            // 카테고리 (복수 선택)
            Text(
              '카테고리 (복수 선택 가능)',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            _buildCategorySelection(),
            SizedBox(height: AppSizes.lg),

            // 원산지 표시
            TextFormField(
              controller: _originInfoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '원산지 표시',
                hintText: '주요 식재료의 원산지 정보를 입력하세요',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: AppSizes.md),

            // 영양성분 정보
            TextFormField(
              controller: _nutritionInfoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '영양성분 정보',
                hintText: '주요 메뉴의 영양성분 정보를 입력하세요',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: AppSizes.md),

            // 알레르기 유발 정보
            TextFormField(
              controller: _allergyInfoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '알레르기 유발 정보',
                hintText: '알레르기 유발 가능 식재료 정보를 입력하세요',
                alignLabelWithHint: true,
              ),
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
                fontSize: 24.sp, // 통일화된 카드 제목 크기
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.lg),

            // 매장찾기팁
            Text(
              '매장찾기팁',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            TextFormField(
              controller: _findTipController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '매장찾기팁',
                hintText: '고객이 매장을 쉽게 찾을 수 있는 팁을 작성하세요',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: AppSizes.md),

            // 매장찾기팁 사진 업로드
            Text(
              '매장찾기팁 사진 (최대 3장)',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
            _buildImageUploadSection(),
            SizedBox(height: AppSizes.lg),

            // 주차정보
            Text(
              '주차정보',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.sm),
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
        ),
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
                      _findTipImages[index] != null ? '변경' : '선택',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  if (_findTipImages[index] != null) ...[
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

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.go(RouteNames.store),
            icon: Icon(MdiIcons.arrowLeft, size: AppSizes.iconSm),
            label: Text(
              '취소',
              style: TextStyle(fontSize: 20.sp), // 통일화된 버튼 텍스트
            ),
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _submitForm,
            icon: _isLoading 
                ? SizedBox(
                    width: AppSizes.iconSm,
                    height: AppSizes.iconSm,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(MdiIcons.check, size: AppSizes.iconSm),
            label: Text(
              _isLoading ? '등록 중...' : '매장 등록',
              style: TextStyle(fontSize: 20.sp), // 통일화된 버튼 텍스트
            ),
          ),
        ),
      ],
    );
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
    });
  }

  Future<void> _submitForm() async {
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

    setState(() {
      _isLoading = true;
    });

    try {
      // 실제로는 API 호출
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '매장이 성공적으로 등록되었습니다.',
              style: TextStyle(fontSize: 18.sp),
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(RouteNames.store);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '매장 등록 중 오류가 발생했습니다.',
              style: TextStyle(fontSize: 18.sp),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}