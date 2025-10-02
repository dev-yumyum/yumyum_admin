// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banned_word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannedWordModel _$BannedWordModelFromJson(Map<String, dynamic> json) => BannedWordModel(
      id: json['id'] as String,
      word: json['word'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String?,
      usageCount: json['usageCount'] as int?,
    );

Map<String, dynamic> _$BannedWordModelToJson(BannedWordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'type': instance.type,
      'severity': instance.severity,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'createdBy': instance.createdBy,
      'usageCount': instance.usageCount,
    };
