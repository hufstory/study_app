import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login1/messages.dart';

import 'MessageForm.dart';

class ChatRoom extends StatefulWidget {
  final String name;

  const ChatRoom({Key? key, required this.name}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.pending_outlined, color: Colors.black))
        ],
        title: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Text('${widget.name} 자유 채팅방',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Messages(),
            MessageForm()
          ],
        ),
      ),
    );
  }
}
