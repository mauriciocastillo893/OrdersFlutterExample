import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langspeak/domain/models/message_model/message_model.dart';
import 'package:langspeak/domain/models/user_model/repository/user_repository.dart';
// import 'package:langspeak/domain/models/user_model/user_model.dart';

class UserApi extends UserRepository {
  // final originUrl = "18.204.70.37:3000";

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      List<Map<String, dynamic>> people = [];

      // Obtener la colección de usuarios
      QuerySnapshot querySnapshot = await db.collection('users').get();

      // Iterar sobre los documentos recuperados
      querySnapshot.docs.forEach((doc) {
        // Obtener los datos del documento y agregar el ID al mapa
        Map<String, dynamic> userData = doc.data()! as Map<String, dynamic>;
        userData['id'] = doc.id; // Añadir el ID al mapa
        people.add(userData);
      });

      print("Usuarios obtenidos: $people");
      return people;
    } catch (e) {
      print("Error al obtener usuarios: $e");
      throw e; // Relanzar el error para manejarlo en la capa superior si es necesario
    }
  }

  Future<Map<String, Object>> loginUser(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Iniciar sesión con Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Obtener datos del usuario desde Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          print("Usuario logueado y datos obtenidos de Firestore");
          return {
            'status': true,
            'msg': 'Usuario logueado correctamente',
            'data': userData
          };
        } else {
          return {
            'status': false,
            'msg': 'No se encontraron datos del usuario en Firestore'
          };
        }
      } else {
        return {'status': false, 'msg': 'Error al iniciar sesión'};
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return {'status': false, 'msg': 'Error al iniciar sesión: $e'};
    }
  }

  @override
  Future<Map<String, Object>> registerUser(
      String name, String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    print("Registrando: $name $email $password");

    // Validar el correo electrónico
    String? emailError = validateEmail(email);
    if (emailError != null) {
      return {
        'status': false,
        'msg': "Email no válido, verifique el correo electrónico"
      };
    }

    // Validar la longitud de la contraseña
    if (password.length < 6) {
      return {
        'status': false,
        'msg': 'La contraseña debe tener al menos 6 caracteres'
      };
    }

    try {
      // Crear el usuario en Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Guardar datos del usuario en Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'username': name,
          'email': email,
          'messages': [],
          // 'profile_picture': 'URL de la imagen',
        });

        print("Usuario registrado y datos guardados en Firestore");
        return {'status': true, 'msg': 'Usuario registrado correctamente'};
      } else {
        print("Error al registrar usuario");
        return {'status': false, 'msg': 'Error al registrar usuario'};
      }
    } catch (e) {
      print("Error al registrar usuario: $e");
      return {'status': false, 'msg': 'Error al registrar usuario'};
    }
  }

  String? validateEmail(String email) {
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  @override
  Future<List<Message>> getMessages(String userId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('messages')
          .doc(currentUserId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      List<Message> messages = querySnapshot.docs.map((doc) {
        return Message.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("Messages obtenidos: $messages");
      return messages;
    } catch (e) {
      throw Exception('Error al obtener los mensajes: $e');
    }
  }

  @override
  Future<void> sendMessage(Message message, String targetId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String senderId = FirebaseAuth.instance.currentUser!.uid;

    print("Enviando mensaje: ${message.toString()} a $targetId");
    print("Remitente: $senderId");
    try {
      // Añadir mensaje a la colección del remitente
      await _firestore
          .collection('messages')
          .doc(senderId)
          .collection('messages')
          .add(message.toMap());

      // Añadir mensaje a la colección del destinatario
      await _firestore
          .collection('messages')
          .doc(targetId)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      throw Exception('Error al enviar el mensaje: $e');
    }
  }
}
