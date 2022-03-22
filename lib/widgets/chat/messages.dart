import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = FirebaseAuth.instance.currentUser;
        final docs =
            (snapshot.data as QuerySnapshot<Map<String, dynamic>>).docs;

        return ListView.builder(
          itemBuilder: (_, index) => MessageBubble(
              message: docs[index]['text'],
              username: docs[index]['username'],
              isMe: docs[index]['userId'] == user?.uid,
              key: ValueKey(docs[index].id)),
          itemCount: docs.length,
          reverse: true,
        );
      },
    );
  }
}
