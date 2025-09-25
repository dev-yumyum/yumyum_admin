import 'package:json_annotation/json_annotation.dart';

part 'store_model.g.dart';

@JsonSerializable()
class StoreModel {
  final String id;
  final String businessId;
  final String storeName;
  final String storeAddress;
  final String? storeAddressDetail;
  final String? storePhone;
  final String? storeDescription;
  final String registrationDate;
  final String status;
  final String? operatingHours;
  final String? deliveryRadius; // 포장 서비스 반경 (km)
  final bool isDeliveryAvailable; // 포장 가능 여부
  final bool isPickupAvailable;
  final String? minimumOrderAmount; // 최소 주문 금액
  final String? deliveryFee; // 포장 서비스 수수료
  final List<String>? storeImages; // 매장 이미지 URL 목록
  final String? storeIntroImage; // 매장소개 이미지 URL (1장만)
  final double? latitude;
  final double? longitude;
  final String? businessName; // 소속 사업자명
  final int? menuCount; // 메뉴 개수
  final String? lastOrderDate; // 마지막 주문일

  const StoreModel({
    required this.id,
    required this.businessId,
    required this.storeName,
    required this.storeAddress,
    this.storeAddressDetail,
    this.storePhone,
    this.storeDescription,
    required this.registrationDate,
    required this.status,
    this.operatingHours,
    this.deliveryRadius,
    required this.isDeliveryAvailable,
    required this.isPickupAvailable,
    this.minimumOrderAmount,
    this.deliveryFee,
    this.storeImages,
    this.storeIntroImage,
    this.latitude,
    this.longitude,
    this.businessName,
    this.menuCount,
    this.lastOrderDate,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  StoreModel copyWith({
    String? id,
    String? businessId,
    String? storeName,
    String? storeAddress,
    String? storeAddressDetail,
    String? storePhone,
    String? storeDescription,
    String? registrationDate,
    String? status,
    String? operatingHours,
    String? deliveryRadius,
    bool? isDeliveryAvailable,
    bool? isPickupAvailable,
    String? minimumOrderAmount,
    String? deliveryFee,
    List<String>? storeImages,
    String? storeIntroImage,
    double? latitude,
    double? longitude,
    String? businessName,
    int? menuCount,
    String? lastOrderDate,
  }) {
    return StoreModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storeAddressDetail: storeAddressDetail ?? this.storeAddressDetail,
      storePhone: storePhone ?? this.storePhone,
      storeDescription: storeDescription ?? this.storeDescription,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      operatingHours: operatingHours ?? this.operatingHours,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      isDeliveryAvailable: isDeliveryAvailable ?? this.isDeliveryAvailable,
      isPickupAvailable: isPickupAvailable ?? this.isPickupAvailable,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      storeImages: storeImages ?? this.storeImages,
      storeIntroImage: storeIntroImage ?? this.storeIntroImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      businessName: businessName ?? this.businessName,
      menuCount: menuCount ?? this.menuCount,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
    );
  }
}
