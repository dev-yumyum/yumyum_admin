// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalRequestModel _$ApprovalRequestModelFromJson(
        Map<String, dynamic> json) =>
    ApprovalRequestModel(
      id: json['id'] as String,
      requestNumber: json['requestNumber'] as String,
      requestType: json['requestType'] as String,
      requester: json['requester'] as String,
      requestContent: json['requestContent'] as String,
      requestDate: json['requestDate'] as String,
      status: json['status'] as String,
      businessId: json['businessId'] as String?,
      storeId: json['storeId'] as String?,
      menuId: json['menuId'] as String?,
      accountId: json['accountId'] as String?,
      asIsData: json['asIsData'] as Map<String, dynamic>?,
      toBeData: json['toBeData'] as Map<String, dynamic>?,
      rejectionReason: json['rejectionReason'] as String?,
      processedDate: json['processedDate'] as String?,
      processedBy: json['processedBy'] as String?,
      description: json['description'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ApprovalRequestModelToJson(
        ApprovalRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestNumber': instance.requestNumber,
      'requestType': instance.requestType,
      'requester': instance.requester,
      'requestContent': instance.requestContent,
      'requestDate': instance.requestDate,
      'status': instance.status,
      'businessId': instance.businessId,
      'storeId': instance.storeId,
      'menuId': instance.menuId,
      'accountId': instance.accountId,
      'asIsData': instance.asIsData,
      'toBeData': instance.toBeData,
      'rejectionReason': instance.rejectionReason,
      'processedDate': instance.processedDate,
      'processedBy': instance.processedBy,
      'description': instance.description,
      'attachments': instance.attachments,
    };
