import 'package:json_annotation/json_annotation.dart';

part 'option_group_model.g.dart';

@JsonSerializable()
class OptionGroupModel {
  final String id;
  final String name;
  final String storeId;
  final bool isRequired;
  final bool isMultipleSelection; // 다중 선택 가능 여부
  final int maxSelectionCount; // 최대 선택 개수
  final int sortOrder;
  final bool isActive;
  final String createdDate;
  final String? description;

  OptionGroupModel({
    required this.id,
    required this.name,
    required this.storeId,
    this.isRequired = false,
    this.isMultipleSelection = false,
    this.maxSelectionCount = 1,
    required this.sortOrder,
    this.isActive = true,
    required this.createdDate,
    this.description,
  });

  factory OptionGroupModel.fromJson(Map<String, dynamic> json) =>
      _$OptionGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionGroupModelToJson(this);

  OptionGroupModel copyWith({
    String? id,
    String? name,
    String? storeId,
    bool? isRequired,
    bool? isMultipleSelection,
    int? maxSelectionCount,
    int? sortOrder,
    bool? isActive,
    String? createdDate,
    String? description,
  }) {
    return OptionGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      storeId: storeId ?? this.storeId,
      isRequired: isRequired ?? this.isRequired,
      isMultipleSelection: isMultipleSelection ?? this.isMultipleSelection,
      maxSelectionCount: maxSelectionCount ?? this.maxSelectionCount,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdDate: createdDate ?? this.createdDate,
      description: description ?? this.description,
    );
  }

  String get selectionTypeText {
    if (isMultipleSelection) {
      return '다중선택 (최대 ${maxSelectionCount}개)';
    } else {
      return '단일선택';
    }
  }

  String get requirementText {
    return isRequired ? '필수' : '선택';
  }
}
