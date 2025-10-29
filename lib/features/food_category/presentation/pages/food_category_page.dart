import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:html' as html;

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';

class FoodCategoryPage extends StatefulWidget {
  const FoodCategoryPage({super.key});

  @override
  State<FoodCategoryPage> createState() => _FoodCategoryPageState();
}

class _FoodCategoryPageState extends State<FoodCategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    // TODO: 실제 API 호출로 데이터 가져오기
    _categories = [
      {
        'id': '1',
        'name': '한식',
        'icon': 'rice',
        'order': 1,
        'isActive': true,
        'description': '한국 전통 음식',
        'itemCount': 245,
        'imageUrl': null,
      },
      {
        'id': '2',
        'name': '중식',
        'icon': 'noodles',
        'order': 2,
        'isActive': true,
        'description': '중국 음식',
        'itemCount': 189,
        'imageUrl': null,
      },
      {
        'id': '3',
        'name': '일식',
        'icon': 'fish',
        'order': 3,
        'isActive': true,
        'description': '일본 음식',
        'itemCount': 156,
        'imageUrl': null,
      },
      {
        'id': '4',
        'name': '양식',
        'icon': 'silverware-fork-knife',
        'order': 4,
        'isActive': true,
        'description': '서양 음식',
        'itemCount': 134,
        'imageUrl': null,
      },
      {
        'id': '5',
        'name': '치킨',
        'icon': 'food-drumstick',
        'order': 5,
        'isActive': true,
        'description': '치킨 전문',
        'itemCount': 98,
        'imageUrl': null,
      },
      {
        'id': '6',
        'name': '피자',
        'icon': 'pizza',
        'order': 6,
        'isActive': true,
        'description': '피자 전문',
        'itemCount': 87,
        'imageUrl': null,
      },
      {
        'id': '7',
        'name': '카페·디저트',
        'icon': 'coffee',
        'order': 7,
        'isActive': true,
        'description': '카페 및 디저트',
        'itemCount': 213,
        'imageUrl': null,
      },
      {
        'id': '8',
        'name': '분식',
        'icon': 'food',
        'order': 8,
        'isActive': false,
        'description': '분식 전문',
        'itemCount': 45,
        'imageUrl': null,
      },
    ];
    // 순서대로 정렬
    _categories.sort((a, b) => a['order'].compareTo(b['order']));
    _filteredCategories = _categories;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories.where((category) {
          return category['name']!.toLowerCase().contains(query.toLowerCase()) ||
                 category['description']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        onSave: (name, description, order, imageUrl) {
          setState(() {
            _categories.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'name': name,
              'icon': 'food',
              'order': order,
              'isActive': true,
              'description': description,
              'itemCount': 0,
              'imageUrl': imageUrl,
            });
            // 순서대로 재정렬
            _categories.sort((a, b) => a['order'].compareTo(b['order']));
            _filteredCategories = _categories;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('카테고리가 추가되었습니다.'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        category: category,
        onSave: (name, description, order, imageUrl) {
          setState(() {
            category['name'] = name;
            category['description'] = description;
            category['order'] = order;
            category['imageUrl'] = imageUrl;
            // 순서대로 재정렬
            _categories.sort((a, b) => a['order'].compareTo(b['order']));
            _filteredCategories = _categories;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('카테고리가 수정되었습니다.'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _toggleStatus(Map<String, dynamic> category) {
    setState(() {
      category['isActive'] = !category['isActive'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          category['isActive'] ? '카테고리가 활성화되었습니다.' : '카테고리가 비활성화되었습니다.',
        ),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: '/food-category',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppSizes.lg),
          _buildSearchBar(),
          SizedBox(height: AppSizes.lg),
          Expanded(
            child: _buildCategoryGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          '푸드 카테고리',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _showAddDialog,
          icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
          label: const Text('카테고리 추가'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: '카테고리명으로 검색',
                  prefixIcon: Icon(MdiIcons.magnify),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSizes.md),
            Text(
              '총 ${_filteredCategories.length}개',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    if (_filteredCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.foodOff,
              size: 64.r,
              color: Colors.grey[400],
            ),
            SizedBox(height: AppSizes.md),
            Text(
              '카테고리가 없습니다.',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(AppSizes.sm),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSizes.md,
        mainAxisSpacing: AppSizes.md,
        childAspectRatio: 1.2,
      ),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(_filteredCategories[index]);
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      child: InkWell(
        onTap: () => _showEditDialog(category),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 이미지 또는 아이콘
                  if (category['imageUrl'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        category['imageUrl']!,
                        width: 32.r,
                        height: 32.r,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            MdiIcons.food,
                            size: 32.r,
                            color: category['isActive'] ? AppColors.primary : Colors.grey,
                          );
                        },
                      ),
                    )
                  else
                    Icon(
                      MdiIcons.food,
                      size: 32.r,
                      color: category['isActive'] ? AppColors.primary : Colors.grey,
                    ),
                  SizedBox(width: 8.w),
                  // 순서 표시
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${category['order']}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(category);
                      } else if (value == 'toggle') {
                        _toggleStatus(category);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(MdiIcons.pencil, size: AppSizes.iconSm),
                            SizedBox(width: AppSizes.sm),
                            const Text('수정'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(
                          children: [
                            Icon(
                              category['isActive'] ? MdiIcons.eyeOff : MdiIcons.eye,
                              size: AppSizes.iconSm,
                            ),
                            SizedBox(width: AppSizes.sm),
                            Text(category['isActive'] ? '비활성화' : '활성화'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                category['name']!,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                category['description']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.xs,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: category['isActive']
                          ? AppColors.success.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Text(
                      category['isActive'] ? '활성' : '비활성',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: category['isActive'] ? AppColors.success : Colors.grey,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${category['itemCount']}개 매장',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  final Map<String, dynamic>? category;
  final Function(String name, String description, int order, String? imageUrl) onSave;

  const _CategoryDialog({
    this.category,
    required this.onSave,
  });

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _orderController;
  final _formKey = GlobalKey<FormState>();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?['name'] ?? '');
    _descriptionController = TextEditingController(text: widget.category?['description'] ?? '');
    _orderController = TextEditingController(text: (widget.category?['order'] ?? 1).toString());
    _imageUrl = widget.category?['imageUrl'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _imageUrl = reader.result as String?;
          });
        });
        
        // TODO: 실제 서버 업로드 시 바이트 데이터 필요하면 구현
        // final bytesReader = html.FileReader();
        // bytesReader.readAsArrayBuffer(file);
        // bytesReader.onLoadEnd.listen((event) {
        //   final bytes = bytesReader.result as Uint8List?;
        //   // 서버에 업로드
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.category == null ? '카테고리 추가' : '카테고리 수정',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 500.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리명
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '카테고리명',
                    hintText: '예: 한식, 중식, 일식',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '카테고리명을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.md),
                
                // 순서
                TextFormField(
                  controller: _orderController,
                  decoration: const InputDecoration(
                    labelText: '노출 순서',
                    hintText: '숫자로 입력 (낮을수록 먼저 표시)',
                    helperText: '앱에서 카테고리가 표시되는 순서입니다.',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '순서를 입력해주세요.';
                    }
                    if (int.tryParse(value) == null) {
                      return '숫자만 입력 가능합니다.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.md),
                
                // 설명
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: '설명',
                    hintText: '카테고리 설명을 입력하세요',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: AppSizes.lg),
                
                // 이미지 업로드
                Text(
                  '카테고리 이미지',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                
                // 이미지 미리보기 및 업로드 버튼
                Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    color: Colors.grey[50],
                  ),
                  child: _imageUrl != null
                      ? Stack(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                                child: Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _imageUrl = null;
                                  });
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                                tooltip: '이미지 제거',
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: _pickImage,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.imageOutline,
                                size: 48.r,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: AppSizes.sm),
                              Text(
                                '이미지를 선택하세요',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: AppSizes.xs),
                              Text(
                                'PNG, JPG, JPEG (최대 5MB)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                if (_imageUrl != null)
                  Padding(
                    padding: EdgeInsets.only(top: AppSizes.sm),
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(MdiIcons.imageEdit, size: AppSizes.iconSm),
                      label: const Text('이미지 변경'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text,
                _descriptionController.text,
                int.parse(_orderController.text),
                _imageUrl,
              );
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }
}

