import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_event.dart';
import 'package:langspeak/config/providers/order_bloc/order_state.dart';

class ShowUpdateOrderPage extends StatelessWidget {
  const ShowUpdateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController idEditingController = TextEditingController();
    TextEditingController statusEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update an order"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: idEditingController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el ID de la orden a cambiar',
                  labelText: 'ID de la orden a cambiar',
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
                  String id = idEditingController.text;
                  String status = statusEditingController.text;
                  if (id.isNotEmpty && status.isNotEmpty) {
                    print("Vsalue: ${id}, ${status}");
                    BlocProvider.of<OrderBloc>(context)
                        .add(UpdateOrderEvent(id, status));
                  }
                },
                child: const Text('Actualizar una orden'),
              ),
              const SizedBox(height: 16),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrdersInitialState) {
                    return const Text('Press the button to fetch orders');
                  } else if (state is OrderLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UpdateOrderState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order succesfully updated'),
                        Text('Status: ${state.status}'),
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
