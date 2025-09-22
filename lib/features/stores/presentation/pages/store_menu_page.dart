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
import '../widgets/option_group_add_dialog.dart';
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
  
  // 샘플 메뉴 그룹 데이터
  final List<Map<String, dynamic>> _menuGroups = [
    {
      'name': '피자',
      'items': [
        {'name': '밤바피자', 'priceL': '24,900원', 'priceM': '22,900원', 'description': '[음식메뉴] 랩컨다이트피자 나주혁신'},
        {'name': '페퍼로니 피자', 'priceL': '26,900원', 'priceM': '24,900원', 'description': '[음식메뉴] 클래식 페퍼로니 피자'},
      ]
    },
    {
      'name': '파스타',
      'items': [
        {'name': '크림 파스타', 'priceL': '16,900원', 'priceM': '14,900원', 'description': '[음식메뉴] 부드러운 크림 파스타'},
        {'name': '토마토 파스타', 'priceL': '15,900원', 'priceM': '13,900원', 'description': '[음식메뉴] 신선한 토마토 파스타'},
      ]
    },
    {
      'name': '치킨',
      'items': [
        {'name': '후라이드 치킨', 'priceL': '19,900원', 'priceM': '17,900원', 'description': '[음식메뉴] 바삭한 후라이드 치킨'},
        {'name': '양념 치킨', 'priceL': '21,900원', 'priceM': '19,900원', 'description': '[음식메뉴] 달콤매콤 양념 치킨'},
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
        {'id': '1-3', 'name': '포토리뷰: 모짜렐라 100g (5점 후기 부탁드려요)', 'price': 0},
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
        {'id': '2-3', 'name': '감자튀김', 'price': 2500},
      ]
    },
    {
      'id': '3',
      'name': '음료',
      'maxSelection': 2,
      'description': '식사와 함께 마실 수 있는 음료',
      'items': [
        {'id': '3-1', 'name': '콜라', 'price': 2000},
        {'id': '3-2', 'name': '사이다', 'price': 2000},
        {'id': '3-3', 'name': '오렌지 주스', 'price': 3000},
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
      currentRoute: RouteNames.store,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.md),
            _buildTabBar(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMenuManagementTab(),
                  _buildOptionManagementTab(),
                ],
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
          '매장 메뉴 관리',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Text(
              '메뉴 관리',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Text(
              '옵션 관리',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildMenuManagementTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 메뉴 그룹 추가 버튼
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '메뉴 그룹 관리',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showMenuGroupAddDialog,
                    icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                    label: Text('메뉴 그룹 추가'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.md),
          // 메뉴 그룹 리스트
          ...List.generate(_menuGroups.length, (index) {
            final group = _menuGroups[index];
            return Column(
              children: [
                _buildMenuGroupCard(group),
                SizedBox(height: AppSizes.md),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildMenuGroupCard(Map<String, dynamic> group) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      group['name'],
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    PopupMenuButton(
                      icon: Icon(MdiIcons.dotsVertical, color: AppColors.textSecondary),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(MdiIcons.pencil, size: AppSizes.iconSm),
                              SizedBox(width: AppSizes.xs),
                              Text('그룹 수정'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(MdiIcons.delete, size: AppSizes.iconSm, color: AppColors.error),
                              SizedBox(width: AppSizes.xs),
                              Text('그룹 삭제', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => _navigateToMenuAdd(group['name']),
                  icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                  label: Text('메뉴 추가'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            ...List.generate(group['items'].length, (index) {
              final item = group['items'][index];
              return Column(
                children: [
                  _buildMenuItemCard(item),
                  if (index < group['items'].length - 1) SizedBox(height: AppSizes.sm),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: Icon(
              MdiIcons.imageOffOutline,
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    Text(
                      'L: ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.info,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item['priceL'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.info,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    Text(
                      'M: ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      item['priceM'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(MdiIcons.dotsVertical, color: AppColors.textSecondary),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(MdiIcons.pencil, size: AppSizes.iconSm),
                    SizedBox(width: AppSizes.xs),
                    Text('수정'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(MdiIcons.delete, size: AppSizes.iconSm, color: AppColors.error),
                    SizedBox(width: AppSizes.xs),
                    Text('삭제', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionManagementTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 옵션 그룹 추가 버튼
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '옵션 그룹 관리',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showOptionGroupAddDialog,
                    icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                    label: Text('옵션 그룹 추가'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.md),
          // 옵션 그룹 리스트
          ...List.generate(_optionGroups.length, (index) {
            final group = _optionGroups[index];
            return Column(
              children: [
                _buildOptionGroupCard(group),
                SizedBox(height: AppSizes.md),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildOptionGroupCard(Map<String, dynamic> group) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
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
                    SizedBox(width: AppSizes.sm),
                    PopupMenuButton(
                      icon: Icon(MdiIcons.dotsVertical, color: AppColors.textSecondary),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(MdiIcons.pencil, size: AppSizes.iconSm),
                              SizedBox(width: AppSizes.xs),
                              Text('그룹 수정'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(MdiIcons.delete, size: AppSizes.iconSm, color: AppColors.error),
                              SizedBox(width: AppSizes.xs),
                              Text('그룹 삭제', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => _showOptionItemAddDialog(group),
                  icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                  label: Text('옵션 추가'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: BorderSide(color: AppColors.secondary),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            ...List.generate(group['items'].length, (index) {
              final item = group['items'][index];
              return Column(
                children: [
                  _buildOptionItemCard(item),
                  if (index < group['items'].length - 1) SizedBox(height: AppSizes.sm),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItemCard(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(AppSizes.sm),
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
                  item['name'],
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  item['price'] == 0 ? '무료' : '${item['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: item['price'] == 0 ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(MdiIcons.dotsVertical, color: AppColors.textSecondary),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(MdiIcons.pencil, size: AppSizes.iconSm),
                    SizedBox(width: AppSizes.xs),
                    Text('수정'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(MdiIcons.delete, size: AppSizes.iconSm, color: AppColors.error),
                    SizedBox(width: AppSizes.xs),
                    Text('삭제', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMenuGroupAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MenuGroupAddDialog(
          onAdd: (String name, String description) {
            setState(() {
              _menuGroups.add({
                'name': name,
                'description': description,
                'items': [],
              });
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('메뉴 그룹 "$name"이 추가되었습니다.'),
                backgroundColor: AppColors.success,
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToMenuAdd(String groupName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuAddPage(
          storeId: widget.storeId,
          groupId: groupName,
        ),
      ),
    );
  }

  void _showOptionGroupAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OptionGroupAddDialog(
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
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('옵션 그룹 "$name"이 추가되었습니다.'),
                backgroundColor: AppColors.success,
              ),
            );
          },
        );
      },
    );
  }

  void _showOptionItemAddDialog(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OptionItemAddDialog(
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
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('옵션 아이템 "$name"이 "${group['name']}" 그룹에 추가되었습니다.'),
                backgroundColor: AppColors.success,
              ),
            );
          },
        );
      },
    );
  }
}
