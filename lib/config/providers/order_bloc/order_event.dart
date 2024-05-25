import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:langspeak/domain/models/order_model/order_model.dart';

@immutable
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrdersInitialEvent extends OrderEvent {}

class GetAllOrdersEvent extends OrderEvent {
  const GetAllOrdersEvent();

  @override
  List<Object> get props => [];
}

class GetOrderEvent extends OrderEvent {
  final String orderId;

  const GetOrderEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class CreateOrderEvent extends OrderEvent {
  final OrderModel orderModel;

  const CreateOrderEvent(this.orderModel);

  @override
  List<Object> get props => [orderModel];
}

class UpdateOrderEvent extends OrderEvent {
  final String id;
  final String status;

  const UpdateOrderEvent(this.id, this.status);

  @override
  List<Object> get props => [id, status];
}

class DeleteOrderEvent extends OrderEvent {
  final String orderId;

  const DeleteOrderEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class OrderLoadingEvent extends OrderEvent {}

class OrderErrorEvent extends OrderEvent {}
