import 'package:cloud_firestore/cloud_firestore.dart';

// enum FromWho { mine, theirs }

class Message {
  final String text;
  final String urlMultimedia;
  final String whoSend;
  final String whoReceive;
  final Timestamp timestamp;

  Message(
      {required this.text,
      required this.urlMultimedia,
      required this.whoSend,
      required this.whoReceive,
      required this.timestamp});

  factory Message.fromFirestore(Map<String, dynamic> data, String id) {
    return Message(
      whoSend: data['whoSend'] ?? '',
      whoReceive: data['whoReceive'] ?? '',
      text: data['text'] ?? '',
      urlMultimedia: data['urlMultimedia'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'whoSend': whoSend,
      'whoReceive': whoReceive,
      'text': text,
      'urlMultimedia': urlMultimedia,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'Message{whoSend: $whoSend, whoReceive: $whoReceive, text: $text, urlMultimedia: $urlMultimedia, timestamp: $timestamp}';
  }
}
