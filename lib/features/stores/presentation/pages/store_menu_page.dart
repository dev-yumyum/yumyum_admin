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
        {'name': '콰트로 치즈 피자', 'priceL': '28,900원', 'priceM': '26,900원', 'description': '[음식메뉴] 4가지 치즈의 진한 맛', 'status': '판매중'},
        {'name': '불고기 피자', 'priceL': '27,900원', 'priceM': '25,900원', 'description': '[음식메뉴] 한국식 불고기가 올라간 피자', 'status': '판매중'},
        {'name': '하와이안 피자', 'priceL': '25,900원', 'priceM': '23,900원', 'description': '[음식메뉴] 파인애플과 햄의 조화', 'status': '오늘만 품절'},
      ]
    },
    {
      'name': '파스타',
      'description': '이탈리아 정통 파스타 요리',
      'items': [
        {'name': '크림 파스타', 'priceL': '16,900원', 'priceM': '14,900원', 'description': '[음식메뉴] 부드러운 크림 파스타', 'status': '판매중'},
        {'name': '토마토 파스타', 'priceL': '15,900원', 'priceM': '13,900원', 'description': '[음식메뉴] 신선한 토마토 파스타', 'status': '판매중'},
        {'name': '알리오 올리오', 'priceL': '14,900원', 'priceM': '12,900원', 'description': '[음식메뉴] 마늘과 올리브오일의 심플한 맛', 'status': '판매중'},
        {'name': '까르보나라', 'priceL': '17,900원', 'priceM': '15,900원', 'description': '[음식메뉴] 진짜 이탈리아식 까르보나라', 'status': '판매중'},
        {'name': '볼로네제', 'priceL': '18,900원', 'priceM': '16,900원', 'description': '[음식메뉴] 정통 이탈리아 미트소스', 'status': '판매중'},
        {'name': '페스토 파스타', 'priceL': '16,900원', 'priceM': '14,900원', 'description': '[음식메뉴] 바질 페스토의 향긋한 맛', 'status': '판매중'},
      ]
    },
    {
      'name': '치킨',
      'description': '바삭하고 맛있는 치킨 요리',
      'items': [
        {'name': '후라이드 치킨', 'priceL': '19,900원', 'priceM': '17,900원', 'description': '[음식메뉴] 바삭한 후라이드 치킨', 'status': '판매중'},
        {'name': '양념 치킨', 'priceL': '21,900원', 'priceM': '19,900원', 'description': '[음식메뉴] 달콤매콤 양념 치킨', 'status': '판매중'},
        {'name': '간장 치킨', 'priceL': '20,900원', 'priceM': '18,900원', 'description': '[음식메뉴] 고소한 간장 양념 치킨', 'status': '판매중'},
        {'name': '허니 머스타드 치킨', 'priceL': '22,900원', 'priceM': '20,900원', 'description': '[음식메뉴] 달콤한 허니머스타드 소스', 'status': '판매중'},
        {'name': '마늘 치킨', 'priceL': '21,900원', 'priceM': '19,900원', 'description': '[음식메뉴] 마늘의 진한 풍미', 'status': '판매중'},
        {'name': '매운 치킨', 'priceL': '22,900원', 'priceM': '20,900원', 'description': '[음식메뉴] 불타는 매운맛', 'status': '판매중'},
      ]
    },
    {
      'name': '한식',
      'description': '정통 한국 요리',
      'items': [
        {'name': '김치찌개', 'priceL': '8,900원', 'priceM': '7,900원', 'description': '[음식메뉴] 진짜 맛있는 김치찌개', 'status': '판매중'},
        {'name': '된장찌개', 'priceL': '8,900원', 'priceM': '7,900원', 'description': '[음식메뉴] 구수한 된장찌개', 'status': '판매중'},
        {'name': '불고기', 'priceL': '15,900원', 'priceM': '13,900원', 'description': '[음식메뉴] 양념에 재운 불고기', 'status': '판매중'},
        {'name': '비빔밥', 'priceL': '9,900원', 'priceM': '8,900원', 'description': '[음식메뉴] 영양만점 비빔밥', 'status': '판매중'},
        {'name': '냉면', 'priceL': '11,900원', 'priceM': '10,900원', 'description': '[음식메뉴] 시원한 물냉면/비빔냉면', 'status': '판매중'},
      ]
    },
    {
      'name': '중식',
      'description': '정통 중국 요리',
      'items': [
        {'name': '짜장면', 'priceL': '7,900원', 'priceM': '6,900원', 'description': '[음식메뉴] 정통 짜장면', 'status': '판매중'},
        {'name': '짬뽕', 'priceL': '8,900원', 'priceM': '7,900원', 'description': '[음식메뉴] 얼큰한 짬뽕', 'status': '판매중'},
        {'name': '탕수육', 'priceL': '22,900원', 'priceM': '19,900원', 'description': '[음식메뉴] 바삭한 탕수육', 'status': '판매중'},
        {'name': '볶음밥', 'priceL': '8,900원', 'priceM': '7,900원', 'description': '[음식메뉴] 고슬고슬 볶음밥', 'status': '판매중'},
        {'name': '마파두부', 'priceL': '12,900원', 'priceM': '10,900원', 'description': '[음식메뉴] 마라맛 마파두부', 'status': '판매중'},
      ]
    },
    {
      'name': '일식',
      'description': '신선한 일본 요리',
      'items': [
        {'name': '초밥 세트', 'priceL': '25,900원', 'priceM': '22,900원', 'description': '[음식메뉴] 신선한 초밥 10개 세트', 'status': '판매중'},
        {'name': '연어 사시미', 'priceL': '18,900원', 'priceM': '15,900원', 'description': '[음식메뉴] 노르웨이산 연어 사시미', 'status': '판매중'},
        {'name': '장어 구이', 'priceL': '28,900원', 'priceM': '25,900원', 'description': '[음식메뉴] 부드러운 장어 구이', 'status': '판매중'},
        {'name': '라멘', 'priceL': '12,900원', 'priceM': '10,900원', 'description': '[음식메뉴] 진짜 일본식 라멘', 'status': '판매중'},
        {'name': '돈까스', 'priceL': '14,900원', 'priceM': '12,900원', 'description': '[음식메뉴] 바삭한 돈까스', 'status': '판매중'},
      ]
    },
    {
      'name': '음료 & 디저트',
      'description': '시원한 음료와 달콤한 디저트',
      'items': [
        {'name': '아메리카노', 'priceL': '4,500원', 'priceM': '3,500원', 'description': '[음료] 깊고 진한 아메리카노', 'status': '판매중'},
        {'name': '카페라떼', 'priceL': '5,500원', 'priceM': '4,500원', 'description': '[음료] 부드러운 카페라떼', 'status': '판매중'},
        {'name': '아이스크림', 'priceL': '6,900원', 'priceM': '5,900원', 'description': '[디저트] 바닐라/초콜릿/딸기', 'status': '판매중'},
        {'name': '케이크', 'priceL': '8,900원', 'priceM': '7,900원', 'description': '[디저트] 수제 초콜릿 케이크', 'status': '판매중'},
        {'name': '생과일 주스', 'priceL': '6,500원', 'priceM': '5,500원', 'description': '[음료] 신선한 과일 주스', 'status': '판매중'},
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
        {'id': '1-4', 'name': '포토리뷰: 콜라 1캔 (5점 후기 부탁드려요)', 'price': 0},
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
        {'id': '2-4', 'name': '양파링', 'price': 3500},
        {'id': '2-5', 'name': '치킨 너겟', 'price': 5000},
        {'id': '2-6', 'name': '모짜렐라 스틱', 'price': 4000},
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
        {'id': '3-4', 'name': '아이스티', 'price': 2500},
        {'id': '3-5', 'name': '생수', 'price': 1500},
        {'id': '3-6', 'name': '탄산수', 'price': 2000},
      ]
    },
    {
      'id': '4',
      'name': '매운맛 선택',
      'maxSelection': 1,
      'description': '요리의 매운 정도를 선택해주세요',
      'items': [
        {'id': '4-1', 'name': '순한맛', 'price': 0},
        {'id': '4-2', 'name': '보통맛', 'price': 0},
        {'id': '4-3', 'name': '매운맛', 'price': 0},
        {'id': '4-4', 'name': '아주 매운맛', 'price': 500},
        {'id': '4-5', 'name': '극도로 매운맛', 'price': 1000},
      ]
    },
    {
      'id': '5',
      'name': '토핑 추가',
      'maxSelection': 5,
      'description': '피자나 파스타에 추가할 토핑을 선택해주세요',
      'items': [
        {'id': '5-1', 'name': '체다 치즈', 'price': 2000},
        {'id': '5-2', 'name': '모짜렐라 치즈', 'price': 2500},
        {'id': '5-3', 'name': '페퍼로니', 'price': 3000},
        {'id': '5-4', 'name': '베이컨', 'price': 3500},
        {'id': '5-5', 'name': '불고기', 'price': 4000},
        {'id': '5-6', 'name': '새우', 'price': 4500},
        {'id': '5-7', 'name': '파인애플', 'price': 1500},
        {'id': '5-8', 'name': '양파', 'price': 1000},
        {'id': '5-9', 'name': '피망', 'price': 1000},
        {'id': '5-10', 'name': '버섯', 'price': 1500},
      ]
    },
    {
      'id': '6',
      'name': '면 종류 선택',
      'maxSelection': 1,
      'description': '파스타 면의 종류를 선택해주세요',
      'items': [
        {'id': '6-1', 'name': '스파게티', 'price': 0},
        {'id': '6-2', 'name': '펜네', 'price': 0},
        {'id': '6-3', 'name': '푸실리', 'price': 0},
        {'id': '6-4', 'name': '페투치니', 'price': 500},
        {'id': '6-5', 'name': '링귀니', 'price': 500},
      ]
    },
    {
      'id': '7',
      'name': '밥 종류 선택',
      'maxSelection': 1,
      'description': '한식 메뉴의 밥 종류를 선택해주세요',
      'items': [
        {'id': '7-1', 'name': '백미밥', 'price': 0},
        {'id': '7-2', 'name': '현미밥', 'price': 500},
        {'id': '7-3', 'name': '잡곡밥', 'price': 1000},
        {'id': '7-4', 'name': '밥 없음', 'price': -1000},
      ]
    },
    {
      'id': '8',
      'name': '포장 옵션',
      'maxSelection': 1,
      'description': '포장 방식을 선택해주세요',
      'items': [
        {'id': '8-1', 'name': '일반 포장', 'price': 0},
        {'id': '8-2', 'name': '친환경 포장', 'price': 500},
        {'id': '8-3', 'name': '보온 포장', 'price': 1000},
        {'id': '8-4', 'name': '선물 포장', 'price': 1500},
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
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isReorderMode = !_isReorderMode;
                          });
                        },
                        icon: Icon(
                          _isReorderMode ? MdiIcons.check : MdiIcons.dragVariant, 
                          size: AppSizes.iconSm,
                        ),
                        label: Text(_isReorderMode ? '완료' : '순서변경'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _isReorderMode ? AppColors.success : AppColors.info,
                          side: BorderSide(color: _isReorderMode ? AppColors.success : AppColors.info),
                        ),
                      ),
                      SizedBox(width: AppSizes.md),
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
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.md),
          // 메뉴 상태 필터
          _buildStatusFilter(),
          SizedBox(height: AppSizes.md),
          // 메뉴 그룹 리스트
          if (_isReorderMode)
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _menuGroups.length,
              onReorder: _onGroupReorder,
              itemBuilder: (context, index) {
                final group = _menuGroups[index];
                return Padding(
                  key: ValueKey('group_$index'),
                  padding: EdgeInsets.only(bottom: AppSizes.md),
                  child: _buildMenuGroupCard(group, index),
                );
              },
            )
          else
            ...List.generate(_menuGroups.length, (index) {
              final group = _menuGroups[index];
              return Column(
                children: [
                  _buildMenuGroupCard(group, index),
                  SizedBox(height: AppSizes.md),
                ],
              );
            }),
        ],
      ),
    );
  }
  
  Widget _buildMenuGroupCard(Map<String, dynamic> group, int groupIndex) {
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
                    if (_isReorderMode)
                      Padding(
                        padding: EdgeInsets.only(right: AppSizes.sm),
                        child: Icon(
                          MdiIcons.dragHorizontal,
                          color: AppColors.textSecondary,
                          size: AppSizes.iconMd,
                        ),
                      ),
                    Text(
                      group['name'],
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    if (!_isReorderMode)
                      PopupMenuButton(
                        icon: Icon(MdiIcons.dotsVertical, color: AppColors.textSecondary),
                        onSelected: (value) => _handleGroupAction(value, groupIndex),
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
                if (!_isReorderMode)
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
            if (_isReorderMode)
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _getFilteredItems(group['items']).length,
                onReorder: (oldIndex, newIndex) => _onMenuItemReorder(groupIndex, oldIndex, newIndex),
                itemBuilder: (context, index) {
                  final filteredItems = _getFilteredItems(group['items']);
                  final item = filteredItems[index];
                  final originalIndex = group['items'].indexOf(item);
                  return Padding(
                    key: ValueKey('menu_${groupIndex}_$originalIndex'),
                    padding: EdgeInsets.only(bottom: index < filteredItems.length - 1 ? AppSizes.sm : 0),
                    child: _buildMenuItemCard(item, groupIndex, originalIndex),
                  );
                },
              )
            else
              if (_getFilteredItems(group['items']).isEmpty)
                Padding(
                  padding: EdgeInsets.all(AppSizes.lg),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          MdiIcons.filterOff,
                          size: 40.r,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: AppSizes.sm),
                        Text(
                          '선택한 상태의 메뉴가 없습니다.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._getFilteredItems(group['items']).asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final originalIndex = group['items'].indexOf(item);
                  return Column(
                    children: [
                      _buildMenuItemCard(item, groupIndex, originalIndex),
                      if (index < _getFilteredItems(group['items']).length - 1) SizedBox(height: AppSizes.sm),
                    ],
                  );
                }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item, int groupIndex, int itemIndex) {
    final status = item['status'] ?? '판매중';
    Color statusColor = AppColors.success;
    Color cardColor = Colors.grey[50]!;
    
    switch (status) {
      case '오늘만 품절':
        statusColor = AppColors.warning;
        cardColor = Colors.orange[50]!;
        break;
      case '메뉴 숨김':
        statusColor = AppColors.inactive;
        cardColor = Colors.grey[100]!;
        break;
      default:
        statusColor = AppColors.success;
        cardColor = Colors.grey[50]!;
    }
    
    return Container(
      padding: EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: statusColor.withOpacity(0.3)),
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
                Row(
                  children: [
                    Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: AppSizes.sm),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.xs,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
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
          Row(
            children: [
              if (_isReorderMode)
                Padding(
                  padding: EdgeInsets.only(right: AppSizes.sm),
                  child: Icon(
                    MdiIcons.dragVertical,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconMd,
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
                  if (_isReorderMode)
                    PopupMenuItem(
                      value: 'move',
                      child: Row(
                        children: [
                          Icon(MdiIcons.folderMove, size: AppSizes.iconSm, color: AppColors.primary),
                          SizedBox(width: AppSizes.xs),
                          Text('다른 그룹으로 이동'),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'status',
                    child: Row(
                      children: [
                        Icon(MdiIcons.checkCircle, size: AppSizes.iconSm, color: AppColors.info),
                        SizedBox(width: AppSizes.xs),
                        Text('상태 변경'),
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
                onSelected: (value) => _handleMenuItemAction(value, groupIndex, itemIndex),
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
                      onSelected: (value) => _handleOptionGroupAction(value, _optionGroups.indexOf(group)),
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
                  _formatPrice(item['price']),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: _getPriceColor(item['price']),
                  ),
                ),
              ],
            ),
          ),
          // 수정/삭제 버튼 추가
          PopupMenuButton(
            icon: Icon(MdiIcons.dotsVertical, color: AppColors.textSecondary, size: AppSizes.iconSm),
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
            onSelected: (value) => _handleOptionItemAction(value, item),
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

  String _formatPrice(int price) {
    if (price == 0) {
      return '무료';
    } else if (price < 0) {
      return '-${(-price).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
    } else {
      return '+${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
    }
  }

  Color _getPriceColor(int price) {
    if (price == 0) {
      return AppColors.success;
    } else if (price < 0) {
      return AppColors.info; // 할인은 파란색
    } else {
      return AppColors.textSecondary; // 추가 요금은 회색
    }
  }

  // 그룹 순서 변경
  void _onGroupReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _menuGroups.removeAt(oldIndex);
      _menuGroups.insert(newIndex, item);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('그룹 순서가 변경되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 메뉴 아이템 순서 변경
  void _onMenuItemReorder(int groupIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final List<Map<String, dynamic>> items = List.from(_menuGroups[groupIndex]['items']);
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
      _menuGroups[groupIndex]['items'] = items;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('메뉴 순서가 변경되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 메뉴 아이템 액션 처리
  void _handleMenuItemAction(String action, int groupIndex, int itemIndex) {
    switch (action) {
      case 'edit':
        _showMenuEditDialog(groupIndex, itemIndex);
        break;
      case 'move':
        _showMoveMenuDialog(groupIndex, itemIndex);
        break;
      case 'status':
        _showStatusChangeDialog(groupIndex, itemIndex);
        break;
      case 'delete':
        _deleteMenuItem(groupIndex, itemIndex);
        break;
    }
  }

  // 다른 그룹으로 이동 다이얼로그
  void _showMoveMenuDialog(int fromGroupIndex, int itemIndex) {
    final item = _menuGroups[fromGroupIndex]['items'][itemIndex];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.folderMove, color: AppColors.primary),
              SizedBox(width: AppSizes.sm),
              Text(
                '메뉴 이동',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${item['name']}"을(를) 다른 그룹으로 이동하시겠습니까?',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: AppSizes.lg),
              Text(
                '이동할 그룹을 선택하세요:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSizes.md),
              Container(
                height: 200.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: ListView.builder(
                  itemCount: _menuGroups.length,
                  itemBuilder: (context, index) {
                    if (index == fromGroupIndex) return const SizedBox.shrink();
                    
                    final group = _menuGroups[index];
                    return ListTile(
                      leading: Icon(MdiIcons.folder, color: AppColors.primary),
                      title: Text(
                        group['name'],
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      subtitle: Text(
                        group['description'],
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      onTap: () {
                        _moveMenuItem(fromGroupIndex, itemIndex, index);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  // 메뉴 아이템을 다른 그룹으로 이동
  void _moveMenuItem(int fromGroupIndex, int itemIndex, int toGroupIndex) {
    setState(() {
      final item = _menuGroups[fromGroupIndex]['items'].removeAt(itemIndex);
      _menuGroups[toGroupIndex]['items'].add(item);
    });
    
    final fromGroupName = _menuGroups[fromGroupIndex]['name'];
    final toGroupName = _menuGroups[toGroupIndex]['name'];
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('메뉴가 "$fromGroupName"에서 "$toGroupName"으로 이동되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 메뉴 아이템 삭제
  void _deleteMenuItem(int groupIndex, int itemIndex) {
    final item = _menuGroups[groupIndex]['items'][itemIndex];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.delete, color: AppColors.error),
              SizedBox(width: AppSizes.sm),
              Text(
                '메뉴 삭제',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          content: Text(
            '"${item['name']}"을(를) 삭제하시겠습니까?\n삭제된 메뉴는 복구할 수 없습니다.',
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _menuGroups[groupIndex]['items'].removeAt(itemIndex);
                });
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('메뉴 "${item['name']}"이(가) 삭제되었습니다.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text(
                '삭제',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  // 메뉴 수정 다이얼로그
  void _showMenuEditDialog(int groupIndex, int itemIndex) {
    final item = _menuGroups[groupIndex]['items'][itemIndex];
    final nameController = TextEditingController(text: item['name']);
    final descriptionController = TextEditingController(text: item['description']);
    final priceLController = TextEditingController(text: item['priceL'].replaceAll(RegExp(r'[^\d]'), ''));
    final priceMController = TextEditingController(text: item['priceM'].replaceAll(RegExp(r'[^\d]'), ''));
    
    // 현재 메뉴가 속한 그룹 찾기
    String selectedGroupId = _menuGroups[groupIndex]['name'];
    String? menuImagePath = item['imageUrl']; // 기존 이미지 URL
    
    // 샘플 메뉴 그룹 데이터
    final availableGroups = _menuGroups.map((group) => {
      'id': group['name'],
      'name': group['name'],
    }).toList();
    
    // 샘플 옵션 그룹 데이터
    final availableOptions = _optionGroups.map((option) => {
      'id': option['id'],
      'name': option['name'],
      'maxSelection': option['maxSelection'],
      'items': option['items'],
    }).toList();
    
    List<Map<String, dynamic>> selectedOptions = []; // 현재 선택된 옵션들

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: 1125.w, // 750.w에서 50% 더 증가
                height: 800.h, // 높이도 더 증가
                padding: EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더
                    Row(
                      children: [
                        Icon(MdiIcons.pencil, color: AppColors.primary, size: AppSizes.iconMd),
                        SizedBox(width: AppSizes.sm),
                        Text(
                          '메뉴 수정',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(MdiIcons.close, size: AppSizes.iconMd),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.lg),
                    
                    // 스크롤 가능한 컨텐츠
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 메뉴 이미지 섹션
                            _buildEditImageSection(menuImagePath, setState),
                            SizedBox(height: AppSizes.lg),
                            
                            // 기본 정보 섹션
                            _buildEditBasicInfoSection(
                              nameController,
                              descriptionController,
                              priceLController,
                              priceMController,
                              selectedGroupId,
                              availableGroups,
                              setState,
                            ),
                            SizedBox(height: AppSizes.lg),
                            
                            // 메뉴 옵션 섹션
                            _buildEditOptionsSection(
                              selectedOptions,
                              availableOptions,
                              setState,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: AppSizes.lg),
                    
                    // 액션 버튼들
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.xl,
                              vertical: AppSizes.md,
                            ),
                          ),
                          child: Text(
                            '취소',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                        SizedBox(width: AppSizes.md),
                        ElevatedButton.icon(
                          onPressed: () {
                            _updateMenuItemAdvanced(
                              groupIndex,
                              itemIndex,
                              nameController.text,
                              descriptionController.text,
                              priceLController.text,
                              priceMController.text,
                              selectedGroupId,
                              menuImagePath,
                              selectedOptions,
                            );
                            Navigator.of(context).pop();
                          },
                          icon: Icon(MdiIcons.check, size: AppSizes.iconSm),
                          label: Text(
                            '저장',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.xl,
                              vertical: AppSizes.md,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 메뉴 이미지 섹션 빌더
  Widget _buildEditImageSection(String? menuImagePath, Function setState) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '메뉴 이미지',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                // 메뉴 이미지
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: menuImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          child: Image.network(
                            menuImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MdiIcons.imageOffOutline,
                                  size: AppSizes.iconLg,
                                  color: AppColors.textTertiary,
                                ),
                                SizedBox(height: AppSizes.xs),
                                Text(
                                  '이미지 로드 실패',
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              MdiIcons.imageOffOutline,
                              size: AppSizes.iconLg,
                              color: AppColors.textTertiary,
                            ),
                            SizedBox(height: AppSizes.xs),
                            Text(
                              '이미지 없음',
                              style: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(width: AppSizes.md),
                // 이미지 변경 버튼
                ElevatedButton.icon(
                  onPressed: () {
                    // 이미지 선택 기능
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이미지 선택 기능 준비중입니다.')),
                    );
                  },
                  icon: Icon(MdiIcons.image, size: AppSizes.iconSm),
                  label: Text(menuImagePath != null ? '변경' : '등록'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 기본 정보 섹션 빌더
  Widget _buildEditBasicInfoSection(
    TextEditingController nameController,
    TextEditingController descriptionController,
    TextEditingController priceLController,
    TextEditingController priceMController,
    String selectedGroupId,
    List<Map<String, dynamic>> availableGroups,
    Function setState,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기본 정보',
              style: TextStyle(
                fontSize: 18.sp,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: '메뉴명을 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: '메뉴에 대한 설명을 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            
            SizedBox(height: AppSizes.md),
            
            // 가격 (L, M 사이즈)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'L 사이즈 가격 *',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      TextFormField(
                        controller: priceLController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '가격을 입력하세요',
                          suffixText: '원',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          ),
                        ),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'M 사이즈 가격 *',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      TextFormField(
                        controller: priceMController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '가격을 입력하세요',
                          suffixText: '원',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          ),
                        ),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                DropdownButtonFormField<String>(
                  value: selectedGroupId,
                  decoration: InputDecoration(
                    hintText: '메뉴 그룹을 선택해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  items: availableGroups.map((group) {
                    return DropdownMenuItem<String>(
                      value: group['id'],
                      child: Text(group['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGroupId = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 메뉴 옵션 섹션 빌더
  Widget _buildEditOptionsSection(
    List<Map<String, dynamic>> selectedOptions,
    List<Map<String, dynamic>> availableOptions,
    Function setState,
  ) {
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
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showEditOptionSelectionDialog(
                    selectedOptions,
                    availableOptions,
                    setState,
                  ),
                  icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                  label: const Text('옵션 불러오기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            
            if (selectedOptions.isEmpty)
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
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: selectedOptions.map((option) => _buildEditOptionCard(option, selectedOptions, setState)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // 옵션 카드 빌더
  Widget _buildEditOptionCard(Map<String, dynamic> option, List<Map<String, dynamic>> selectedOptions, Function setState) {
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  '최대 ${option['maxSelection']}개 선택',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedOptions.remove(option);
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

  // 옵션 선택 다이얼로그
  void _showEditOptionSelectionDialog(
    List<Map<String, dynamic>> selectedOptions,
    List<Map<String, dynamic>> availableOptions,
    Function setState,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('옵션 선택'),
          content: Container(
            width: double.maxFinite,
            height: 400.h,
            child: SingleChildScrollView(
              child: Column(
                children: availableOptions.map((option) {
                  final isSelected = selectedOptions.any((selected) => selected['id'] == option['id']);
                  return Card(
                    margin: EdgeInsets.only(bottom: AppSizes.sm),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(
                            option['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          subtitle: Text('최대 ${option['maxSelection']}개 선택'),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (!isSelected) {
                                  selectedOptions.add(option);
                                }
                              } else {
                                selectedOptions.removeWhere((selected) => selected['id'] == option['id']);
                              }
                            });
                            Navigator.of(context).pop();
                            _showEditOptionSelectionDialog(selectedOptions, availableOptions, setState);
                          },
                        ),
                        // 옵션 아이템들 표시
                        if (option['items'] != null && option['items'].isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border(top: BorderSide(color: AppColors.border)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '옵션 항목:',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.xs),
                                Wrap(
                                  spacing: AppSizes.xs,
                                  runSpacing: AppSizes.xs,
                                  children: (option['items'] as List).map<Widget>((item) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSizes.sm,
                                        vertical: AppSizes.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        '${item['name']} (+${_formatPrice(item['price'])})',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('완료'),
            ),
          ],
        );
      },
    );
  }

  // 고급 메뉴 아이템 업데이트
  void _updateMenuItemAdvanced(
    int groupIndex,
    int itemIndex,
    String name,
    String description,
    String priceL,
    String priceM,
    String selectedGroupId,
    String? menuImagePath,
    List<Map<String, dynamic>> selectedOptions,
  ) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('메뉴명을 입력해주세요.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _menuGroups[groupIndex]['items'][itemIndex]['name'] = name;
      _menuGroups[groupIndex]['items'][itemIndex]['description'] = description;
      _menuGroups[groupIndex]['items'][itemIndex]['priceL'] = _formatPriceFromString(priceL);
      _menuGroups[groupIndex]['items'][itemIndex]['priceM'] = _formatPriceFromString(priceM);
      if (menuImagePath != null) {
        _menuGroups[groupIndex]['items'][itemIndex]['imageUrl'] = menuImagePath;
      }
      // 선택된 옵션들 저장 (실제 구현에서는 메뉴 모델에 포함)
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('메뉴 "$name"이(가) 수정되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 메뉴 아이템 업데이트 (기존 함수)
  void _updateMenuItem(int groupIndex, int itemIndex, String name, String description, String priceL, String priceM) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('메뉴명을 입력해주세요.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _menuGroups[groupIndex]['items'][itemIndex]['name'] = name;
      _menuGroups[groupIndex]['items'][itemIndex]['description'] = description;
      _menuGroups[groupIndex]['items'][itemIndex]['priceL'] = _formatPriceFromString(priceL);
      _menuGroups[groupIndex]['items'][itemIndex]['priceM'] = _formatPriceFromString(priceM);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('메뉴 "$name"이(가) 수정되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 가격 포맷팅 (문자열용)
  String _formatPriceFromString(String price) {
    if (price.isEmpty) return '0원';
    final numPrice = int.tryParse(price) ?? 0;
    return '${numPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
  }

  // 상태 변경 다이얼로그
  void _showStatusChangeDialog(int groupIndex, int itemIndex) {
    final item = _menuGroups[groupIndex]['items'][itemIndex];
    final currentStatus = item['status'] ?? '판매중';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.checkCircle, color: AppColors.info),
              SizedBox(width: AppSizes.sm),
              Text(
                '상태 변경',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${item['name']}"의 판매 상태를 변경하시겠습니까?',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: AppSizes.lg),
              Text(
                '현재 상태: $currentStatus',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSizes.md),
              ...['판매중', '오늘만 품절', '메뉴 숨김'].map((status) {
                final isSelected = status == currentStatus;
                return Container(
                  margin: EdgeInsets.only(bottom: AppSizes.sm),
                  child: InkWell(
                    onTap: () {
                      _changeMenuStatus(groupIndex, itemIndex, status);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? MdiIcons.radioboxMarked : MdiIcons.radioboxBlank,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          SizedBox(width: AppSizes.sm),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  // 메뉴 상태 변경
  void _changeMenuStatus(int groupIndex, int itemIndex, String newStatus) {
    final oldStatus = _menuGroups[groupIndex]['items'][itemIndex]['status'];
    
    setState(() {
      _menuGroups[groupIndex]['items'][itemIndex]['status'] = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('메뉴 상태가 "$oldStatus"에서 "$newStatus"로 변경되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 그룹 액션 처리
  void _handleGroupAction(String action, int groupIndex) {
    switch (action) {
      case 'edit':
        _showMenuGroupEditDialog(groupIndex);
        break;
      case 'delete':
        _showGroupDeleteConfirmDialog(groupIndex);
        break;
    }
  }

  // 메뉴 그룹 수정 다이얼로그
  void _showMenuGroupEditDialog(int groupIndex) {
    final group = _menuGroups[groupIndex];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MenuGroupEditDialog(
          initialName: group['name'],
          initialDescription: group['description'] ?? '',
          onEdit: (String name, String description) {
            setState(() {
              _menuGroups[groupIndex]['name'] = name;
              _menuGroups[groupIndex]['description'] = description;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('메뉴 그룹 "$name"이 수정되었습니다.'),
                backgroundColor: AppColors.success,
              ),
            );
          },
        );
      },
    );
  }

  // 그룹 삭제 확인 다이얼로그
  void _showGroupDeleteConfirmDialog(int groupIndex) {
    final group = _menuGroups[groupIndex];
    final menuCount = group['items'].length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.alertCircle, color: AppColors.error),
              SizedBox(width: AppSizes.sm),
              Text(
                '그룹 삭제 확인',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${group['name']}" 그룹을 삭제하시겠습니까?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.lg),
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(MdiIcons.alert, color: AppColors.error, size: AppSizes.iconSm),
                        SizedBox(width: AppSizes.sm),
                        Text(
                          '경고',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      '그룹 삭제 시 그룹 내에 있는 모든 메뉴가 삭제됩니다.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      '삭제될 메뉴: $menuCount개',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      '진행하시겠습니까?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(color: AppColors.border),
              ),
              child: Text(
                '아니오',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            SizedBox(width: AppSizes.md),
            ElevatedButton(
              onPressed: () {
                _deleteMenuGroup(groupIndex);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text(
                '예',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.end,
        );
      },
    );
  }

  // 메뉴 그룹 삭제 실행
  void _deleteMenuGroup(int groupIndex) {
    final group = _menuGroups[groupIndex];
    final groupName = group['name'];
    final menuCount = group['items'].length;

    setState(() {
      _menuGroups.removeAt(groupIndex);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('그룹 "$groupName"과(와) $menuCount개의 메뉴가 삭제되었습니다.'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 옵션 그룹 액션 처리
  void _handleOptionGroupAction(String action, int groupIndex) {
    switch (action) {
      case 'edit':
        _showOptionGroupEditDialog(groupIndex);
        break;
      case 'delete':
        _showOptionGroupDeleteConfirmDialog(groupIndex);
        break;
    }
  }

  // 옵션 그룹 수정 다이얼로그
  void _showOptionGroupEditDialog(int groupIndex) {
    final group = _optionGroups[groupIndex];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OptionGroupEditDialog(
          initialName: group['name'],
          initialDescription: group['description'] ?? '',
          initialMaxSelection: group['maxSelection'],
          onEdit: (String name, String description, int maxSelection) {
            setState(() {
              _optionGroups[groupIndex]['name'] = name;
              _optionGroups[groupIndex]['description'] = description;
              _optionGroups[groupIndex]['maxSelection'] = maxSelection;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('옵션 그룹 "$name"이 수정되었습니다.'),
                backgroundColor: AppColors.success,
              ),
            );
          },
        );
      },
    );
  }

  // 옵션 아이템 액션 처리
  void _handleOptionItemAction(String action, Map<String, dynamic> item) {
    switch (action) {
      case 'edit':
        _showOptionItemEditDialog(item);
        break;
      case 'delete':
        _showOptionItemDeleteConfirmDialog(item);
        break;
    }
  }

  // 옵션 아이템 수정 다이얼로그
  void _showOptionItemEditDialog(Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name']);
    final priceController = TextEditingController(text: item['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.pencil, color: AppColors.primary),
              SizedBox(width: AppSizes.sm),
              Text('옵션 아이템 수정'),
            ],
          ),
          content: SizedBox(
            width: 400.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '옵션명 *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '추가 가격',
                    suffixText: '원',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  _updateOptionItem(item, nameController.text.trim(), int.tryParse(priceController.text) ?? 0);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }

  // 옵션 아이템 삭제 확인 다이얼로그
  void _showOptionItemDeleteConfirmDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.alertCircle, color: AppColors.error),
              SizedBox(width: AppSizes.sm),
              Text('옵션 아이템 삭제'),
            ],
          ),
          content: Text('옵션 아이템 "${item['name']}"을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteOptionItem(item);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  // 옵션 아이템 업데이트
  void _updateOptionItem(Map<String, dynamic> item, String name, int price) {
    setState(() {
      item['name'] = name;
      item['price'] = price;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('옵션 아이템 "$name"이 수정되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 옵션 아이템 삭제
  void _deleteOptionItem(Map<String, dynamic> item) {
    setState(() {
      for (int i = 0; i < _optionGroups.length; i++) {
        final items = _optionGroups[i]['items'] as List;
        items.removeWhere((optionItem) => optionItem['id'] == item['id']);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('옵션 아이템 "${item['name']}"이 삭제되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // 옵션 그룹 삭제 확인 다이얼로그
  void _showOptionGroupDeleteConfirmDialog(int groupIndex) {
    final group = _optionGroups[groupIndex];
    final optionCount = group['items'].length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.alertCircle, color: AppColors.error),
              SizedBox(width: AppSizes.sm),
              Text(
                '옵션 그룹 삭제 확인',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${group['name']}" 옵션 그룹을 삭제하시겠습니까?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.lg),
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(MdiIcons.alert, color: AppColors.error, size: AppSizes.iconSm),
                        SizedBox(width: AppSizes.sm),
                        Text(
                          '경고',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      '그룹 삭제 시 그룹 내에 있는 모든 옵션이 삭제됩니다.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      '삭제될 옵션: $optionCount개',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      '진행하시겠습니까?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(color: AppColors.border),
              ),
              child: Text(
                '아니오',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            SizedBox(width: AppSizes.md),
            ElevatedButton(
              onPressed: () {
                _deleteOptionGroup(groupIndex);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text(
                '예',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.end,
        );
      },
    );
  }

  // 옵션 그룹 삭제 실행
  void _deleteOptionGroup(int groupIndex) {
    final group = _optionGroups[groupIndex];
    final groupName = group['name'];
    final optionCount = group['items'].length;

    setState(() {
      _optionGroups.removeAt(groupIndex);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('옵션 그룹 "$groupName"과(와) $optionCount개의 옵션이 삭제되었습니다.'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 메뉴 상태 필터 위젯
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

  // 필터에 따른 메뉴 아이템 필터링
  List<Map<String, dynamic>> _getFilteredItems(List<dynamic> items) {
    if (_selectedStatusFilter == '전체') {
      return List<Map<String, dynamic>>.from(items);
    }
    
    return items.where((item) {
      final status = item['status'] ?? '판매중';
      return status == _selectedStatusFilter;
    }).cast<Map<String, dynamic>>().toList();
  }

  // 상태별 메뉴 개수 계산
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
}
