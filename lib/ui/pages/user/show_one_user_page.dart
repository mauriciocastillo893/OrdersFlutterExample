import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(GetMessagesEvent(widget.id));
    super.initState();
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
                      return const Center(
                          child:
                              Text("Bienvenido, estamos cargando los datos"));
                    } else if (state is UserLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetMessagesState) {
                      if (state.messages.isEmpty) {
                        return const Center(
                          child: ListTile(
                            title: Text('No ha iniciado esta conversación'),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            return ListTile(
                              title: Text(message.text.isEmpty
                                  ? 'Media file'
                                  : message.text),
                            );
                          },
                        );
                      }
                    } else {
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
                          final message = Message(
                            whoSend: FirebaseAuth.instance.currentUser!.uid,
                            whoReceive: widget.id,
                            text: messageText,
                            urlMultimedia: imagePath,
                            timestamp: Timestamp.now(),
                          );

                          BlocProvider.of<UserBloc>(context)
                              .add(SendMessageEvent(message, widget.id));

                          if (imagePath.isNotEmpty) {
                            final bool result = await sendImage(image);
                            if (result) {
                              setState(() {
                                image = File('');
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Imagen enviada'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al enviar la imagen'),
                                ),
                              );
                            }
                          }

                          messageController.clear();
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
