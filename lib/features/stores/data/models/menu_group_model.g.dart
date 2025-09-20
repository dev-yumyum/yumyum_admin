// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuGroupModel _$MenuGroupModelFromJson(Map<String, dynamic> json) =>
    MenuGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      storeId: json['storeId'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      createdDate: json['createdDate'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$MenuGroupModelToJson(MenuGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'storeId': instance.storeId,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdDate': instance.createdDate,
      'description': instance.description,
    };
