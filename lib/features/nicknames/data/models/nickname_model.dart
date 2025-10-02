import 'package:json_annotation/json_annotation.dart';

part 'nickname_model.g.dart';

@JsonSerializable()
class NicknameModel {
  final String id;
  final String userId;
  final String nickname;
  final String status; // active, inactive, banned
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? reason; // 비활성화/차단 사유
  final String? createdBy; // 관리자 ID

  NicknameModel({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.reason,
    this.createdBy,
  });

  factory NicknameModel.fromJson(Map<String, dynamic> json) => _$NicknameModelFromJson(json);
  Map<String, dynamic> toJson() => _$NicknameModelToJson(this);

  // 상태 확인 메서드
  bool get isActive => status == 'active';
  bool get isInactive => status == 'inactive';
  bool get isBanned => status == 'banned';

  // 상태 변경 메서드
  NicknameModel copyWith({
    String? id,
    String? userId,
    String? nickname,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reason,
    String? createdBy,
  }) {
    return NicknameModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reason: reason ?? this.reason,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
