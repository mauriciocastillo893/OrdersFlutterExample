import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_event.dart';
import 'package:langspeak/config/providers/user_bloc/user_state.dart';
import 'package:langspeak/domain/use_cases/user_usecase/user_usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserUseCase userUseCase;

  UserBloc(this.userUseCase) : super(UserInitialState()) {
    on<GetAllUsersEvent>(_onGetAllUsersEvent);
    on<RegisterUserEvent>(_onRegisterUserEvent);
    on<LoginUserEvent>(_onLoginUserEvent);
    on<UserErrorEvent>(_onUserErrorEvent);
    on<GetMessagesEvent>(_onShowMessageEvent);
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  void _onGetAllUsersEvent(
      GetAllUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final users = await userUseCase.getAllUsers();
      emit(GetAllUsersState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  void _onRegisterUserEvent(
      RegisterUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final isRegisterCorrectly = await userUseCase.registerUser(
          event.name, event.email, event.password);
      emit(RegisterUserState(event.name, event.email, event.password, true,
          isRegisterCorrectly['msg'] as String));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  void _onLoginUserEvent(LoginUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final isLoginCorrectly =
          await userUseCase.loginUser(event.email, event.password);
      emit(LoginUserState(
          event.email,
          event.password,
          isLoginCorrectly['status'] as bool,
          isLoginCorrectly['msg'] as String));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  void _onUserErrorEvent(UserErrorEvent event, Emitter<UserState> emit) async {
    emit(const UserErrorState("Error: Campos vacíos"));
    await Future.delayed(const Duration(seconds: 5));
    emit(UserInitialState());
  }

  void _onShowMessageEvent(
      GetMessagesEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final messages = await userUseCase.getMessages(event.userId);
      print("User ${event.userId} Messages: $messages ");
      emit(GetMessagesState(event.userId, messages));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  void _onSendMessageEvent(
      SendMessageEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      await userUseCase.sendMessage(event.message, event.targetId);
      emit(SendMessageState(event.message, event.targetId));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
