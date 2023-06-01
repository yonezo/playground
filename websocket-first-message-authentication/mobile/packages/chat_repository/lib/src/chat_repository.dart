import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'event.dart';

abstract class ChatRepository {
  Future<void> ready(String idToken);
  Future<void> close();

  Stream<Event> getChatStream();

  void sendTextMessage({
    required String uid,
    required String text,
  });
}

class ChatRepositoryImpl implements ChatRepository {
  final WebSocketChannel _webSocketChannel;

  ChatRepositoryImpl({
    required WebSocketChannel webSocketChannel,
  }) : _webSocketChannel = webSocketChannel;

  @override
  Future<void> ready(String idToken) async {
    await _webSocketChannel.ready;

    final event = EventAuthentication(token: idToken);
    _webSocketChannel.sink.add(jsonEncode(event));
  }

  @override
  Future<void> close() async {
    await _webSocketChannel.sink.close();
  }

  @override
  Stream<Event> getChatStream() {
    return _webSocketChannel.stream.map((rawJson) {
      Map<String, dynamic> json = jsonDecode(rawJson);
      return Event.fromJson(json);
    });
  }

  @override
  void sendTextMessage({
    required String uid,
    required String text,
  }) {
    final event = EventMessage(text: text, uid: uid);
    _webSocketChannel.sink.add(jsonEncode(event));
  }
}
