import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_event.dart';
import 'package:langspeak/config/providers/user_bloc/user_state.dart';
import 'package:langspeak/domain/models/message_model/message_model.dart';
import 'package:langspeak/infrastructure/helpers/aux_media_method/select_image.dart';

class ShowOneUserPage extends StatefulWidget {
  const ShowOneUserPage({
    super.key,
    this.id = '',
    this.email = '',
    this.username = '',
  });

  final String id;
  final String email;
  final String username;

  @override
  _ShowOneUserPageState createState() => _ShowOneUserPageState();
}

class _ShowOneUserPageState extends State<ShowOneUserPage> {
  File image = File('');
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(GetMessagesEvent(widget.id));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                height: 680, // Asigna un tamaño específico al contenedor
                // color: const Color.fromARGB(255, 169, 39, 39),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserInitialState) {
                      print('UserInitialState');
                      return const Center(
                        child: Text("Bienvenido, estamos cargando los datos"),
                      );
                    } else if (state is UserLoadingState) {
                      print('UserLoadingState');
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetMessagesState) {
                      print(
                          'GetMessagesState: ${state.messages.length} messages loaded');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                      if (state.messages.isEmpty) {
                        return const Center(
                          child: ListTile(
                            title: Text('No ha iniciado esta conversación'),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            final isCurrentUser = message.whoSend ==
                                FirebaseAuth.instance.currentUser!.uid;
                            return Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: message.urlMultimedia.isNotEmpty
                                    ? Image.network(message.urlMultimedia)
                                    : Text(
                                        message.text,
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                              ),
                            );
                          },
                        );
                      }
                    } else if (state is UserErrorState) {
                      print('UserErrorState: ${state.message}');
                      return const Center(child: Text('Ha ocurrido un error'));
                    } else {
                      print('Unknown State: $state');
                      return const Center(child: Text('Ha ocurrido un error'));
                    }
                  },
                ),
              ),
            ),
            if (image.path.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 50,
                child: Container(
                  color: const Color.fromARGB(255, 71, 71, 71),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.file(
                    image,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                        ),
                        controller: messageController,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () async {
                        final pickedImage = await getImage();
                        if (pickedImage != null) {
                          setState(() {
                            image = File(pickedImage.path);
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final messageText = messageController.text;
                        final imagePath = image.path;

                        if (imagePath.isNotEmpty || messageText.isNotEmpty) {
                          String imageUrl = '';
                          if (imagePath.isNotEmpty) {
                            imageUrl = (await _uploadImage(image)) ?? '';
                          }

                          final message = Message(
                            whoSend: FirebaseAuth.instance.currentUser!.uid,
                            whoReceive: widget.id,
                            text: messageText,
                            urlMultimedia: imageUrl,
                            timestamp: Timestamp.now(),
                          );

                          BlocProvider.of<UserBloc>(context)
                              .add(SendMessageEvent(message, widget.id));

                          messageController.clear();
                          setState(() {
                            image = File('');
                          });

                          BlocProvider.of<UserBloc>(context).add(
                              GetMessagesEvent(widget.id)); // Refetch messages
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
