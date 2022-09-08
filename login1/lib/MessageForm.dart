import 'package:flutter/material.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({Key? key}) : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  var _userEnterMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 7),
      child: Row(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(20.0)),
            child: Row(
              children: [
                Flexible(
                    child: IconButton(
                        iconSize: 20.0,
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey))),
                SizedBox(
                  width: 210,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _userEnterMessage = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                          child: IconButton(
                            iconSize: 20.0,
                            onPressed: () {},
                            icon: const Icon(Icons.attach_file, color: Colors.grey),
                          )),
                      Flexible(
                          child: IconButton(
                            iconSize: 20.0,
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt, color: Colors.grey),
                          ))
                    ],
                  ),
                )
              ],
            ),
          )),
          ElevatedButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : () {},
            style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                shape: const CircleBorder(),
                fixedSize: const Size(40, 40)),
            child: const Icon(Icons.send, color: Colors.white),
          )
        ],
      ),
    );
  }
}
