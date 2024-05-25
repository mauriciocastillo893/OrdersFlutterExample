import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:langspeak/domain/models/order_model/order_model.dart';

@immutable
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrdersInitialState extends OrderState {}

class GetAllOrdersState extends OrderState {
  final List<OrderModel> orders;
  const GetAllOrdersState(this.orders);

  @override
  List<Object> get props => [orders];
}

class GetOrderState extends OrderState {
  final OrderModel order;
  const GetOrderState(this.order);

  @override
  List<Object> get props => [order];
}

class CreateOrderState extends OrderState {
  final OrderModel order;
  const CreateOrderState(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrderState extends OrderState {
  final String id;
  final String status;
  const UpdateOrderState(this.id, this.status);

  @override
  List<Object> get props => [id, status];
}

class DeleteOrderState extends OrderState {
  final String id;
  const DeleteOrderState(this.id);

  @override
  List<Object> get props => [id];
}

class OrderLoadingState extends OrderState {}

class OrdersErrorState extends OrderState {
  final String message;
  const OrdersErrorState(this.message);

  @override
  List<Object> get props => [message];
}
