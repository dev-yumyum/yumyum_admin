// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nickname_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NicknameModel _$NicknameModelFromJson(Map<String, dynamic> json) => NicknameModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      reason: json['reason'] as String?,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$NicknameModelToJson(NicknameModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'reason': instance.reason,
      'createdBy': instance.createdBy,
    };
