import 'package:cloud_firestore/cloud_firestore.dart';
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

        final docs =
            (snapshot.data as QuerySnapshot<Map<String, dynamic>>).docs;

        return ListView.builder(
          itemBuilder: (_, index) => Text(docs[index]['text']),
          itemCount: docs.length,
          reverse: true,
        );
      },
    );
  }
}
