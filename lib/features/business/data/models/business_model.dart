import 'package:json_annotation/json_annotation.dart';

part 'business_model.g.dart';

@JsonSerializable()
class BusinessModel {
  final String id;
  final String businessName;
  final String businessNumber;
  final String businessType;
  final String ownerName;
  final String? businessLocation;
  final String? businessLocationDetail;
  final String? businessAddress;
  final String? businessAddressDetail;
  final String? businessCategory;
  final String? businessItem;
  final String? ownerPhone;
  final String? ownerEmail;
  final String registrationDate;
  final String status;
  final String? businessLicenseUrl;
  final String? businessLicenseFileName;
  final String? bankName;
  final String? accountNumber;
  final String? accountHolder;
  final bool? accountVerified;
  final String? bankBookUrl;
  final String? bankBookFileName;
  final String? loginId;
  final String? password;
  final List<String>? connectedStoreIds; // 연결된 매장 ID 목록

  const BusinessModel({
    required this.id,
    required this.businessName,
    required this.businessNumber,
    required this.businessType,
    required this.ownerName,
    this.businessLocation,
    this.businessLocationDetail,
    this.businessAddress,
    this.businessAddressDetail,
    this.businessCategory,
    this.businessItem,
    this.ownerPhone,
    this.ownerEmail,
    required this.registrationDate,
    required this.status,
    this.businessLicenseUrl,
    this.businessLicenseFileName,
    this.bankName,
    this.accountNumber,
    this.accountHolder,
    this.accountVerified,
    this.bankBookUrl,
    this.bankBookFileName,
    this.loginId,
    this.password,
    this.connectedStoreIds,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessModelToJson(this);

  BusinessModel copyWith({
    String? id,
    String? businessName,
    String? businessNumber,
    String? businessType,
    String? ownerName,
    String? businessLocation,
    String? businessLocationDetail,
    String? businessAddress,
    String? businessAddressDetail,
    String? businessCategory,
    String? businessItem,
    String? ownerPhone,
    String? ownerEmail,
    String? registrationDate,
    String? status,
    String? businessLicenseUrl,
    String? businessLicenseFileName,
    String? bankName,
    String? accountNumber,
    String? accountHolder,
    bool? accountVerified,
    String? bankBookUrl,
    String? bankBookFileName,
    String? loginId,
    String? password,
    List<String>? connectedStoreIds,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      businessNumber: businessNumber ?? this.businessNumber,
      businessType: businessType ?? this.businessType,
      ownerName: ownerName ?? this.ownerName,
      businessLocation: businessLocation ?? this.businessLocation,
      businessLocationDetail: businessLocationDetail ?? this.businessLocationDetail,
      businessAddress: businessAddress ?? this.businessAddress,
      businessAddressDetail: businessAddressDetail ?? this.businessAddressDetail,
      businessCategory: businessCategory ?? this.businessCategory,
      businessItem: businessItem ?? this.businessItem,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      businessLicenseFileName: businessLicenseFileName ?? this.businessLicenseFileName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolder: accountHolder ?? this.accountHolder,
      accountVerified: accountVerified ?? this.accountVerified,
      bankBookUrl: bankBookUrl ?? this.bankBookUrl,
      bankBookFileName: bankBookFileName ?? this.bankBookFileName,
      loginId: loginId ?? this.loginId,
      password: password ?? this.password,
      connectedStoreIds: connectedStoreIds ?? this.connectedStoreIds,
    );
  }
}
