import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:langspeak/domain/models/message_model/message_model.dart';

@immutable
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserErrorState extends UserState {
  final String message;
  const UserErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class GetAllUsersState extends UserState {
  final List<dynamic> users;
  const GetAllUsersState(this.users);

  @override
  List<Object> get props => [users];
}

class RegisterUserState extends UserState {
  final String name;
  final String email;
  final String password;
  final bool isRegisterCorrectly;
  final String eventMsg;

  const RegisterUserState(this.name, this.email, this.password,
      this.isRegisterCorrectly, this.eventMsg);

  @override
  List<Object> get props =>
      [name, email, password, isRegisterCorrectly, eventMsg];
}

class LoginUserState extends UserState {
  final String email;
  final String password;
  final bool isLoginCorrectly;
  final String eventMsg;

  const LoginUserState(
      this.email, this.password, this.isLoginCorrectly, this.eventMsg);

  @override
  List<Object> get props => [email, password, isLoginCorrectly, eventMsg];
}

class GetMessagesState extends UserState {
  final String userId;
  final List<Message> messages;

  const GetMessagesState(this.userId, this.messages);

  @override
  List<Object> get props => [userId, messages];
}

class SendMessageState extends UserState {
  final String targetId;
  final Message message;

  const SendMessageState(this.message, this.targetId);

  @override
  List<Object> get props => [message, targetId];
}
