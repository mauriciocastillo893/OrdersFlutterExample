import 'package:langspeak/domain/models/order_model/order_model.dart';
import 'package:langspeak/domain/models/order_model/repository/order_repository.dart';
import 'package:langspeak/infrastructure/helpers/db_helper.dart';

class OrderLocalAPI extends OrderRepository {
  @override
  Future<OrderModel> createOrder(OrderModel orderModel) async {
    final db = await DBHelper.database;
    try {
      await db.insert('orders', orderModel.toJson());
      return orderModel;
    } catch (e) {
      throw Exception("Failed to create order locally: $e");
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final db = await DBHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('orders');
      return List.generate(maps.length, (i) {
        return OrderModel(
          id: maps[i]['id'],
          createdAt: maps[i]['created_at'],
          totalAmount: maps[i]['total_amount'],
          status: maps[i]['status'],
        );
      });
    } catch (e) {
      throw Exception("Failed to get orders locally: $e");
    }
  }

  @override
  Future<String> deleteOrder(String orderId) async {
    final db = await DBHelper.database;
    try {
      await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
      return "Order deleted successfully";
    } catch (e) {
      throw Exception("Failed to delete order locally: $e");
    }
  }

  @override
  Future<OrderModel> getOrder(String orderId) async {
    final db = await DBHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'orders',
        where: 'id = ?',
        whereArgs: [orderId],
      );
      if (maps.isEmpty) {
        throw Exception("Order not found locally");
      }
      return OrderModel(
        id: maps[0]['id'],
        createdAt: maps[0]['created_at'],
        totalAmount: maps[0]['total_amount'],
        status: maps[0]['status'],
      );
    } catch (e) {
      throw Exception("Failed to get order locally: $e");
    }
  }

  @override
  Future<String> updateOrder(String orderId, String status) async {
    final db = await DBHelper.database;
    try {
      await db.update(
        'orders',
        {'status': status},
        where: 'id = ?',
        whereArgs: [orderId],
      );
      return "Order updated successfully";
    } catch (e) {
      throw Exception("Failed to update order locally: $e");
    }
  }
}
