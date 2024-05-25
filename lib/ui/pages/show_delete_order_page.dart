import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_event.dart';
import 'package:langspeak/config/providers/order_bloc/order_state.dart';

class ShowDeleteOrderPage extends StatelessWidget {
  const ShowDeleteOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController idEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete an order"),
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
              ElevatedButton(
                onPressed: () {
                  String id = idEditingController.text;
                  if (id.isNotEmpty) {
                    print("Vsalue: ${id}");
                    BlocProvider.of<OrderBloc>(context)
                        .add(DeleteOrderEvent(id));
                  }
                },
                child: const Text('Eliminar una orden'),
              ),
              const SizedBox(height: 16),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrdersInitialState) {
                    return const Text('Press the button to fetch orders');
                  } else if (state is OrderLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DeleteOrderState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order succesfully deleted. ID: ${state.id}'),
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
