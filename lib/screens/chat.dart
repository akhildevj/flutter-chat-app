import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const messageUrl = 'chats/Jibj6hyXXSRDbvnRohmo/messages';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AkzChat'), actions: [
        DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Text('Logout')
                ]),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            })
      ]),
      body: Column(
        children: const [Expanded(child: Messages()), NewMessage()],
      ),
    );
  }
}
