class AdminModel {
  final String id;
  final String adminId; // 관리자 ID (로그인용)
  final String name;
  final String email;
  final String phone;
  final String department; // 부서
  final String position; // 직책
  final String role; // 권한 (SUPER_ADMIN, ADMIN, MANAGER 등)
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String status; // ACTIVE, INACTIVE, SUSPENDED
  final String? profileImage;

  AdminModel({
    required this.id,
    required this.adminId,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.position,
    required this.role,
    required this.createdAt,
    this.lastLoginAt,
    required this.status,
    this.profileImage,
  });

  // 역할 표시용 텍스트
  String get displayRole {
    switch (role) {
      case 'SUPER_ADMIN':
        return '최고관리자';
      case 'ADMIN':
        return '관리자';
      case 'MANAGER':
        return '매니저';
      case 'STAFF':
        return '직원';
      default:
        return role;
    }
  }

  // 상태 표시용 텍스트
  String get displayStatus {
    switch (status) {
      case 'ACTIVE':
        return '활성';
      case 'INACTIVE':
        return '비활성';
      case 'SUSPENDED':
        return '정지';
      default:
        return status;
    }
  }

  // copyWith 메서드
  AdminModel copyWith({
    String? id,
    String? adminId,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? position,
    String? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? status,
    String? profileImage,
  }) {
    return AdminModel(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      position: position ?? this.position,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  // JSON 변환 메서드들
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adminId': adminId,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'position': position,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'status': status,
      'profileImage': profileImage,
    };
  }

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      adminId: json['adminId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      department: json['department'],
      position: json['position'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
      status: json['status'],
      profileImage: json['profileImage'],
    );
  }
}
