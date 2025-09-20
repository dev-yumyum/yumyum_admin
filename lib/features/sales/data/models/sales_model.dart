import 'package:json_annotation/json_annotation.dart';

part 'sales_model.g.dart';

@JsonSerializable()
class SalesModel {
  final String id;
  final String orderId; // 주문 ID
  final String orderNumber; // 주문번호 (O202409140001 형태)
  final String? storeId; // 매장 ID
  final String? storeName; // 매장명
  final String? businessId; // 사업자 ID
  final String? businessName; // 사업자명
  final String? memberId; // 회원 ID
  final String? memberName; // 회원명
  final String? customerName; // 고객명
  final String orderDate; // 주문일
  final String orderType; // 주문 유형 (PICKUP, DINE_IN)
  final String status; // 주문 상태 (PAYMENT_COMPLETED, ORDER_RECEIVED, COOKING_COMPLETED, PICKUP_COMPLETED, CANCELLED)
  final int orderAmount; // 주문금액
  final String totalAmount; // 총 금액
  final int? discountAmount; // 할인 금액
  final String? deliveryFee; // 포장 서비스 수수료
  final String finalAmount; // 최종 결제 금액
  final int paymentAmount; // 결제금액
  final String paymentMethod; // 결제 방법 (CARD, CASH, MOBILE_PAY, POINT)
  final String paymentStatus; // 결제 상태 (PENDING, COMPLETED, FAILED, REFUNDED)
  final List<SalesItemModel>? items; // 주문 항목들
  final String? menuItems; // 메뉴 아이템 간단 표시용
  final String? deliveryAddress; // 포장 픽업 주소
  final String? customerPhone; // 고객 전화번호
  final String? specialInstructions; // 특별 요청사항
  final String? completedDate; // 완료일
  final String? cancelledDate; // 취소일
  final String? cancelReason; // 취소 사유
  final double? rating; // 평점
  final String? review; // 리뷰
  
  // 주문 진행 상황 시간
  final String? paymentCompleteTime; // 결제완료 시간
  final String? orderAcceptTime; // 주문접수 시간
  final String? cookingCompleteTime; // 조리완료 시간
  final String? pickupCompleteTime; // 픽업완료 시간

  const SalesModel({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    this.storeId,
    this.storeName,
    this.businessId,
    this.businessName,
    this.memberId,
    this.memberName,
    this.customerName,
    required this.orderDate,
    required this.orderType,
    required this.status,
    required this.orderAmount,
    required this.totalAmount,
    this.discountAmount,
    this.deliveryFee,
    required this.finalAmount,
    required this.paymentAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.items,
    this.menuItems,
    this.deliveryAddress,
    this.customerPhone,
    this.specialInstructions,
    this.completedDate,
    this.cancelledDate,
    this.cancelReason,
    this.rating,
    this.review,
    this.paymentCompleteTime,
    this.orderAcceptTime,
    this.cookingCompleteTime,
    this.pickupCompleteTime,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) =>
      _$SalesModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesModelToJson(this);
}

@JsonSerializable()
class SalesItemModel {
  final String id;
  final String menuId; // 메뉴 ID
  final String menuName; // 메뉴명
  final String unitPrice; // 단가
  final int quantity; // 수량
  final String totalPrice; // 총 가격
  final List<SalesOptionModel>? options; // 선택 옵션들

  const SalesItemModel({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.options,
  });

  factory SalesItemModel.fromJson(Map<String, dynamic> json) =>
      _$SalesItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesItemModelToJson(this);
}

@JsonSerializable()
class SalesOptionModel {
  final String id;
  final String optionName; // 옵션명
  final String? optionValue; // 옵션 값
  final String additionalPrice; // 추가 가격

  const SalesOptionModel({
    required this.id,
    required this.optionName,
    this.optionValue,
    required this.additionalPrice,
  });

  factory SalesOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SalesOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesOptionModelToJson(this);
}
