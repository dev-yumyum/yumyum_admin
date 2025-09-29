class CustomerAddressModel {
  final String id;
  final String addressName; // 주소 별명 (예: 집, 회사, 학교)
  final String fullAddress; // 전체 주소 (도로명 주소)
  final String detailAddress; // 상세 주소 (동/호수 등)
  final String? postalCode; // 우편번호
  final double? latitude; // 위도
  final double? longitude; // 경도
  final bool isDefault; // 기본 배송지 여부
  final DateTime createdAt; // 등록일시
  final DateTime updatedAt; // 수정일시
  final String? deliveryInstructions; // 배송 요청사항

  const CustomerAddressModel({
    required this.id,
    required this.addressName,
    required this.fullAddress,
    required this.detailAddress,
    this.postalCode,
    this.latitude,
    this.longitude,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryInstructions,
  });

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) {
    return CustomerAddressModel(
      id: json['id'],
      addressName: json['addressName'],
      fullAddress: json['fullAddress'],
      detailAddress: json['detailAddress'],
      postalCode: json['postalCode'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deliveryInstructions: json['deliveryInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addressName': addressName,
      'fullAddress': fullAddress,
      'detailAddress': detailAddress,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveryInstructions': deliveryInstructions,
    };
  }

  CustomerAddressModel copyWith({
    String? id,
    String? addressName,
    String? fullAddress,
    String? detailAddress,
    String? postalCode,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deliveryInstructions,
  }) {
    return CustomerAddressModel(
      id: id ?? this.id,
      addressName: addressName ?? this.addressName,
      fullAddress: fullAddress ?? this.fullAddress,
      detailAddress: detailAddress ?? this.detailAddress,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
    );
  }
}
