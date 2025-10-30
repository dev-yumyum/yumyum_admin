import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/notification_model.dart';
import '../widgets/notification_dialog.dart';

class NotificationManagementPage extends StatefulWidget {
  const NotificationManagementPage({super.key});

  @override
  State<NotificationManagementPage> createState() => _NotificationManagementPageState();
}

class _NotificationManagementPageState extends State<NotificationManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _filteredNotifications = [];
  String _selectedType = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    // TODO: 실제 API 호출로 데이터 가져오기
    _notifications = [
      NotificationModel(
        id: '1',
        title: '회원가입 환영 메시지',
        content: '얌얌에 오신 것을 환영합니다! 첫 주문 시 3,000원 할인 쿠폰을 드립니다.',
        type: NotificationType.signup,
        deliveryMethod: DeliveryMethod.both,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        imageUrl: null,
        linkUrl: null,
      ),
      NotificationModel(
        id: '2',
        title: '포장주문 완료',
        content: '주문이 접수되었습니다. 매장에서 음식을 준비 중입니다.',
        type: NotificationType.orderPickup,
        deliveryMethod: DeliveryMethod.appPopup,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      NotificationModel(
        id: '3',
        title: '픽업 준비 완료',
        content: '주문하신 음식이 준비되었습니다. 매장으로 방문해주세요.',
        type: NotificationType.pickup,
        deliveryMethod: DeliveryMethod.kakaoTalk,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      NotificationModel(
        id: '4',
        title: '결제 완료 안내',
        content: '결제가 정상적으로 완료되었습니다. 감사합니다.',
        type: NotificationType.payment,
        deliveryMethod: DeliveryMethod.both,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      NotificationModel(
        id: '5',
        title: '리뷰 작성 요청',
        content: '주문하신 음식은 어떠셨나요? 리뷰를 남겨주시면 포인트를 드립니다.',
        type: NotificationType.review,
        deliveryMethod: DeliveryMethod.appPopup,
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    _filteredNotifications = _notifications;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNotifications = _notifications;
      } else {
        _filteredNotifications = _notifications.where((notification) {
          return notification.title.toLowerCase().contains(query.toLowerCase()) ||
                 notification.content.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onTypeFilterChanged(String type) {
    setState(() {
      _selectedType = type;
      if (type == 'ALL') {
        _filteredNotifications = _notifications;
      } else {
        _filteredNotifications = _notifications
            .where((notification) => notification.type == type)
            .toList();
      }
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => NotificationDialog(
        onSave: (notification) {
          setState(() {
            _notifications.add(notification);
            _filteredNotifications = _notifications;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('안내메시지가 추가되었습니다.'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => NotificationDialog(
        notification: notification,
        onSave: (updatedNotification) {
          setState(() {
            final index = _notifications.indexWhere((n) => n.id == notification.id);
            if (index != -1) {
              _notifications[index] = updatedNotification;
              _filteredNotifications = _notifications;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('안내메시지가 수정되었습니다.'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _toggleStatus(NotificationModel notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = notification.copyWith(isActive: !notification.isActive);
        _filteredNotifications = _notifications;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          notification.isActive ? '안내메시지가 비활성화되었습니다.' : '안내메시지가 활성화되었습니다.',
        ),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _deleteNotification(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('안내메시지 삭제'),
        content: const Text('이 안내메시지를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.removeWhere((n) => n.id == notification.id);
                _filteredNotifications = _notifications;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('안내메시지가 삭제되었습니다.'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: '/notification-management',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppSizes.lg),
          _buildFilters(),
          SizedBox(height: AppSizes.lg),
          Expanded(
            child: _buildNotificationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          '안내메시지 관리',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _showAddDialog,
          icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
          label: const Text('메시지 추가'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Row(
              children: [
                // 검색
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: '제목 또는 내용으로 검색',
                      prefixIcon: Icon(MdiIcons.magnify),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.md),
                
                // 유형 필터
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: '유형',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(value: 'ALL', child: Text('전체')),
                      ...NotificationType.all.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(NotificationType.getLabel(type)),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _onTypeFilterChanged(value);
                      }
                    },
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Text(
                  '총 ${_filteredNotifications.length}개',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    if (_filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.bellOff,
              size: 64.r,
              color: Colors.grey[400],
            ),
            SizedBox(height: AppSizes.md),
            Text(
              '안내메시지가 없습니다.',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.sm),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(_filteredNotifications[index]);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      child: InkWell(
        onTap: () => _showEditDialog(notification),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: notification.isActive
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  _getIconForType(notification.type),
                  color: notification.isActive ? AppColors.primary : Colors.grey,
                  size: 24.r,
                ),
              ),
              SizedBox(width: AppSizes.md),
              
              // 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 제목
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        
                        // 상태 칩
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.xs,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: notification.isActive
                                ? AppColors.success.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: Text(
                            notification.isActive ? '활성' : '비활성',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: notification.isActive ? AppColors.success : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.xs),
                    
                    // 내용
                    Text(
                      notification.content,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSizes.sm),
                    
                    // 메타 정보
                    Row(
                      children: [
                        _buildInfoChip(
                          NotificationType.getLabel(notification.type),
                          AppColors.info,
                        ),
                        SizedBox(width: AppSizes.xs),
                        _buildInfoChip(
                          DeliveryMethod.getLabel(notification.deliveryMethod),
                          AppColors.warning,
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(notification.createdAt),
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
              SizedBox(width: AppSizes.sm),
              
              // 메뉴
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(notification);
                  } else if (value == 'toggle') {
                    _toggleStatus(notification);
                  } else if (value == 'delete') {
                    _deleteNotification(notification);
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
                          notification.isActive ? MdiIcons.eyeOff : MdiIcons.eye,
                          size: AppSizes.iconSm,
                        ),
                        SizedBox(width: AppSizes.sm),
                        Text(notification.isActive ? '비활성화' : '활성화'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(MdiIcons.delete, size: AppSizes.iconSm, color: AppColors.error),
                        SizedBox(width: AppSizes.sm),
                        Text('삭제', style: TextStyle(color: AppColors.error)),
                      ],
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

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case NotificationType.signup:
        return MdiIcons.accountPlus;
      case NotificationType.orderPickup:
        return MdiIcons.shopping;
      case NotificationType.pickup:
        return MdiIcons.packageVariant;
      case NotificationType.payment:
        return MdiIcons.creditCard;
      case NotificationType.review:
        return MdiIcons.starOutline;
      case NotificationType.promotion:
        return MdiIcons.sale;
      case NotificationType.announcement:
        return MdiIcons.bullhorn;
      case NotificationType.orderComplete:
        return MdiIcons.checkCircle;
      case NotificationType.orderCancel:
        return MdiIcons.closeCircle;
      default:
        return MdiIcons.bell;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '오늘';
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    }
  }
}

