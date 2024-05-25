import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      add(ConnectivityChanged(
          isConnected: result.contains(ConnectivityResult.none) ? false : true,
          typeOfConnection: (ConnectivityResult.wifi == ConnectivityResult.wifi
              ? "Wi-Fi"
              : ConnectivityResult.mobile == ConnectivityResult.mobile
                  ? "Mobile Data"
                  : "Not found"))); // Modify this line
    });

    on<ConnectivityChanged>((event, emit) {
      setConnectionKey(event.isConnected);
      if (event.isConnected) {
        emit(ConnectivitySuccess(event.isConnected, event.typeOfConnection));
      } else {
        emit(ConnectivityFailure());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }

  void setConnectionKey(bool isConnected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isConnected', isConnected);
  }

  Future<bool> getConnectionKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isConnected = prefs.getBool('isConnected');
    return isConnected ??= false;
  }
}
