import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/connectivity_bloc/connectivity_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_bloc.dart';
import 'package:langspeak/domain/use_cases/order_usecase/order_usecase.dart';
import 'package:langspeak/infrastructure/driven_adapter/api/order_api/order_api.dart';
// import 'package:langspeak/infrastructure/driven_adapter/local_api/order_local_api.dart';
import 'package:langspeak/ui/pages/show_create_order_page.dart';
import 'package:langspeak/ui/pages/show_delete_order_page.dart';
import 'package:langspeak/ui/pages/show_one_order_page.dart';
import 'package:langspeak/ui/pages/show_order_page.dart';
import 'package:langspeak/ui/pages/show_update_order_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final orderAPI = OrderAPI();
    // final orderLocalAPI = OrderLocalAPI();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderBloc(OrderUseCase(orderAPI)),
          // create: (context) => OrderBloc(OrderUseCase(orderAPI)),

          // OrderBloc(OrderUseCase(orderAPI))..add(GetAllOrdersEvent()),
        ),
        BlocProvider(create: (_) => ConnectivityBloc())
      ],
      child: MaterialApp(
        title: 'Bloc Example Orders',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ShowOrderPage(),
          '/getOneOrder': (context) => const ShowOneOrderPage(),
          '/createOneOrder': (context) => const ShowCreateOrderPage(),
          '/updateOneOrder': (context) => const ShowUpdateOrderPage(),
          '/deleteOneOrder': (context) => const ShowDeleteOrderPage(),
        },
      ),
    );
  }
}
