// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionGroupModel _$OptionGroupModelFromJson(Map<String, dynamic> json) =>
    OptionGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      storeId: json['storeId'] as String,
      isRequired: json['isRequired'] as bool? ?? false,
      isMultipleSelection: json['isMultipleSelection'] as bool? ?? false,
      maxSelectionCount: (json['maxSelectionCount'] as num?)?.toInt() ?? 1,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      createdDate: json['createdDate'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$OptionGroupModelToJson(OptionGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'storeId': instance.storeId,
      'isRequired': instance.isRequired,
      'isMultipleSelection': instance.isMultipleSelection,
      'maxSelectionCount': instance.maxSelectionCount,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdDate': instance.createdDate,
      'description': instance.description,
    };
