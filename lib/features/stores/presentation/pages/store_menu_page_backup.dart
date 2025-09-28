import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/menu_group_model.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/models/option_group_model.dart';
import '../../data/models/option_item_model.dart';
import '../widgets/menu_group_add_dialog.dart';
import '../widgets/menu_group_edit_dialog.dart';
import '../widgets/option_group_add_dialog.dart';
import '../widgets/option_group_edit_dialog.dart';
import '../widgets/option_item_add_dialog.dart';
import 'menu_add_page.dart';

class StoreMenuPage extends StatefulWidget {
  final String storeId;
  final bool isRegisterMode;
  
  const StoreMenuPage({super.key, required this.storeId, this.isRegisterMode = false});

  @override
  State<StoreMenuPage> createState() => _StoreMenuPageState();
}

class _StoreMenuPageState extends State<StoreMenuPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isReorderMode = false;
  String _selectedStatusFilter = '전체'; // 상태 필터
  
  // 샘플 메뉴 그룹 데이터
  final List<Map<String, dynamic>> _menuGroups = [
    {
      'name': '피자',
      'description': '수제 도우로 만든 신선한 피자',
      'items': [
        {'name': '밤바피자', 'priceL': '24,900원', 'priceM': '22,900원', 'description': '[음식메뉴] 랩컨다이트피자 나주혁신', 'status': '판매중'},
        {'name': '페퍼로니 피자', 'priceL': '26,900원', 'priceM': '24,900원', 'description': '[음식메뉴] 클래식 페퍼로니 피자', 'status': '판매중'},
        {'name': '마르게리타 피자', 'priceL': '23,900원', 'priceM': '21,900원', 'description': '[음식메뉴] 신선한 바질과 모짜렐라 치즈', 'status': '판매중'},
      ]
    },
    {
      'name': '파스타',
      'description': '이탈리아 정통 파스타 요리',
      'items': [
        {'name': '까르보나라', 'priceL': '16,900원', 'priceM': '14,900원', 'description': '[음식메뉴] 크리미한 까르보나라', 'status': '판매중'},
        {'name': '아라비아따', 'priceL': '15,900원', 'priceM': '13,900원', 'description': '[음식메뉴] 매콤한 토마토 파스타', 'status': '판매중'},
      ]
    },
  ];
  
  // 샘플 옵션 그룹 데이터
  final List<Map<String, dynamic>> _optionGroups = [
    {
      'id': '1',
      'name': '포토리뷰&할인 이벤트',
      'maxSelection': 1,
      'description': '리뷰 작성 시 혜택을 받을 수 있는 이벤트 옵션',
      'items': [
        {'id': '1-1', 'name': '포토리뷰: X 이벤트 안함께요', 'price': 0},
        {'id': '1-2', 'name': '포토리뷰: 갈릭딥핑 2개 (5점 후기 부탁드려요)', 'price': 0},
      ]
    },
    {
      'id': '2',
      'name': '사이드 메뉴',
      'maxSelection': 3,
      'description': '메인 메뉴와 함께 즐길 수 있는 사이드 메뉴',
      'items': [
        {'id': '2-1', 'name': '갈릭 브레드', 'price': 3000},
        {'id': '2-2', 'name': '치즈 스틱', 'price': 4500},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: '/store/${widget.storeId}/menu',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppSizes.lg),
          _buildTabBar(),
          SizedBox(height: AppSizes.lg),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMenuTab(),
                _buildOptionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          '메뉴 관리',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (_tabController.index == 0) ...[
          OutlinedButton.icon(
            onPressed: _toggleReorderMode,
            icon: Icon(_isReorderMode ? MdiIcons.check : MdiIcons.reorderHorizontal),
            label: Text(_isReorderMode ? '정렬 완료' : '순서 변경'),
          ),
          SizedBox(width: AppSizes.md),
          ElevatedButton.icon(
            onPressed: _showMenuGroupAddDialog,
            icon: Icon(MdiIcons.plus),
            label: Text('메뉴 그룹 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: _showOptionGroupAddDialog,
            icon: Icon(MdiIcons.plus),
            label: Text('옵션 그룹 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: '메뉴 관리'),
          Tab(text: '옵션 관리'),
        ],
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildMenuTab() {
    return Column(
      children: [
        _buildStatusFilter(),
        SizedBox(height: AppSizes.lg),
        Expanded(
          child: ListView.builder(
            itemCount: _menuGroups.length,
            itemBuilder: (context, index) {
              return _buildMenuGroupCard(_menuGroups[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsTab() {
    return ListView.builder(
      itemCount: _optionGroups.length,
      itemBuilder: (context, index) {
        return _buildOptionGroupCard(_optionGroups[index]);
      },
    );
  }

  Widget _buildMenuGroupCard(Map<String, dynamic> group, int groupIndex) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.lg),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group['name'],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (group['description'] != null) ...[
                        SizedBox(height: AppSizes.xs),
                        Text(
                          group['description'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _navigateToMenuAdd(group['name']),
                      icon: Icon(MdiIcons.plus, color: AppColors.primary),
                      tooltip: '메뉴 추가',
                    ),
                    PopupMenuButton(
                      icon: Icon(MdiIcons.dotsVertical),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(MdiIcons.pencil, size: 16),
                              SizedBox(width: 8),
                              Text('그룹 수정'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(MdiIcons.delete, size: 16, color: AppColors.error),
                              SizedBox(width: 8),
                              Text('그룹 삭제', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) => _handleGroupAction(value, groupIndex),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            ...group['items'].map<Widget>((item) {
              return _buildMenuItemCard(item, groupIndex, group['items'].indexOf(item));
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item, int groupIndex, int itemIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
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
                  item['name'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (item['description'] != null) ...[
                  SizedBox(height: AppSizes.xs),
                  Text(
                    item['description'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    Text(
                      'L: ${item['priceL']}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    Text(
                      'M: ${item['priceM']}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
                decoration: BoxDecoration(
                  color: _getStatusColor(item['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Text(
                  item['status'] ?? '판매중',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _getStatusColor(item['status']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.sm),
              PopupMenuButton(
                icon: Icon(MdiIcons.dotsVertical, size: 20),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(MdiIcons.pencil, size: 16),
                        SizedBox(width: 8),
                        Text('수정'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(MdiIcons.delete, size: 16, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('삭제', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) => _handleMenuItemAction(value, groupIndex, itemIndex),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionGroupCard(Map<String, dynamic> group) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.lg),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group['name'],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        '선택 최대 ${group['maxSelection']}개',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showOptionItemAddDialog(group),
                      icon: Icon(MdiIcons.plus, color: AppColors.primary),
                      tooltip: '옵션 추가',
                    ),
                    PopupMenuButton(
                      icon: Icon(MdiIcons.dotsVertical),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(MdiIcons.pencil, size: 16),
                              SizedBox(width: 8),
                              Text('그룹 수정'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(MdiIcons.delete, size: 16, color: AppColors.error),
                              SizedBox(width: 8),
                              Text('그룹 삭제', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) => _handleOptionGroupAction(value, _optionGroups.indexOf(group)),
                    ),
                  ],
                ),
              ],
            ),
            if (group['description'] != null) ...[
              SizedBox(height: AppSizes.sm),
              Text(
                group['description'],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            SizedBox(height: AppSizes.md),
            ...group['items'].map<Widget>((item) {
              return _buildOptionItemCard(item, group);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItemCard(Map<String, dynamic> item, Map<String, dynamic> group) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
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
                  item['name'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  item['price'] == 0 ? '무료' : '+${_formatNumber(item['price'])}원',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: item['price'] == 0 ? AppColors.success : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(MdiIcons.dotsVertical, size: 20),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(MdiIcons.pencil, size: 16),
                    SizedBox(width: 8),
                    Text('수정'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(MdiIcons.delete, size: 16, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('삭제', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
            onSelected: (value) => _handleOptionItemAction(value, group, item),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    final statusOptions = ['전체', '판매중', '오늘만 품절', '메뉴 숨김'];
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(MdiIcons.filter, size: AppSizes.iconSm, color: AppColors.primary),
                SizedBox(width: AppSizes.sm),
                Text(
                  '상태별 필터',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: statusOptions.map((status) {
                final isSelected = _selectedStatusFilter == status;
                final count = _getMenuCountByStatus(status);
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: AppSizes.xs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.xs,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter = status;
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.grey[100],
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case '판매중':
        return AppColors.success;
      case '오늘만 품절':
        return AppColors.warning;
      case '메뉴 숨김':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  int _getMenuCountByStatus(String status) {
    if (status == '전체') {
      return _menuGroups.fold<int>(0, (total, group) {
        return total + (group['items'] as List).length;
      });
    }
    
    return _menuGroups.fold<int>(0, (total, group) {
      final items = group['items'] as List;
      final count = items.where((item) {
        final itemStatus = item['status'] ?? '판매중';
        return itemStatus == status;
      }).length;
      return total + count;
    });
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _toggleReorderMode() {
    setState(() {
      _isReorderMode = !_isReorderMode;
    });
  }

  void _navigateToMenuAdd(String groupName) {
    context.go('/stores/${widget.storeId}/menu/add?groupId=$groupName');
  }

  void _handleGroupAction(String action, int groupIndex) {
    switch (action) {
      case 'edit':
        // 그룹 수정 로직
        break;
      case 'delete':
        // 그룹 삭제 로직
        break;
    }
  }

  void _handleMenuItemAction(String action, int groupIndex, int itemIndex) {
    switch (action) {
      case 'edit':
        // 메뉴 아이템 수정 로직
        break;
      case 'delete':
        // 메뉴 아이템 삭제 로직
        break;
    }
  }

  void _handleOptionGroupAction(String action, int groupIndex) {
    switch (action) {
      case 'edit':
        // 옵션 그룹 수정 로직
        break;
      case 'delete':
        // 옵션 그룹 삭제 로직
        break;
    }
  }

  void _handleOptionItemAction(String action, Map<String, dynamic> group, Map<String, dynamic> item) {
    switch (action) {
      case 'edit':
        // 옵션 아이템 수정 로직
        break;
      case 'delete':
        // 옵션 아이템 삭제 로직
        break;
    }
  }

  void _showMenuGroupAddDialog() {
    showDialog(
      context: context,
      builder: (context) => MenuGroupAddDialog(
        onAdd: (String name, String description) {
          setState(() {
            _menuGroups.add({
              'name': name,
              'description': description,
              'items': [],
            });
          });
        },
      ),
    );
  }

  void _showOptionGroupAddDialog() {
    showDialog(
      context: context,
      builder: (context) => OptionGroupAddDialog(
        onAdd: (String name, String description, int maxSelection) {
          setState(() {
            _optionGroups.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'name': name,
              'description': description,
              'maxSelection': maxSelection,
              'items': [],
            });
          });
        },
      ),
    );
  }

  void _showOptionItemAddDialog(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) => OptionItemAddDialog(
        groupName: group['name'],
        onAdd: (String name, int price) {
          setState(() {
            final groupIndex = _optionGroups.indexWhere((g) => g['id'] == group['id']);
            if (groupIndex != -1) {
              List<Map<String, dynamic>> items = List.from(_optionGroups[groupIndex]['items']);
              items.add({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'name': name,
                'price': price,
              });
              _optionGroups[groupIndex]['items'] = items;
            }
          });
        },
      ),
    );
  }
}
