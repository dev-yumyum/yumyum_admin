import 'package:json_annotation/json_annotation.dart';

part 'approval_request_model.g.dart';

@JsonSerializable()
class ApprovalRequestModel {
  final String id;
  final String requestNumber; // 요청번호 (B202409140001 형태)
  final String requestType; // 요청유형 (BUSINESS, STORE, ACCOUNT, MENU)
  final String requester; // 요청자
  final String requestContent; // 요청내용
  final String requestDate; // 요청일시
  final String status; // 상태 (PENDING, APPROVED, REJECTED)
  final String? businessId; // 사업자 ID (해당하는 경우)
  final String? storeId; // 매장 ID (해당하는 경우)
  final String? menuId; // 메뉴 ID (해당하는 경우)
  final String? accountId; // 계좌 ID (해당하는 경우)
  
  // AS-IS 데이터 (변경 전)
  final Map<String, dynamic>? asIsData;
  
  // TO-BE 데이터 (변경 후)
  final Map<String, dynamic>? toBeData;
  
  final String? rejectionReason; // 반려 사유
  final String? processedDate; // 처리일시
  final String? processedBy; // 처리자
  final String? description; // 추가 설명
  
  // 첨부파일
  final List<String>? attachments;

  static const String typeBusinessInfo = 'BUSINESS';
  static const String typeStoreInfo = 'STORE';
  static const String typeAccountInfo = 'ACCOUNT';
  static const String typeMenuInfo = 'MENU';
  
  static const String statusPending = 'PENDING';
  static const String statusApproved = 'APPROVED';
  static const String statusRejected = 'REJECTED';

  const ApprovalRequestModel({
    required this.id,
    required this.requestNumber,
    required this.requestType,
    required this.requester,
    required this.requestContent,
    required this.requestDate,
    required this.status,
    this.businessId,
    this.storeId,
    this.menuId,
    this.accountId,
    this.asIsData,
    this.toBeData,
    this.rejectionReason,
    this.processedDate,
    this.processedBy,
    this.description,
    this.attachments,
  });

  factory ApprovalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalRequestModelToJson(this);

  ApprovalRequestModel copyWith({
    String? id,
    String? requestNumber,
    String? requestType,
    String? requester,
    String? requestContent,
    String? requestDate,
    String? status,
    String? businessId,
    String? storeId,
    String? menuId,
    String? accountId,
    Map<String, dynamic>? asIsData,
    Map<String, dynamic>? toBeData,
    String? rejectionReason,
    String? processedDate,
    String? processedBy,
    String? description,
    List<String>? attachments,
  }) {
    return ApprovalRequestModel(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      requestType: requestType ?? this.requestType,
      requester: requester ?? this.requester,
      requestContent: requestContent ?? this.requestContent,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      businessId: businessId ?? this.businessId,
      storeId: storeId ?? this.storeId,
      menuId: menuId ?? this.menuId,
      accountId: accountId ?? this.accountId,
      asIsData: asIsData ?? this.asIsData,
      toBeData: toBeData ?? this.toBeData,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      processedDate: processedDate ?? this.processedDate,
      processedBy: processedBy ?? this.processedBy,
      description: description ?? this.description,
      attachments: attachments ?? this.attachments,
    );
  }

  String get displayRequestType {
    switch (requestType) {
      case typeBusinessInfo:
        return '사업자';
      case typeStoreInfo:
        return '매장';
      case typeAccountInfo:
        return '통장';
      case typeMenuInfo:
        return '메뉴';
      default:
        return requestType;
    }
  }

  String get displayStatus {
    switch (status) {
      case statusPending:
        return '승인대기';
      case statusApproved:
        return '승인완료';
      case statusRejected:
        return '반려';
      default:
        return status;
    }
  }
}
