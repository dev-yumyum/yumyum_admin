import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModel {
  final String id;
  final String memberId; // 회원 아이디
  final String? memberName; // 회원명
  final String? email; // 이메일
  final String? phone; // 전화번호
  final String? nickname; // 닉네임
  final String? profileImage; // 프로필 이미지 URL
  final String registrationDate; // 가입일
  final String? lastLoginDate; // 마지막 로그인일
  final String status; // 회원 상태 (ACTIVE, INACTIVE, SUSPENDED, WITHDRAWN)
  final String? grade; // 회원 등급 (BRONZE, SILVER, GOLD, VIP)
  final int? totalOrders; // 총 주문 수
  final String? totalAmount; // 총 주문 금액
  final int? pointBalance; // 포인트 잔액
  final String? address; // 주소
  final String? addressDetail; // 상세주소
  final String? birthDate; // 생년월일
  final String? gender; // 성별 (M, F, OTHER)
  final bool? isMarketingAgreed; // 마케팅 수신 동의
  final bool? isPushAgreed; // 푸시 알림 동의
  final String? favoriteCategory; // 선호 카테고리
  final String? withdrawalReason; // 탈퇴 사유
  final String? withdrawalDate; // 탈퇴일
  final String? registrationType; // 가입형식 (카카오톡, 이메일, 애플)

  const MemberModel({
    required this.id,
    required this.memberId,
    this.memberName,
    this.email,
    this.phone,
    this.nickname,
    this.profileImage,
    required this.registrationDate,
    this.lastLoginDate,
    required this.status,
    this.grade,
    this.totalOrders,
    this.totalAmount,
    this.pointBalance,
    this.address,
    this.addressDetail,
    this.birthDate,
    this.gender,
    this.isMarketingAgreed,
    this.isPushAgreed,
    this.favoriteCategory,
    this.withdrawalReason,
    this.withdrawalDate,
    this.registrationType,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

  MemberModel copyWith({
    String? id,
    String? memberId,
    String? memberName,
    String? email,
    String? phone,
    String? nickname,
    String? profileImage,
    String? registrationDate,
    String? lastLoginDate,
    String? status,
    String? grade,
    int? totalOrders,
    String? totalAmount,
    int? pointBalance,
    String? address,
    String? addressDetail,
    String? birthDate,
    String? gender,
    bool? isMarketingAgreed,
    bool? isPushAgreed,
    String? favoriteCategory,
    String? withdrawalReason,
    String? withdrawalDate,
    String? registrationType,
  }) {
    return MemberModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      registrationDate: registrationDate ?? this.registrationDate,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      status: status ?? this.status,
      grade: grade ?? this.grade,
      totalOrders: totalOrders ?? this.totalOrders,
      totalAmount: totalAmount ?? this.totalAmount,
      pointBalance: pointBalance ?? this.pointBalance,
      address: address ?? this.address,
      addressDetail: addressDetail ?? this.addressDetail,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      isMarketingAgreed: isMarketingAgreed ?? this.isMarketingAgreed,
      isPushAgreed: isPushAgreed ?? this.isPushAgreed,
      favoriteCategory: favoriteCategory ?? this.favoriteCategory,
      withdrawalReason: withdrawalReason ?? this.withdrawalReason,
      withdrawalDate: withdrawalDate ?? this.withdrawalDate,
      registrationType: registrationType ?? this.registrationType,
    );
  }
}
