
import 'package:langspeak/domain/models/message_model/message_model.dart';
import 'package:langspeak/domain/models/user_model/repository/user_repository.dart';
// import 'package:langspeak/domain/models/user_model/user_model.dart';

class UserUseCase {
  final UserRepository userRepository;
  UserUseCase(this.userRepository);

  Future<List> getAllUsers() async {
    return userRepository.getAllUsers();
  }

  Future<Map<String, Object>> loginUser(String email, String password) async {
    return userRepository.loginUser(email, password);
  }

  Future<Map<String, Object>> registerUser(String name, String email, String password) async {
    return userRepository.registerUser(name, email, password);
  }

  Future<List<Message>> getMessages(String userId){
    return userRepository.getMessages(userId);
  }

  Future<void> sendMessage(Message message, String targetId){
    return userRepository.sendMessage(message, targetId);
  }

}