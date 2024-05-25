import 'dart:convert';

OrderModel? orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel? data) => json.encode(data!.toJson());

class OrderModel {
  const OrderModel(
      {this.id,
      required this.createdAt,
      required this.totalAmount,
      required this.status});

  final String? id;
  final String createdAt;
  final String totalAmount;
  final String status;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String?,
      createdAt: json['created_at'] ?? '',
      totalAmount: json['total_amount'].toString(),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'totalAmount': totalAmount,
      'status': status
    };
  }

  @override
  String toString() {
    return 'Order(id: $id, createdAt: $createdAt, totalAmount: $totalAmount, status: $status)';
  }
}

enum OrderModelStatus { Pending, Delivered, Cancelled }
