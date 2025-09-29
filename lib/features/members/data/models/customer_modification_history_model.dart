class CustomerModificationHistoryModel {
  final String id;
  final String memberId; // 회원 ID
  final String fieldName; // 수정된 필드명 (예: 'memberName', 'phone', 'email', 'address')
  final String fieldDisplayName; // 필드 표시명 (예: '회원명', '연락처', '이메일', '주소')
  final String? valueBefore; // 변경 전 값
  final String? valueAfter; // 변경 후 값
  final DateTime modifiedAt; // 수정일시
  final String modifiedBy; // 수정자 (고객 본인: 'CUSTOMER', 관리자: 'ADMIN')
  final String? adminId; // 관리자 수정 시 관리자 ID
  final String? reason; // 수정 사유 (관리자 수정 시)
  final String? ipAddress; // 수정 시 IP 주소

  const CustomerModificationHistoryModel({
    required this.id,
    required this.memberId,
    required this.fieldName,
    required this.fieldDisplayName,
    this.valueBefore,
    this.valueAfter,
    required this.modifiedAt,
    required this.modifiedBy,
    this.adminId,
    this.reason,
    this.ipAddress,
  });

  factory CustomerModificationHistoryModel.fromJson(Map<String, dynamic> json) {
    return CustomerModificationHistoryModel(
      id: json['id'],
      memberId: json['memberId'],
      fieldName: json['fieldName'],
      fieldDisplayName: json['fieldDisplayName'],
      valueBefore: json['valueBefore'],
      valueAfter: json['valueAfter'],
      modifiedAt: DateTime.parse(json['modifiedAt']),
      modifiedBy: json['modifiedBy'],
      adminId: json['adminId'],
      reason: json['reason'],
      ipAddress: json['ipAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'fieldName': fieldName,
      'fieldDisplayName': fieldDisplayName,
      'valueBefore': valueBefore,
      'valueAfter': valueAfter,
      'modifiedAt': modifiedAt.toIso8601String(),
      'modifiedBy': modifiedBy,
      'adminId': adminId,
      'reason': reason,
      'ipAddress': ipAddress,
    };
  }

  // 수정 유형 구분
  bool get isCustomerModified => modifiedBy == 'CUSTOMER';
  bool get isAdminModified => modifiedBy == 'ADMIN';

  // 변경 내용 요약 텍스트
  String get changeSummary {
    final before = valueBefore ?? '없음';
    final after = valueAfter ?? '없음';
    return '$before → $after';
  }

  CustomerModificationHistoryModel copyWith({
    String? id,
    String? memberId,
    String? fieldName,
    String? fieldDisplayName,
    String? valueBefore,
    String? valueAfter,
    DateTime? modifiedAt,
    String? modifiedBy,
    String? adminId,
    String? reason,
    String? ipAddress,
  }) {
    return CustomerModificationHistoryModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      fieldName: fieldName ?? this.fieldName,
      fieldDisplayName: fieldDisplayName ?? this.fieldDisplayName,
      valueBefore: valueBefore ?? this.valueBefore,
      valueAfter: valueAfter ?? this.valueAfter,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      adminId: adminId ?? this.adminId,
      reason: reason ?? this.reason,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
