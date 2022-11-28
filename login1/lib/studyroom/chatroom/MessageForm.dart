import 'dart:io';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageForm extends StatefulWidget {
  final String studyID;
  const MessageForm({Key? key, required this.studyID}) : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final TextEditingController _controller = TextEditingController();
  String _userEnterMessage = '';
  bool emojiShowing = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;

  _onEmojiSelected(Emoji emoji) {
    print('_onEmojiSelected: ${emoji.emoji}');
    setState(() {
      _userEnterMessage = emoji.emoji;
    });
  }

  _onBackspacePressed() {
    print('_onBackspacePressed');
    if (_controller.text.isEmpty) {
      setState(() {
        _userEnterMessage = '';
      });
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 7),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            onPressed: () {
                              setState(() {
                                FocusManager.instance.primaryFocus?.unfocus();
                                emojiShowing = !emojiShowing;
                              });
                            },
                            icon: !emojiShowing
                                ? const Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.grey,
                                  ))),
                    SizedBox(
                      width: 210,
                      child: TextField(
                        onTap: () {
                          setState(() {
                            emojiShowing = false;
                          });
                        },
                        controller: _controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
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
                            icon: const Icon(Icons.attach_file,
                                color: Colors.grey),
                          )),
                          Flexible(
                              child: IconButton(
                            iconSize: 20.0,
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.grey),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              )),
              ElevatedButton(
                onPressed: _controller.text.isEmpty ? null : () async {

                  String Nickname = "";
                  await db.collection("users").doc(uid).get().then((value) => Nickname = value.data()!["Nickname"]);

                  await db.collection("studyroom").doc(widget.studyID).collection("talk").doc().set({
                    "text": _userEnterMessage,
                    "Nickname": Nickname,
                    "time": DateTime.now(),
                  }).onError((error, stackTrace) => print(error));
                  setState(() {
                    _userEnterMessage = "";
                    _controller.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: const CircleBorder(),
                    fixedSize: const Size(50, 50)),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: _controller,
                onEmojiSelected: (Category? category, Emoji emoji) {
                  _onEmojiSelected(emoji);
                },
                onBackspacePressed: _onBackspacePressed,
                config: Config(
                    columns: 7,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFE6E6E6),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    // progressIndicatorColor: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      '최근 항목 없음',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black26,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.CUPERTINO,
                    checkPlatformCompatibility: true),
              ),
            ),
          )
        ],
      ),
    );
  }
}
