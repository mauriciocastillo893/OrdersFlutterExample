import 'package:langspeak/domain/models/order_model/order_model.dart';
import 'package:langspeak/domain/models/order_model/repository/order_repository.dart';
import 'package:dio/dio.dart';

class OrderAPI extends OrderRepository {
  final originURL = '192.168.1.171:3001';

  @override
  Future<OrderModel> createOrder(OrderModel orderModel) async {
    final dio = Dio();
    final response = await dio.post(
      'http://$originURL/orders',
      data: {
        "created_at": orderModel.createdAt,
        "total_amount": orderModel.totalAmount,
        "status": orderModel.status,
      },
    );
    print("response $response");
    print("response ${response.statusCode}");
    print("response ${response.data}");
    if (response.statusCode == 201) {
      print("OrderAPI: createOrder: response: $response");
      return orderModel;
    } else {
      print("OrderAPI: createOrder: response: $response");
      return Future.error("Failed to create order");
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final dio = Dio();
    try {
      final response = await dio.get('http://$originURL/orders');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<OrderModel> orders =
            data.map((json) => OrderModel.fromJson(json)).toList();
        return orders;
      } else {
        throw Exception("Failed to get orders: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get orders: $e");
    }
  }

  @override
  Future<String> deleteOrder(String orderId) async {
    final dio = Dio();
    try {
      final response = await dio.delete('http://$originURL/orders/$orderId');
      if (response.statusCode == 200) {
        return "Order deleted sucessfully";
      } else {
        throw Exception("Failed to get orders: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get orders: $e");
    }
  }

  @override
  Future<OrderModel> getOrder(String orderId) async {
    final dio = Dio();
    try {
      final response = await dio.get('http://$originURL/orders/$orderId');
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            response.data; // Cambiado a Map<String, dynamic>
        OrderModel order =
            OrderModel.fromJson(data); // Pasando el objeto directamente
        return order;
      } else {
        throw Exception("Failed to get orders: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to get orders: $e");
      throw Exception("Failed to get orders: $e");
    }
  }

  @override
  Future<String> updateOrder(String orderId, String status) async {
    final dio = Dio();
    final response = await dio.put(
      'http://$originURL/orders/$orderId',
      data: {
        "status": status,
      },
    );
    if (response.statusCode == 200) {
      print("OrderAPI: createOrder: response: $response");
      return "Order sucessfully updated";
    } else {
      print("OrderAPI: createOrder: response: $response");
      return Future.error("Failed to create order");
    }
  }
}
