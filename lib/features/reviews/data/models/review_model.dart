class ReviewModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerNickname;
  final String storeId;
  final String storeName;
  final String orderId;
  final String orderMenu;
  final int rating;
  final String content;
  final String createdAt;
  final List<String>? imageUrls;
  final String? storeReply;
  final String? storeReplyDate;

  ReviewModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerNickname,
    required this.storeId,
    required this.storeName,
    required this.orderId,
    required this.orderMenu,
    required this.rating,
    required this.content,
    required this.createdAt,
    this.imageUrls,
    this.storeReply,
    this.storeReplyDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerNickname: json['customerNickname'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      orderId: json['orderId'],
      orderMenu: json['orderMenu'],
      rating: json['rating'],
      content: json['content'],
      createdAt: json['createdAt'],
      imageUrls: json['imageUrls'] != null 
          ? List<String>.from(json['imageUrls']) 
          : null,
      storeReply: json['storeReply'],
      storeReplyDate: json['storeReplyDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerNickname': customerNickname,
      'storeId': storeId,
      'storeName': storeName,
      'orderId': orderId,
      'orderMenu': orderMenu,
      'rating': rating,
      'content': content,
      'createdAt': createdAt,
      'imageUrls': imageUrls,
      'storeReply': storeReply,
      'storeReplyDate': storeReplyDate,
    };
  }
}

