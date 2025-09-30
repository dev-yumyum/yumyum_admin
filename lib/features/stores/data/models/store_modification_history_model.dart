class StoreModificationHistoryModel {
  final String id;
  final String storeId; // 매장 ID
  final String actionType; // 액션 유형 (UPLOAD, TAKEDOWN, MODIFY, CREATE, DELETE)
  final String actionDisplayName; // 액션 표시명
  final String? fieldName; // 수정된 필드명 (optional)
  final String? fieldDisplayName; // 필드 표시명 (optional)
  final String? valueBefore; // 변경 전 값 (optional)
  final String? valueAfter; // 변경 후 값 (optional)
  final DateTime modifiedAt; // 수정일시
  final String modifiedBy; // 수정자 ('ADMIN', 'SYSTEM')
  final String? adminId; // 관리자 ID
  final String? reason; // 수정 사유
  final String? ipAddress; // 수정 시 IP 주소
  final Map<String, dynamic>? metadata; // 추가 메타데이터

  const StoreModificationHistoryModel({
    required this.id,
    required this.storeId,
    required this.actionType,
    required this.actionDisplayName,
    this.fieldName,
    this.fieldDisplayName,
    this.valueBefore,
    this.valueAfter,
    required this.modifiedAt,
    required this.modifiedBy,
    this.adminId,
    this.reason,
    this.ipAddress,
    this.metadata,
  });

  factory StoreModificationHistoryModel.fromJson(Map<String, dynamic> json) {
    return StoreModificationHistoryModel(
      id: json['id'],
      storeId: json['storeId'],
      actionType: json['actionType'],
      actionDisplayName: json['actionDisplayName'],
      fieldName: json['fieldName'],
      fieldDisplayName: json['fieldDisplayName'],
      valueBefore: json['valueBefore'],
      valueAfter: json['valueAfter'],
      modifiedAt: DateTime.parse(json['modifiedAt']),
      modifiedBy: json['modifiedBy'],
      adminId: json['adminId'],
      reason: json['reason'],
      ipAddress: json['ipAddress'],
      metadata: json['metadata']?.cast<String, dynamic>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'actionType': actionType,
      'actionDisplayName': actionDisplayName,
      'fieldName': fieldName,
      'fieldDisplayName': fieldDisplayName,
      'valueBefore': valueBefore,
      'valueAfter': valueAfter,
      'modifiedAt': modifiedAt.toIso8601String(),
      'modifiedBy': modifiedBy,
      'adminId': adminId,
      'reason': reason,
      'ipAddress': ipAddress,
      'metadata': metadata,
    };
  }

  // 액션 유형별 아이콘
  String get actionIcon {
    switch (actionType) {
      case 'UPLOAD':
        return '📱'; // 앱 업로드
      case 'TAKEDOWN':
        return '📵'; // 앱에서 내리기
      case 'MODIFY':
        return '✏️'; // 수정
      case 'CREATE':
        return '➕'; // 생성
      case 'DELETE':
        return '🗑️'; // 삭제
      default:
        return '📝'; // 기본
    }
  }

  // 액션 유형별 색상
  String get actionColorType {
    switch (actionType) {
      case 'UPLOAD':
        return 'SUCCESS'; // 초록색
      case 'TAKEDOWN':
        return 'ERROR'; // 빨간색
      case 'MODIFY':
        return 'WARNING'; // 노란색
      case 'CREATE':
        return 'INFO'; // 파란색
      case 'DELETE':
        return 'ERROR'; // 빨간색
      default:
        return 'INFO'; // 기본 파란색
    }
  }

  // 수정 유형 구분
  bool get isAdminAction => modifiedBy == 'ADMIN';
  bool get isSystemAction => modifiedBy == 'SYSTEM';
  bool get isAppAction => actionType == 'UPLOAD' || actionType == 'TAKEDOWN';

  // 변경 내용 요약 텍스트
  String get changeSummary {
    if (actionType == 'UPLOAD') {
      return '매장이 앱에 공개되었습니다';
    } else if (actionType == 'TAKEDOWN') {
      return '매장이 앱에서 내려졌습니다';
    } else if (valueBefore != null && valueAfter != null) {
      return '$valueBefore → $valueAfter';
    } else if (valueAfter != null) {
      return '새 값: $valueAfter';
    } else {
      return actionDisplayName;
    }
  }

  StoreModificationHistoryModel copyWith({
    String? id,
    String? storeId,
    String? actionType,
    String? actionDisplayName,
    String? fieldName,
    String? fieldDisplayName,
    String? valueBefore,
    String? valueAfter,
    DateTime? modifiedAt,
    String? modifiedBy,
    String? adminId,
    String? reason,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) {
    return StoreModificationHistoryModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      actionType: actionType ?? this.actionType,
      actionDisplayName: actionDisplayName ?? this.actionDisplayName,
      fieldName: fieldName ?? this.fieldName,
      fieldDisplayName: fieldDisplayName ?? this.fieldDisplayName,
      valueBefore: valueBefore ?? this.valueBefore,
      valueAfter: valueAfter ?? this.valueAfter,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      adminId: adminId ?? this.adminId,
      reason: reason ?? this.reason,
      ipAddress: ipAddress ?? this.ipAddress,
      metadata: metadata ?? this.metadata,
    );
  }
}
