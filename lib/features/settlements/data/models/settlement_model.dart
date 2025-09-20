import 'package:json_annotation/json_annotation.dart';

part 'settlement_model.g.dart';

@JsonSerializable()
class SettlementModel {
  final String id;
  final String businessId; // 사업자 ID
  final String? businessName; // 사업자명
  final String storeId; // 매장 ID
  final String? storeName; // 매장명
  final String settlementDate; // 정산일
  final String periodStart; // 정산 기간 시작
  final String periodEnd; // 정산 기간 종료
  final String totalSalesAmount; // 총 매출 금액
  final String platformFeeRate; // 플랫폼 수수료율 (%)
  final String platformFeeAmount; // 플랫폼 수수료 금액
  final String deliveryFeeAmount; // 포장 서비스 수수료 금액
  final String? discountAmount; // 할인 금액
  final String? refundAmount; // 환불 금액
  final String adjustmentAmount; // 조정 금액 (추가/차감)
  final String settlementAmount; // 최종 정산 금액
  final String status; // 정산 상태 (PENDING, CONFIRMED, PAID, CANCELLED)
  final String? accountNumber; // 정산 계좌번호
  final String? accountHolder; // 예금주
  final String? bankName; // 은행명
  final String? paymentDate; // 지급일
  final String? notes; // 비고
  final int totalOrders; // 총 주문 수
  final int completedOrders; // 완료된 주문 수
  final int cancelledOrders; // 취소된 주문 수
  final String? createdDate; // 생성일
  final String? lastModifiedDate; // 최종 수정일

  const SettlementModel({
    required this.id,
    required this.businessId,
    this.businessName,
    required this.storeId,
    this.storeName,
    required this.settlementDate,
    required this.periodStart,
    required this.periodEnd,
    required this.totalSalesAmount,
    required this.platformFeeRate,
    required this.platformFeeAmount,
    required this.deliveryFeeAmount,
    this.discountAmount,
    this.refundAmount,
    required this.adjustmentAmount,
    required this.settlementAmount,
    required this.status,
    this.accountNumber,
    this.accountHolder,
    this.bankName,
    this.paymentDate,
    this.notes,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    this.createdDate,
    this.lastModifiedDate,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettlementModelToJson(this);

  SettlementModel copyWith({
    String? id,
    String? businessId,
    String? businessName,
    String? storeId,
    String? storeName,
    String? settlementDate,
    String? periodStart,
    String? periodEnd,
    String? totalSalesAmount,
    String? platformFeeRate,
    String? platformFeeAmount,
    String? deliveryFeeAmount,
    String? discountAmount,
    String? refundAmount,
    String? adjustmentAmount,
    String? settlementAmount,
    String? status,
    String? accountNumber,
    String? accountHolder,
    String? bankName,
    String? paymentDate,
    String? notes,
    int? totalOrders,
    int? completedOrders,
    int? cancelledOrders,
    String? createdDate,
    String? lastModifiedDate,
  }) {
    return SettlementModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      settlementDate: settlementDate ?? this.settlementDate,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      totalSalesAmount: totalSalesAmount ?? this.totalSalesAmount,
      platformFeeRate: platformFeeRate ?? this.platformFeeRate,
      platformFeeAmount: platformFeeAmount ?? this.platformFeeAmount,
      deliveryFeeAmount: deliveryFeeAmount ?? this.deliveryFeeAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      refundAmount: refundAmount ?? this.refundAmount,
      adjustmentAmount: adjustmentAmount ?? this.adjustmentAmount,
      settlementAmount: settlementAmount ?? this.settlementAmount,
      status: status ?? this.status,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolder: accountHolder ?? this.accountHolder,
      bankName: bankName ?? this.bankName,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
      totalOrders: totalOrders ?? this.totalOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }
}
