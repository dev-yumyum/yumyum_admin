import 'package:json_annotation/json_annotation.dart';

part 'business_change_history_model.g.dart';

@JsonSerializable()
class BusinessChangeHistoryModel {
  final String id;
  final String businessId;
  final String changeType;
  final String changeField; // 변경된 필드명
  final String? asIsValue; // 변경 전 값
  final String? toBeValue; // 변경 후 값
  final String changedBy; // 변경자
  final DateTime changeDate;
  final String? description; // 변경 설명

  const BusinessChangeHistoryModel({
    required this.id,
    required this.businessId,
    required this.changeType,
    required this.changeField,
    this.asIsValue,
    this.toBeValue,
    required this.changedBy,
    required this.changeDate,
    this.description,
  });

  factory BusinessChangeHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessChangeHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessChangeHistoryModelToJson(this);

  BusinessChangeHistoryModel copyWith({
    String? id,
    String? businessId,
    String? changeType,
    String? changeField,
    String? asIsValue,
    String? toBeValue,
    String? changedBy,
    DateTime? changeDate,
    String? description,
  }) {
    return BusinessChangeHistoryModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      changeType: changeType ?? this.changeType,
      changeField: changeField ?? this.changeField,
      asIsValue: asIsValue ?? this.asIsValue,
      toBeValue: toBeValue ?? this.toBeValue,
      changedBy: changedBy ?? this.changedBy,
      changeDate: changeDate ?? this.changeDate,
      description: description ?? this.description,
    );
  }

  // 변경 타입 상수
  static const String typeStoreConnect = 'STORE_CONNECT';
  static const String typeStoreDisconnect = 'STORE_DISCONNECT';
  static const String typeBusinessInfo = 'BUSINESS_INFO';
  static const String typeContactInfo = 'CONTACT_INFO';
  static const String typeAccountInfo = 'ACCOUNT_INFO';

  // 필드명 상수
  static const String fieldConnectedStores = 'CONNECTED_STORES';
  static const String fieldBusinessName = 'BUSINESS_NAME';
  static const String fieldOwnerName = 'OWNER_NAME';
  static const String fieldOwnerPhone = 'OWNER_PHONE';
  static const String fieldOwnerEmail = 'OWNER_EMAIL';
  static const String fieldAccountNumber = 'ACCOUNT_NUMBER';

  // 사용자 친화적인 필드명 반환
  String get displayFieldName {
    switch (changeField) {
      case fieldConnectedStores:
        return '연결 매장';
      case fieldBusinessName:
        return '사업자명';
      case fieldOwnerName:
        return '대표자명';
      case fieldOwnerPhone:
        return '전화번호';
      case fieldOwnerEmail:
        return '이메일';
      case fieldAccountNumber:
        return '계좌번호';
      default:
        return changeField;
    }
  }

  // 사용자 친화적인 변경 타입 반환
  String get displayChangeType {
    switch (changeType) {
      case typeStoreConnect:
        return '매장 연결';
      case typeStoreDisconnect:
        return '매장 연결 해제';
      case typeBusinessInfo:
        return '사업 정보 수정';
      case typeContactInfo:
        return '연락처 정보 수정';
      case typeAccountInfo:
        return '계좌 정보 수정';
      default:
        return changeType;
    }
  }
}
