import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_twizza_connect_test/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var messagesCollection = FirebaseFirestore.instance
        .collection('chat/CmZVRkzumcW1Sxsiuxo6/messages');

    return StreamBuilder(
      stream: messagesCollection
          .orderBy('createdTime', descending: true)
          .snapshots(),
      builder: (ctx, chapSnapshot) {
        if (chapSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = chapSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            var currentDoc = chatDocs[index];
            return MessageBubble(
              currentDoc['text'],
              currentDoc['username'],
              currentDoc['userImage'],
              currentDoc['createdByUserId'] ==
                  FirebaseAuth.instance.currentUser.uid,
              key: ValueKey(currentDoc.id),
            );
          },
        );
      },
    );
  }
}
