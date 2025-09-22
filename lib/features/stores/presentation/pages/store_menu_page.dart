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
                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
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
}
