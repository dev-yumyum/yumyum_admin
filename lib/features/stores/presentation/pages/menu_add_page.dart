import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/menu_group_model.dart';
import '../../data/models/option_group_model.dart';

class MenuAddPage extends StatefulWidget {
  final String storeId;
  final String? groupId;
  final String? menuId; // 수정 모드일 때 사용

  const MenuAddPage({
    super.key,
    required this.storeId,
    this.groupId,
    this.menuId,
  });

  @override
  State<MenuAddPage> createState() => _MenuAddPageState();
}

class _MenuAddPageState extends State<MenuAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _menuNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedGroupId;
  List<Map<String, dynamic>> _availableGroups = [];
  List<Map<String, dynamic>> _selectedOptions = [];
  List<Map<String, dynamic>> _availableOptions = [];
  String? _menuImagePath;
  Uint8List? _menuImageBytes; // 웹에서 이미지 바이트 데이터
  String? _menuImageName; // 선택된 이미지 파일명

  @override
  void initState() {
    super.initState();
    _loadData();
    // groupId가 그룹 이름인 경우 해당하는 id를 찾기
    if (widget.groupId != null) {
      final group = _availableGroups.firstWhere(
        (group) => group['name'] == widget.groupId,
        orElse: () => {'id': widget.groupId, 'name': widget.groupId},
      );
      _selectedGroupId = group['id'];
    }
  }

  void _loadData() {
    // 샘플 메뉴 그룹 데이터
    _availableGroups = [
      {'id': '1', 'name': '피자'},
      {'id': '2', 'name': '파스타'},
      {'id': '3', 'name': '치킨'},
      {'id': '4', 'name': '버거'},
      {'id': '5', 'name': '음료'},
    ];

    // 샘플 옵션 그룹 데이터
    _availableOptions = [
      {
        'id': '1',
        'name': '포토리뷰&할인 이벤트',
        'maxSelection': 1,
        'items': [
          {'name': '포토리뷰: X 이벤트 안함께요', 'price': 0},
          {'name': '포토리뷰: 갈릭딥핑 2개 (5점 후기 부탁드려요)', 'price': 0},
          {'name': '포토리뷰: 모짜렐라 100g (5점 후기 부탁드려요)', 'price': 0},
        ]
      },
      {
        'id': '2',
        'name': '사이드 메뉴',
        'maxSelection': 3,
        'items': [
          {'name': '갈릭 브레드', 'price': 3000},
          {'name': '치즈 스틱', 'price': 4500},
          {'name': '감자튀김', 'price': 2500},
        ]
      },
      {
        'id': '3',
        'name': '음료',
        'maxSelection': 2,
        'items': [
          {'name': '콜라', 'price': 2000},
          {'name': '사이다', 'price': 2000},
          {'name': '오렌지 주스', 'price': 3000},
        ]
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.store,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(),
                      SizedBox(height: AppSizes.lg),
                      _buildBasicInfoSection(),
                      SizedBox(height: AppSizes.lg),
                      _buildOptionsSection(),
                      SizedBox(height: AppSizes.xl),
                      _buildActionButtons(),
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

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            MdiIcons.arrowLeft,
            size: AppSizes.iconMd,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: AppSizes.sm),
        Text(
          widget.menuId != null ? '메뉴 수정' : '메뉴 추가',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '메뉴 이미지',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            if (_menuImageName != null) ...[
              Container(
                padding: EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.checkCircle,
                      color: AppColors.success,
                      size: AppSizes.iconSm,
                    ),
                    SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        '선택된 파일: $_menuImageName',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.md),
            ],
            Row(
              children: [
                // 메뉴 이미지
                Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _menuImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          child: Image.memory(
                            _menuImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : _menuImagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                              child: Image.network(
                                _menuImagePath!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MdiIcons.imageOffOutline,
                                  size: AppSizes.iconXl,
                                  color: AppColors.textTertiary,
                                ),
                                SizedBox(height: AppSizes.sm),
                                Text(
                                  '이미지를 등록해주세요',
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                ),
                SizedBox(width: AppSizes.md),
                // 등록/변경/삭제 버튼들
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _selectImage,
                      icon: Icon(MdiIcons.image, size: AppSizes.iconSm),
                      label: Text((_menuImageBytes != null || _menuImagePath != null) ? '변경' : '등록'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.lg,
                          vertical: AppSizes.md,
                        ),
                      ),
                    ),
                    if (_menuImageBytes != null || _menuImagePath != null) ...[
                      SizedBox(height: AppSizes.sm),
                      OutlinedButton.icon(
                        onPressed: _removeImage,
                        icon: Icon(MdiIcons.delete, size: AppSizes.iconSm),
                        label: const Text('삭제'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.lg,
                            vertical: AppSizes.md,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
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
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            
            // 메뉴명
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '메뉴명 *',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                TextFormField(
                  controller: _menuNameController,
                  decoration: InputDecoration(
                    hintText: '메뉴명을 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '메뉴명을 입력해주세요';
                    }
                    return null;
                  },
                ),
              ],
            ),
            
            SizedBox(height: AppSizes.md),
            
            // 가격
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '가격 *',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '가격을 입력해주세요',
                    suffixText: '원',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '가격을 입력해주세요';
                    }
                    if (int.tryParse(value) == null) {
                      return '올바른 가격을 입력해주세요';
                    }
                    return null;
                  },
                ),
              ],
            ),
            
            SizedBox(height: AppSizes.md),
            
            // 메뉴 설명
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '메뉴 설명',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: '메뉴에 대한 설명을 입력해주세요 (최대 500자)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppSizes.md),
            
            // 메뉴 그룹
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '메뉴 그룹 *',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                DropdownButtonFormField<String>(
                  value: _selectedGroupId,
                  decoration: InputDecoration(
                    hintText: '메뉴 그룹을 선택해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  items: _availableGroups.map((group) {
                    return DropdownMenuItem<String>(
                      value: group['id'],
                      child: Text(group['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGroupId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '메뉴 그룹을 선택해주세요';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '메뉴 옵션',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _showOptionSelectionDialog,
                  icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                  label: Text('옵션 불러오기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            
            if (_selectedOptions.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      MdiIcons.plusCircleOutline,
                      size: AppSizes.iconLg,
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      '옵션 불러오기를 통해 옵션을 추가해주세요',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _selectedOptions.map((option) => _buildOptionCard(option)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option['name'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  '최대 ${option['maxSelection']}개 선택',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedOptions.remove(option);
              });
            },
            icon: Icon(
              MdiIcons.close,
              color: AppColors.error,
              size: AppSizes.iconSm,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => context.pop(),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.xl,
              vertical: AppSizes.md,
            ),
          ),
          child: Text('취소'),
        ),
        SizedBox(width: AppSizes.md),
        ElevatedButton(
          onPressed: _saveMenu,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.xl,
              vertical: AppSizes.md,
            ),
          ),
          child: Text(widget.menuId != null ? '수정' : '등록'),
        ),
      ],
    );
  }

  void _selectImage() async {
    try {
      // 이미지 파일만 선택 가능하도록 제한
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowedExtensions: null,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // 파일 크기 체크 (10MB 제한)
        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('이미지 파일 크기는 10MB 이하여야 합니다.'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        // 파일 확장자 체크
        final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
        final extension = file.extension?.toLowerCase();
        if (extension == null || !allowedExtensions.contains(extension)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('지원하는 이미지 형식: JPG, PNG, GIF, WebP'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        setState(() {
          _menuImageBytes = file.bytes;
          _menuImageName = file.name;
          _menuImagePath = null; // 새로 선택한 경우 기존 경로 초기화
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('이미지가 선택되었습니다: ${file.name}'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 선택 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _menuImageBytes = null;
      _menuImageName = null;
      _menuImagePath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('이미지가 삭제되었습니다.'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showOptionSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('옵션 선택'),
          content: Container(
            width: double.maxFinite,
            height: 400.h,
            child: SingleChildScrollView(
              child: Column(
                children: _availableOptions.map((option) {
                  final isSelected = _selectedOptions.any((selected) => selected['id'] == option['id']);
                  return CheckboxListTile(
                    title: Text(option['name']),
                    subtitle: Text('최대 ${option['maxSelection']}개 선택'),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!isSelected) {
                            _selectedOptions.add(option);
                          }
                        } else {
                          _selectedOptions.removeWhere((selected) => selected['id'] == option['id']);
                        }
                      });
                      Navigator.of(context).pop();
                      _showOptionSelectionDialog(); // 다이얼로그 다시 열기
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('완료'),
            ),
          ],
        );
      },
    );
  }

  void _saveMenu() {
    if (_formKey.currentState!.validate()) {
      // 메뉴 저장 로직
      final menuData = {
        'name': _menuNameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'groupId': _selectedGroupId,
        'imageBytes': _menuImageBytes,
        'imageName': _menuImageName,
        'selectedOptions': _selectedOptions,
      };
      
      // TODO: 실제 API 호출로 메뉴 데이터 저장
      print('저장할 메뉴 데이터: $menuData');
      
      String message = widget.menuId != null ? '메뉴가 수정되었습니다.' : '메뉴가 등록되었습니다.';
      if (_menuImageName != null) {
        message += ' (이미지: $_menuImageName)';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    _menuNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
