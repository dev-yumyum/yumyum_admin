import 'package:json_annotation/json_annotation.dart';

part 'option_item_model.g.dart';

@JsonSerializable()
class OptionItemModel {
  final String id;
  final String name;
  final String optionGroupId;
  final int additionalPrice; // 추가 가격 (0일 수도 있음)
  final int sortOrder;
  final bool isActive;
  final String createdDate;
  final String? description;

  OptionItemModel({
    required this.id,
    required this.name,
    required this.optionGroupId,
    this.additionalPrice = 0,
    required this.sortOrder,
    this.isActive = true,
    required this.createdDate,
    this.description,
  });

  factory OptionItemModel.fromJson(Map<String, dynamic> json) =>
      _$OptionItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionItemModelToJson(this);

  OptionItemModel copyWith({
    String? id,
    String? name,
    String? optionGroupId,
    int? additionalPrice,
    int? sortOrder,
    bool? isActive,
    String? createdDate,
    String? description,
  }) {
    return OptionItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      optionGroupId: optionGroupId ?? this.optionGroupId,
      additionalPrice: additionalPrice ?? this.additionalPrice,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdDate: createdDate ?? this.createdDate,
      description: description ?? this.description,
    );
  }

  String get formattedAdditionalPrice {
    if (additionalPrice == 0) {
      return '0원';
    }
    return '${additionalPrice > 0 ? '+' : ''}${additionalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
  }
}
