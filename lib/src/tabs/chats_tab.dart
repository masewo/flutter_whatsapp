import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/config/application.dart';
import 'package:flutter_whatsapp/src/helpers/dialog_helpers.dart';
import 'package:flutter_whatsapp/src/models/chat_list.dart';
import 'package:flutter_whatsapp/src/models/chat.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter_whatsapp/src/widgets/chat_item.dart';
import 'package:flutter_whatsapp/src/widgets/deprecated/raised_button.dart';

class ChatsTab extends StatelessWidget {
  final String searchKeyword;
  final Future<dynamic> chatList;
  final VoidCallback refresh;

  const ChatsTab({Key key,
    this.chatList,
    this.searchKeyword,
    this.refresh,
  }) : super(key: key);

  Icon _getIconSubtitle(Chat chat) {
    if (!chat.lastMessage.isYou) return null;

    if (chat.lastMessage.isRead) {
      return const Icon(
        Icons.done_all,
        color: blueCheckColor,
        size: 16.0,
      );
    } else {
      return const Icon(
        Icons.done_all,
        color: Colors.grey,
        size: 16.0,
      );
    }
  }

  void onTapChatItem(BuildContext context, Chat chat) {
    Application.router.navigateTo(
        context,
        "/chat?profileId=${chat.id}",
      transition: TransitionType.inFromRight,
    );
  }

  void onTapProfileChatItem(BuildContext context, Chat chat) {
    Dialog profileDialog = DialogHelpers.getProfileDialog(
        context: context,
        id: chat.id,
        imageUrl: chat.avatarUrl,
        name: chat.name,
        );
    showDialog(
        context: context, builder: (BuildContext context) => profileDialog);
  }

  Widget _buildChatItem(BuildContext context, searchKeyword, Chat chat) {
    return ChatItem(
        chat: chat,
        searchKeyword: searchKeyword,
        iconSubtitle: _getIconSubtitle(chat),
        onTapProfile: () => onTapProfileChatItem(context, chat),
        onTap: () => onTapChatItem(context, chat));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: chatList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center,),
                  RaisedButton(
                    onPressed: refresh,
                    child: const Text('Refresh'),
                  )
                ]
              );
            }
            ChatList shownChatList = snapshot.data;
            bool isFound = false;
            return ListView.builder(
                itemCount: shownChatList.chats.length,
                itemBuilder: (context, i) {
                  if (searchKeyword.isNotEmpty) {
                    if (!shownChatList.chats[i].name
                        .toLowerCase()
                        .contains(searchKeyword.toLowerCase())) {
                      if (!isFound && i >= shownChatList.chats.length - 1) {
                        return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                  'No results found for \'$searchKeyword\''),
                            ));
                      }
                      return const SizedBox(
                        height: 0.0,
                      );
                    }
                  }
                  isFound = true;
                  return _buildChatItem(
                      context, searchKeyword, shownChatList.chats[i]);
                });
        }
        return null; // unreachable
      },
    );
  }
}