import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langspeak/config/providers/user_bloc/user_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_event.dart';
import 'package:langspeak/config/providers/user_bloc/user_state.dart';
import 'package:langspeak/domain/models/message_model/message_model.dart';
import 'package:langspeak/domain/models/user_model/repository/user_repository.dart';
import 'package:langspeak/infrastructure/driven_adapter/api/user_api/user_api.dart';
import 'package:video_player/video_player.dart';

class ShowOneUserPage extends StatefulWidget {
  const ShowOneUserPage({
    Key? key,
    this.id = '',
    this.email = '',
    this.username = '',
  }) : super(key: key);

  final String id;
  final String email;
  final String username;

  @override
  State<ShowOneUserPage> createState() => _ShowOneUserPageState();
}

class _ShowOneUserPageState extends State<ShowOneUserPage> {
  File mediaFile = File('');
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
    _userBloc.add(GetMessagesEvent(widget.id));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userBloc = context.read<UserBloc>();
  }

  @override
  void dispose() {
    if (mounted) {
      _userBloc.add(const GetAllUsersEvent());
    }
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<File?> _getMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> _uploadMedia(File mediaFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_media/${DateTime.now().millisecondsSinceEpoch}');

      final uploadTask = storageRef.putFile(mediaFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading media: $e');
      return null;
    }
  }

  void _sendMessage() async {
    final messageText = messageController.text;
    final mediaPath = mediaFile.path;
    final UserRepository userRepository = UserApi();

    if (mediaPath.isNotEmpty || messageText.isNotEmpty) {
      String mediaUrl = '';

      if (mediaPath.isNotEmpty) {
        mediaUrl = (await _uploadMedia(File(mediaPath))) ?? '';
      }

      final message = Message(
        whoSend: FirebaseAuth.instance.currentUser!.uid,
        whoReceive: widget.id,
        text: messageText,
        urlMultimedia: mediaUrl,
        timestamp: Timestamp.now(),
      );

      if (mounted) {
        await userRepository.sendMessage(message, widget.id);
        messageController.clear();
        setState(() {
          mediaFile = File('');
        });
        _userBloc.add(GetMessagesEvent(widget.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _userBloc.add(const GetAllUsersEvent());
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                height: 680,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserInitialState) {
                      return const Center(
                        child: Text("Bienvenido, estamos cargando los datos"),
                      );
                    } else if (state is UserLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetMessagesState) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
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
                            print(message.urlMultimedia.endsWith(".mp4")
                                ? "Video found"
                                : "Image found");
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
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (message.urlMultimedia
                                              .endsWith('.mp4'))
                                            AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: VideoPlayerWidget(
                                                  videoUrl:
                                                      message.urlMultimedia,
                                                ),
                                              ),
                                            )
                                          else
                                            Image.network(
                                              message.urlMultimedia,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {

                                                return const Text(
                                                    'Error loading video');
                                              },
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          if (message.text.isNotEmpty)
                                            Text(
                                              message.text,
                                              style: TextStyle(
                                                color: isCurrentUser
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                        ],
                                      )
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
                      return const Center(
                          child: Text('Ha ocurrido un error (error de State)'));
                    } else {
                      return Center(
                          child: Text('Ha ocurrido un error $state()'));
                    }
                  },
                ),
              ),
            ),
            if (mediaFile.path.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 50,
                child: Container(
                  color: const Color.fromARGB(255, 71, 71, 71),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: mediaFile.path.endsWith('.mp4')
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayerWidget(
                            videoUrl: mediaFile.path,
                          ),
                        )
                      : Image.file(
                          mediaFile,
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
                      icon: const Icon(Icons.videocam),
                      onPressed: () async {
                        final pickedVideo =
                            await _getMedia(ImageSource.gallery, isVideo: true);
                        if (pickedVideo != null) {
                          setState(() {
                            mediaFile = pickedVideo;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () async {
                        final pickedImage =
                            await _getMedia(ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            mediaFile = pickedImage;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
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

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlaying() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlaying,
      child: _controller.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                if (!_controller.value.isPlaying && !_isPlaying)
                  Icon(Icons.play_arrow, size: 50, color: Colors.white),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
