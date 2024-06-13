import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:langspeak/domain/models/message_model/message_model.dart';

@immutable
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserInitialEvent extends UserEvent {}

class UserLoadingEvent extends UserEvent {}

class UserErrorEvent extends UserEvent {
  final String message;

  const UserErrorEvent(this.message);

  @override
  List<Object> get props => [message];
}

class GetAllUsersEvent extends UserEvent {
  const GetAllUsersEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends UserEvent {
  final String name;
  final String email;
  final String password;
  final bool? isRegisterCorrectly;
  final String? eventMsg;

  const RegisterUserEvent(this.name, this.email, this.password,
      {this.isRegisterCorrectly, this.eventMsg});

  @override
  List<Object> get props => [name, email, password, isRegisterCorrectly!, eventMsg!];
}

class LoginUserEvent extends UserEvent {
  final String email;
  final String password;
  final bool? isLoginCorrectly;
  final String? eventMsg;

  const LoginUserEvent(this.email, this.password, {this.isLoginCorrectly, this.eventMsg});

  @override
  List<Object> get props => [email, password, isLoginCorrectly!, eventMsg!];
}

class GetMessagesEvent extends UserEvent {
  final String userId;

  const GetMessagesEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class SendMessageEvent extends UserEvent {
  final String targetId;
  final Message message;

  const SendMessageEvent(this.message, this.targetId);

  @override
  List<Object> get props => [message, targetId];
}
