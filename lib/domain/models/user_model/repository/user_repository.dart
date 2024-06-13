
// import 'package:langspeak/domain/models/user_model/user_model.dart';

import 'package:langspeak/domain/models/message_model/message_model.dart';

abstract class UserRepository{
  Future<List> getAllUsers();
  Future<Map<String, Object>> registerUser(String name, String email, String password);
  Future<Map<String, Object>> loginUser(String email, String password);
  Future<void> sendMessage(Message message, String targetId);
  Future<List<Message>> getMessages(String userId);
  // Future<String> logoutUser();
}