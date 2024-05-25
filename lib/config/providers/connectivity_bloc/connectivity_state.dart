import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

// Initial state before any connectivity check
class ConnectivityInitial extends ConnectivityState {}

// State when connectivity check is successful
class ConnectivitySuccess extends ConnectivityState {
  final bool isConnected;
  final String typeOfConnection;

  const ConnectivitySuccess(this.isConnected, this.typeOfConnection);

  @override
  List<Object> get props => [isConnected, typeOfConnection];
}

// State when there is no connectivity
class ConnectivityFailure extends ConnectivityState {
  @override
  List<Object> get props => [];
}
