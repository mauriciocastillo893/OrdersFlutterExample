import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/connectivity_bloc/connectivity_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_event.dart';
import 'package:langspeak/config/providers/order_bloc/order_state.dart';
import 'package:langspeak/domain/use_cases/order_usecase/order_usecase.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderUseCase orderUseCase;
  final ConnectivityBloc connectivityBloc = ConnectivityBloc();
  OrderBloc(this.orderUseCase) : super(OrdersInitialState()) {
    on<GetAllOrdersEvent>(_onGetAllOrdersEvent);
    on<GetOrderEvent>(_onGetOrderEvent);
    on<CreateOrderEvent>(_onCreateOrderEvent);
    on<UpdateOrderEvent>(_onUpdateOrderEvent);
    on<DeleteOrderEvent>(_onDeleteOrderEvent);
  }

  void _onGetAllOrdersEvent(
      GetAllOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      final orders = await orderUseCase.getAllOrders();
      emit(GetAllOrdersState(orders));
      bool isConnected = await connectivityBloc.getConnectionKey();
      print("Estoy conectado? ${isConnected ? "Sí" : "No"}");
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  void _onGetOrderEvent(GetOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      final order = await orderUseCase.getOrder(event.orderId);
      emit(GetOrderState(order));
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  void _onCreateOrderEvent(
      CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      final order = await orderUseCase.createOrder(event.orderModel);
      emit(CreateOrderState(order));
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  void _onUpdateOrderEvent(
      UpdateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      await orderUseCase.updateOrder(event.id, event.status);
      emit(UpdateOrderState(event.id, event.status));
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }

  void _onDeleteOrderEvent(
      DeleteOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      final orderId = await orderUseCase.deleteOrder(event.orderId);
      emit(DeleteOrderState(orderId));
    } catch (e) {
      emit(OrdersErrorState(e.toString()));
    }
  }
}
