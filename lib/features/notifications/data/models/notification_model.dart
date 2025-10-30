class NotificationModel {
  final String id;
  final String title;
  final String content;
  final String type; // 회원가입, 포장주문, 픽업, 결제, 리뷰 등
  final String deliveryMethod; // APP_POPUP, KAKAO_TALK, BOTH
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final String? linkUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.deliveryMethod,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.linkUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      deliveryMethod: json['deliveryMethod'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
      imageUrl: json['imageUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'deliveryMethod': deliveryMethod,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'imageUrl': imageUrl,
      'linkUrl': linkUrl,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? content,
    String? type,
    String? deliveryMethod,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    String? linkUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
    );
  }
}

// 안내메시지 유형
class NotificationType {
  static const String signup = 'SIGNUP'; // 회원가입
  static const String orderPickup = 'ORDER_PICKUP'; // 포장주문
  static const String pickup = 'PICKUP'; // 픽업
  static const String payment = 'PAYMENT'; // 결제
  static const String review = 'REVIEW'; // 리뷰
  static const String promotion = 'PROMOTION'; // 프로모션
  static const String announcement = 'ANNOUNCEMENT'; // 공지사항
  static const String orderComplete = 'ORDER_COMPLETE'; // 주문완료
  static const String orderCancel = 'ORDER_CANCEL'; // 주문취소
  
  static List<String> get all => [
    signup,
    orderPickup,
    pickup,
    payment,
    review,
    promotion,
    announcement,
    orderComplete,
    orderCancel,
  ];
  
  static String getLabel(String type) {
    switch (type) {
      case signup:
        return '회원가입';
      case orderPickup:
        return '포장주문';
      case pickup:
        return '픽업';
      case payment:
        return '결제';
      case review:
        return '리뷰';
      case promotion:
        return '프로모션';
      case announcement:
        return '공지사항';
      case orderComplete:
        return '주문완료';
      case orderCancel:
        return '주문취소';
      default:
        return type;
    }
  }
}

// 발송 방법
class DeliveryMethod {
  static const String appPopup = 'APP_POPUP'; // 앱 팝업
  static const String kakaoTalk = 'KAKAO_TALK'; // 카카오톡
  static const String both = 'BOTH'; // 둘 다
  
  static List<String> get all => [appPopup, kakaoTalk, both];
  
  static String getLabel(String method) {
    switch (method) {
      case appPopup:
        return '앱 팝업';
      case kakaoTalk:
        return '카카오톡';
      case both:
        return '둘 다';
      default:
        return method;
    }
  }
}

