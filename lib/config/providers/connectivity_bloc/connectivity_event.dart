import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;
  final String typeOfConnection;

  const ConnectivityChanged({required this.isConnected, required this.typeOfConnection});

  @override
  List<Object> get props => [isConnected, typeOfConnection];
}
