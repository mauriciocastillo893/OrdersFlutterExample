import 'package:langspeak/domain/models/order_model/order_model.dart';
import 'package:langspeak/domain/models/order_model/repository/order_repository.dart';

class OrderUseCase {
  final OrderRepository orderRepository;
  OrderUseCase(this.orderRepository);

  Future<OrderModel> createOrder(OrderModel orderModel) async {
    return orderRepository.createOrder(orderModel);
  }

  Future<List<OrderModel>> getAllOrders() async {
    return orderRepository.getAllOrders();
  }

  Future<OrderModel> getOrder(String orderId) async {
    return orderRepository.getOrder(orderId);
  }

  Future<String> updateOrder(String orderId, String status) async {
    return orderRepository.updateOrder(orderId, status);
  }

  Future<String> deleteOrder(String orderId) {
    return orderRepository.deleteOrder(orderId);
  }
}
