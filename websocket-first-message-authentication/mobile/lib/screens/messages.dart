import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_state_provider.dart';
import '../providers/chat_provider.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final chatStateNotifier = ref.read(chatStateProvider.notifier);

      chatStateNotifier
          .ready()
          .then((_) => chatStateNotifier.listenMessagesStream());
    });
  }

  void _handleSendPressed(
    types.PartialText message,
  ) {
    final chatStateNotifier = ref.read(chatStateProvider.notifier);
    chatStateNotifier.sendTextMessage(message.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authNotifier = ref.read(authStateProvider.notifier);
    final chatState = ref.watch(chatStateProvider);
    final user = ref.watch(
      authUserProvider.select((user) => types.User(id: user.id)),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: const Text('Messages'),
          backgroundColor: theme.colorScheme.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              color: Colors.white,
              onPressed: () => {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    final navigator = Navigator.of(context);

                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            authNotifier.signOut().then((_) => navigator.pop());
                          },
                          child: const Text('Sign out'),
                        ),
                      ],
                      cancelButton: CupertinoButton(
                        child: const Text('Close'),
                        onPressed: () => navigator.pop(false),
                      ),
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 96,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
              ),
            ),
            const ListTile(
              title: Text('Item 1'),
            ),
            const ListTile(
              title: Text('Item 2'),
            ),
          ],
        ),
      ),
      body: Chat(
        messages: chatState.messages,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: user,
      ),
    );
  }
}
