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

class StoreMenuPage extends StatefulWidget {
  final String storeId;
  final bool isRegisterMode;
  
  const StoreMenuPage({super.key, required this.storeId, this.isRegisterMode = false});

  @override
  State<StoreMenuPage> createState() => _StoreMenuPageState();
}

class _StoreMenuPageState extends State<StoreMenuPage> with TickerProviderStateMixin {
  late TabController _tabController;

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
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '피자',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('메뉴 추가 기능 준비중입니다.')),
                    );
                  },
                  icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                  label: Text('메뉴추가'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            _buildMenuItemCard(),
            SizedBox(height: AppSizes.sm),
            _buildMenuItemCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard() {
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
                  '밤바피자',
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
                      '24,900원',
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
                      '22,900원',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  '[음식메뉴] 랩컨다이트피자 나주혁신',
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
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '포토리뷰&할 이벤트',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      '선택 최대 1개',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('옵션 추가 기능 준비중입니다.')),
                    );
                  },
                  icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                  label: Text('옵션추가'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: BorderSide(color: AppColors.secondary),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            _buildOptionItemCard('포토리뷰: X 이벤트 안함께요'),
            SizedBox(height: AppSizes.sm),
            _buildOptionItemCard('포토리뷰: 갈릭딥핑 2개 (5점 후기 부탁드려요)'),
            SizedBox(height: AppSizes.sm),
            _buildOptionItemCard('포토리뷰: 모짜렐라 100g (5점 후기 부탁드려요)'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItemCard(String optionName) {
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
                  optionName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  '0원',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
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
}
