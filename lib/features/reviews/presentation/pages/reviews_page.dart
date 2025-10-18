import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/review_model.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<ReviewModel> _reviews = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _itemsPerPage = 50;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: 실제 API 호출로 변경
    await Future.delayed(const Duration(seconds: 1));
    
    final sampleReviews = _getSampleReviews();
    
    setState(() {
      _reviews = sampleReviews;
      _totalItems = sampleReviews.length;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.review,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            _buildStatsCards(),
            SizedBox(height: AppSizes.lg),
            Expanded(
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _buildReviewsList(),
            ),
            if (_totalItems > _itemsPerPage) ...[
              SizedBox(height: AppSizes.lg),
              _buildPagination(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '리뷰 관리',
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.xs),
            Text(
              '고객 리뷰를 확인하고 관리할 수 있습니다.',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    final totalReviews = _totalItems;
    final avgRating = _reviews.isEmpty 
        ? 0.0 
        : _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;
    final recentReviews = _reviews.where((r) {
      final createdDate = DateTime.tryParse(r.createdAt);
      if (createdDate == null) return false;
      final now = DateTime.now();
      return now.difference(createdDate).inDays <= 7;
    }).length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '전체 리뷰',
            '$totalReviews개',
            MdiIcons.commentMultiple,
            AppColors.primary,
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '평균 평점',
            avgRating.toStringAsFixed(1),
            MdiIcons.star,
            AppColors.warning,
          ),
        ),
        SizedBox(width: AppSizes.lg),
        Expanded(
          child: _buildStatCard(
            '최근 7일',
            '$recentReviews개',
            MdiIcons.clockOutline,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 28.sp,
              color: color,
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    if (_reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.commentRemoveOutline,
              size: 64.r,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSizes.md),
            Text(
              '등록된 리뷰가 없습니다.',
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        return _buildReviewCard(_reviews[index]);
      },
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 프로필 아이콘
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    MdiIcons.account,
                    size: 22.sp,
                    color: AppColors.textSecondary,
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
                            '${review.customerName} (${review.customerNickname})',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: AppSizes.sm),
                          _buildRatingStars(review.rating),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        review.createdAt,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showReviewDetail(review),
                  icon: Icon(MdiIcons.dotsVertical, size: 20.sp),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            
            // 가게명 및 주문메뉴
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    MdiIcons.store,
                    '가게명',
                    review.storeName,
                  ),
                ),
                SizedBox(width: AppSizes.lg),
                Expanded(
                  child: _buildInfoItem(
                    MdiIcons.silverwareForkKnife,
                    '주문메뉴',
                    review.orderMenu,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppSizes.md),
            
            // 리뷰 내용
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                review.content,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            
            // 이미지가 있는 경우
            if (review.imageUrls != null && review.imageUrls!.isNotEmpty) ...[
              SizedBox(height: AppSizes.md),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: review.imageUrls!.take(3).map((url) {
                  return Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        MdiIcons.image,
                        size: 32.sp,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            // 매장 답글이 있는 경우
            if (review.storeReply != null && review.storeReply!.isNotEmpty) ...[
              SizedBox(height: AppSizes.md),
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            MdiIcons.store,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: AppSizes.sm),
                        Text(
                          '${review.storeName} 답글',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: AppSizes.sm),
                        Text(
                          review.storeReplyDate ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      review.storeReply!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: AppSizes.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? MdiIcons.star : MdiIcons.starOutline,
          size: 16.sp,
          color: AppColors.warning,
        );
      }),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_totalItems / _itemsPerPage).ceil();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _currentPage > 1 
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                  _loadReviews();
                }
              : null,
          icon: Icon(MdiIcons.chevronLeft),
        ),
        SizedBox(width: AppSizes.md),
        Text(
          '$_currentPage / $totalPages',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: AppSizes.md),
        IconButton(
          onPressed: _currentPage < totalPages 
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                  _loadReviews();
                }
              : null,
          icon: Icon(MdiIcons.chevronRight),
        ),
      ],
    );
  }

  void _showReviewDetail(ReviewModel review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          title: Row(
            children: [
              Icon(MdiIcons.commentText, color: AppColors.primary),
              SizedBox(width: AppSizes.sm),
              Text(
                '리뷰 상세',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 600.w,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('작성자', '${review.customerName} (${review.customerNickname})'),
                  _buildDetailRow('가게명', review.storeName),
                  _buildDetailRow('주문메뉴', review.orderMenu),
                  _buildDetailRow('작성일자', review.createdAt),
                  _buildDetailRow('평점', '${review.rating}점'),
                  SizedBox(height: AppSizes.md),
                  Text(
                    '리뷰 내용',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Text(
                      review.content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  
                  // 매장 답글이 있는 경우
                  if (review.storeReply != null && review.storeReply!.isNotEmpty) ...[
                    SizedBox(height: AppSizes.md),
                    Text(
                      '매장 답글',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                MdiIcons.store,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: AppSizes.xs),
                              Text(
                                review.storeName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (review.storeReplyDate != null) ...[
                                SizedBox(width: AppSizes.sm),
                                Text(
                                  review.storeReplyDate!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: AppSizes.sm),
                          Text(
                            review.storeReply!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              height: 1.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '닫기',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: 리뷰 삭제 로직
                Navigator.of(context).pop();
              },
              icon: Icon(MdiIcons.delete, size: 18.sp),
              label: Text(
                '삭제',
                style: TextStyle(fontSize: 16.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ReviewModel> _getSampleReviews() {
    return List.generate(75, (index) {
      final rating = 3 + (index % 3);
      final hasReply = index % 3 == 0; // 3개 중 1개는 답글이 있음
      
      return ReviewModel(
        id: 'review_${index + 1}',
        customerId: 'customer_${index + 1}',
        customerName: ['김민수', '이영희', '박철수', '최지은', '정다은'][index % 5],
        customerNickname: ['맛집탐방', '푸드러버', '리뷰왕', '맛있어요', '배고파'][index % 5],
        storeId: 'store_${(index % 10) + 1}',
        storeName: ['맛있는집 강남점', '치킨왕 홍대점', '피자마을', '햄버거킹', '떡볶이천국'][index % 5],
        orderId: 'order_${index + 1}',
        orderMenu: ['치킨 + 콜라', '피자 세트', '햄버거 세트', '떡볶이 + 순대', '김밥 + 라면'][index % 5],
        rating: rating,
        content: [
          '정말 맛있었어요! 재료도 신선하고 양도 푸짐해서 좋았습니다. 다음에 또 주문할게요!',
          '배달이 빨라서 좋았어요. 음식도 따뜻하게 잘 왔습니다.',
          '맛은 괜찮은데 양이 좀 적은 것 같아요. 그래도 만족합니다.',
          '사장님이 친절하시고 음식도 맛있어요. 단골 될 것 같아요!',
          '기대했던 것보다는 조금 아쉬웠지만 그래도 괜찮았습니다.',
        ][index % 5],
        createdAt: DateTime.now()
            .subtract(Duration(days: index))
            .toString()
            .substring(0, 19)
            .replaceAll('T', ' '),
        imageUrls: index % 3 == 0 
            ? ['image1.jpg', 'image2.jpg'] 
            : null,
        storeReply: hasReply ? [
          '소중한 리뷰 감사합니다! 앞으로도 더 맛있는 음식으로 보답하겠습니다 😊',
          '좋은 평가 감사드립니다. 고객님의 재방문을 기다리겠습니다!',
          '피드백 감사합니다. 양에 대해서는 개선할 수 있도록 노력하겠습니다.',
          '감사합니다! 단골 고객이 되어주세요 ❤️',
          '아쉬운 부분 말씀해주셔서 감사합니다. 더 나은 서비스로 찾아뵙겠습니다.',
        ][index % 5] : null,
        storeReplyDate: hasReply ? DateTime.now()
            .subtract(Duration(days: index, hours: 5))
            .toString()
            .substring(0, 19)
            .replaceAll('T', ' ') : null,
      );
    });
  }
}

