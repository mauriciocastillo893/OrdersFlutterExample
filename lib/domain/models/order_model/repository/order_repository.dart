import 'package:langspeak/domain/models/order_model/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel> createOrder(OrderModel orderModel);
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel> getOrder(String orderId);
  Future<String> updateOrder(String id, String status);
  Future<String> deleteOrder(String orderId);
}
