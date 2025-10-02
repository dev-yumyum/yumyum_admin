class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      statusCode: json['statusCode'],
      errors: json['errors'] != null 
          ? Map<String, dynamic>.from(json['errors']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'statusCode': statusCode,
      'errors': errors,
    };
  }

  // 성공 여부 확인
  bool get isSuccess => success;
  
  // 에러 여부 확인
  bool get isError => !success;
  
  // 데이터 존재 여부 확인
  bool get hasData => data != null;
  
  // 에러 메시지 가져오기
  String get errorMessage => message;
  
  // 특정 필드 에러 메시지 가져오기
  String? getFieldError(String field) {
    return errors?[field]?.toString();
  }
}
