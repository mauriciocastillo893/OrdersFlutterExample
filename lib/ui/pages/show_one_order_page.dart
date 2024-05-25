import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_event.dart';
import 'package:langspeak/config/providers/order_bloc/order_state.dart';

class ShowOneOrderPage extends StatelessWidget {
  const ShowOneOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("One order"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el ID de la orden',
                  labelText: 'ID de la orden',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String orderId = textEditingController.text;
                  if (orderId.isNotEmpty) {
                    print("Value: ${textEditingController.text}");
                    BlocProvider.of<OrderBloc>(context)
                        .add(GetOrderEvent(orderId));
                  }
                },
                child: const Text('Obtener orden'),
              ),
              const SizedBox(height: 16),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrdersInitialState) {
                    return const Text('Press the button to fetch orders');
                  } else if (state is OrderLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetOrderState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${state.order.id}'),
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
