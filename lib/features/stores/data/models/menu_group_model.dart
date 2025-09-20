import 'package:json_annotation/json_annotation.dart';

part 'menu_group_model.g.dart';

@JsonSerializable()
class MenuGroupModel {
  final String id;
  final String name;
  final String storeId;
  final int sortOrder;
  final bool isActive;
  final String createdDate;
  final String? description;

  MenuGroupModel({
    required this.id,
    required this.name,
    required this.storeId,
    required this.sortOrder,
    this.isActive = true,
    required this.createdDate,
    this.description,
  });

  factory MenuGroupModel.fromJson(Map<String, dynamic> json) =>
      _$MenuGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuGroupModelToJson(this);

  MenuGroupModel copyWith({
    String? id,
    String? name,
    String? storeId,
    int? sortOrder,
    bool? isActive,
    String? createdDate,
    String? description,
  }) {
    return MenuGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      storeId: storeId ?? this.storeId,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdDate: createdDate ?? this.createdDate,
      description: description ?? this.description,
    );
  }
}
