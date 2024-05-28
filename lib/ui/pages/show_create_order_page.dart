import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_event.dart';
import 'package:langspeak/config/providers/order_bloc/order_state.dart';
import 'package:langspeak/domain/models/order_model/order_model.dart';

class ShowCreateOrderPage extends StatelessWidget {
  const ShowCreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController createdAtEditingController = TextEditingController();
    TextEditingController totalAmountEditingController =
        TextEditingController();
    TextEditingController statusEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an order"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: createdAtEditingController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese la fecha de creación de la orden',
                  labelText: 'Fecha de creación de la orden',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: totalAmountEditingController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el precio total de la orden',
                  labelText: 'Precio total de la orden',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: statusEditingController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el status de la orden',
                  labelText: 'Status de la orden',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String createdAt = createdAtEditingController.text;
                  String totalAmount = totalAmountEditingController.text;
                  String status = statusEditingController.text;
                  if (createdAt.isNotEmpty &&
                      totalAmount.isNotEmpty &&
                      status.isNotEmpty) {
                    print("Vsalue: $createdAt, $totalAmount, $status");
                    BlocProvider.of<OrderBloc>(context).add(CreateOrderEvent(
                        OrderModel(
                            createdAt: createdAt,
                            totalAmount: totalAmount,
                            status: status)));
                  }
                },
                child: const Text('Crear orden'),
              ),
              const SizedBox(height: 16),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrdersInitialState) {
                    return const Text('Press the button to fetch orders');
                  } else if (state is OrderLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CreateOrderState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order succesfully created'),
                        Text('Created At: ${state.order.createdAt}'),
                        Text('Total Amount: ${state.order.totalAmount}'),
                        Text('Status: ${state.order.status}'),
                      ],
                    );
                  } else if (state is OrdersErrorState) {
                    return Text('Error: ${state.message}');
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
