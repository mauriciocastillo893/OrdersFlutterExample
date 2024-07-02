import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/connectivity_bloc/connectivity_bloc.dart';
import 'package:langspeak/config/providers/order_bloc/order_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_bloc.dart';
import 'package:langspeak/domain/use_cases/order_usecase/order_usecase.dart';
import 'package:langspeak/domain/use_cases/user_usecase/user_usecase.dart';
import 'package:langspeak/infrastructure/driven_adapter/api/order_api/order_api.dart';
import 'package:langspeak/infrastructure/driven_adapter/api/user_api/user_api.dart';
// import 'package:langspeak/infrastructure/driven_adapter/local_api/order_local_api.dart';
import 'package:langspeak/ui/pages/order/show_create_order_page.dart';
import 'package:langspeak/ui/pages/order/show_delete_order_page.dart';
import 'package:langspeak/ui/pages/order/show_one_order_page.dart';
import 'package:langspeak/ui/pages/order/show_order_page.dart';
import 'package:langspeak/ui/pages/order/show_update_order_page.dart';
import 'package:langspeak/ui/pages/user/show_all_users_page.dart';
import 'package:langspeak/ui/pages/user/show_login_user_page.dart';
import 'package:langspeak/ui/pages/user/show_one_user_page.dart';
import 'package:langspeak/ui/pages/user/show_register_user_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final orderApi = OrderAPI();
    final userApi = UserApi();
    // final orderLocalAPI = OrderLocalAPI();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderBloc(OrderUseCase(orderApi)),
          // create: (context) => OrderBloc(OrderUseCase(orderApi)),
          // OrderBloc(OrderUseCase(orderApi))..add(GetAllOrdersEvent()),
        ),
        BlocProvider(create: (context) => ConnectivityBloc()),
        BlocProvider(create: (context) => UserBloc(UserUseCase(userApi)))
      ],
      child: MaterialApp(
        title: 'Bloc Example Users and Orders',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ShowLoginUserPage(),
          '/signUp': (context) => const ShowRegisterUserPage(),
          '/menu': (context) => const ShowAllUsersPage(),
          '/menuOneUser': (context) => const ShowOneUserPage(),
          '/getAllOrder': (context) => const ShowOrderPage(),
          '/getOneOrder': (context) => const ShowOneOrderPage(),
          '/createOneOrder': (context) => const ShowCreateOrderPage(),
          '/updateOneOrder': (context) => const ShowUpdateOrderPage(),
          '/deleteOneOrder': (context) => const ShowDeleteOrderPage(),
        },
      ),
    );
  }
}
