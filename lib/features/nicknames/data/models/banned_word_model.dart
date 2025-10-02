import 'package:json_annotation/json_annotation.dart';

part 'banned_word_model.g.dart';

@JsonSerializable()
class BannedWordModel {
  final String id;
  final String word;
  final String type; // text, regex, special_char
  final String severity; // low, medium, high, critical
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final String? createdBy; // 관리자 ID
  final int? usageCount; // 사용된 횟수

  BannedWordModel({
    required this.id,
    required this.word,
    required this.type,
    required this.severity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.createdBy,
    this.usageCount,
  });

  factory BannedWordModel.fromJson(Map<String, dynamic> json) => _$BannedWordModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannedWordModelToJson(this);

  // 심각도 확인 메서드
  bool get isLow => severity == 'low';
  bool get isMedium => severity == 'medium';
  bool get isHigh => severity == 'high';
  bool get isCritical => severity == 'critical';

  // 타입 확인 메서드
  bool get isText => type == 'text';
  bool get isRegex => type == 'regex';
  bool get isSpecialChar => type == 'special_char';

  // 복사 메서드
  BannedWordModel copyWith({
    String? id,
    String? word,
    String? type,
    String? severity,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    String? createdBy,
    int? usageCount,
  }) {
    return BannedWordModel(
      id: id ?? this.id,
      word: word ?? this.word,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      usageCount: usageCount ?? this.usageCount,
    );
  }
}
