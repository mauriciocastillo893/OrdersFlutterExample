// show_order_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/connectivity_bloc/connectivity_bloc.dart';
import 'package:langspeak/config/providers/connectivity_bloc/connectivity_state.dart';
import 'package:langspeak/config/providers/order_bloc/order_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_event.dart';
import 'package:langspeak/config/providers/order_bloc/order_state.dart';

class ShowOrderPage extends StatelessWidget {
  const ShowOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<OrderBloc>(context).add(const GetAllOrdersEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text("All my orders"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              // Listen for changes in connectivity state
              child: BlocListener<ConnectivityBloc, ConnectivityState>(
                listener: (context, state) {
                  if (state is ConnectivityFailure) {
                    // Show snackbar when there is no connection
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No internet connection'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                // Build UI based on connectivity state
                child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
                  builder: (context, state) {
                    if (state is ConnectivityInitial) {
                      return const Text('Checking connectivity...');
                    } else if (state is ConnectivitySuccess) {
                      return Text(
                          '${state.isConnected ? "Connected" : "Not Connected"} ${state.typeOfConnection}');
                    } else if (state is ConnectivityFailure) {
                      return const Text('Not Connected');
                    }
                    return Container();
                  },
                ),
              ),
            ),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrdersInitialState) {
                  return const Center(
                    child: Text('Press the button to fetch orders'),
                  );
                } else if (state is OrderLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetAllOrdersState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          state.orders[index].toString(), // Ajusta esto según tus datos
                        ),
                      );
                    },
                  );
                } else if (state is OrdersErrorState) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<OrderBloc>(context)
                  .add(const GetAllOrdersEvent());
              if (ModalRoute.of(context)?.settings.name != '/') {
                Navigator.pushNamed(context, '/');
                print("No estoy, navegando a 'All my orders'");
              }
            },
            heroTag: null,
            tooltip: "Todas las ordenes",
            child: const Icon(Icons.all_inbox_rounded),
          ),
          const SizedBox(height: 16), // Espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              // BlocProvider.of<OrderBloc>(context).add(GetOrderEvent());
              if (ModalRoute.of(context)?.settings.name != '/getOneOrder') {
                Navigator.pushNamed(context, '/getOneOrder');
                print("No estoy, navegando a 'One order'");
              }
            },
            heroTag: null,
            tooltip: "Obtener una orden",
            child: const Icon(Icons.looks_one_outlined),
          ),
          const SizedBox(height: 16), // Espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<OrderBloc>(context)
                  .add(const GetAllOrdersEvent());
              if (ModalRoute.of(context)?.settings.name != '/createOneOrder') {
                Navigator.pushNamed(context, '/createOneOrder');
                print("No estoy, navegando a 'Creating my order'");
              }
            },
            heroTag: null,
            tooltip: "Crear una orden",
            child: const Icon(Icons.create_new_folder_outlined),
          ),
          const SizedBox(height: 16), // Espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<OrderBloc>(context)
                  .add(const GetAllOrdersEvent());
              if (ModalRoute.of(context)?.settings.name != '/updateOneOrder') {
                Navigator.pushNamed(context, '/updateOneOrder');
                print("No estoy, navegando a 'Updating one order'");
              }
            },
            heroTag: null,
            tooltip: "Editar una orden",
            child: const Icon(Icons.edit_document),
          ),
          const SizedBox(height: 16), // Espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/deleteOneOrder') {
                Navigator.pushNamed(context, '/deleteOneOrder');
                print("No estoy, navegando a 'Deleting one order'");
              }
            },
            heroTag: null,
            tooltip: "Eliminar una orden",
            child: const Icon(Icons.delete_forever_outlined),
          ),
        ],
      ),
    );
  }
}
