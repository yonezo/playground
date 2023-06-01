import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'auth_repository_provider.dart';
import 'auth_state_provider.dart';
import 'chat_state.dart';

final chatRepositoryProvider = Provider.autoDispose<ChatRepository>((ref) {
  final wsUrl = Uri.parse('ws://localhost:8080');
  final channel = WebSocketChannel.connect(wsUrl);
  return ChatRepositoryImpl(webSocketChannel: channel);
});

final chatStateProvider =
    StateNotifierProvider.autoDispose<ChatStateNotifier, ChatState>(
  (ref) => ChatStateNotifier(
    chatRepository: ref.watch(chatRepositoryProvider),
    ref: ref,
  ),
);

class ChatStateNotifier extends StateNotifier<ChatState> {
  final ChatRepository chatRepository;
  final StateNotifierProviderRef ref;

  ChatStateNotifier({
    required this.chatRepository,
    required this.ref,
  }) : super(ChatState());

  @override
  void dispose() async {
    await chatRepository.close();
    super.dispose();
  }

  Future<void> ready() async {
    try {
      final idToken = await ref.watch(authRepositoryProvider).getIdToken();
      await chatRepository.ready(idToken);
      state = state.copyWith(isReady: true);
      ref.onDispose(() async {
        await chatRepository.close();
        state = state.copyWith(isReady: false);
      });
    } catch (_) {
      throw 'An id token must be obtained first';
    }
  }

  void sendTextMessage(String text) {
    assert(state.isReady);

    final uid = ref.watch(authUserProvider).id;
    chatRepository.sendTextMessage(uid: uid, text: text);
    state = state.copyWith(messages: [
      types.TextMessage(
        author: types.User(
          id: uid,
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: text,
      ),
      ...state.messages,
    ]);
  }

  void listenMessagesStream() {
    assert(state.isReady);

    chatRepository.getChatStream().listen((event) {
      event.map(message: (message) {
        state = state.copyWith(messages: [
          types.TextMessage(
            author: types.User(
              id: message.uid,
            ),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: message.text,
          ),
          ...state.messages,
        ]);
      }, authentication: (_) {
        throw UnimplementedError();
      });
    });
  }
}
