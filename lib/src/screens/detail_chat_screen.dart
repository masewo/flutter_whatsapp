import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/config/application.dart';
import 'package:flutter_whatsapp/src/config/routes.dart';
import 'package:flutter_whatsapp/src/config/shared_preferences_helpers.dart';
import 'package:flutter_whatsapp/src/models/chat.dart';
import 'package:flutter_whatsapp/src/services/chat_service.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter_whatsapp/src/widgets/deprecated/flat_button.dart';
import 'package:flutter_whatsapp/src/widgets/message_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ChatDetailMenuOptions {
  viewContact,
  media,
  search,
  muteNotifications,
  wallpaper,
  more,
}

enum ChatDetailMoreMenuOptions {
  report,
  block,
  clearChat,
  exportChat,
  addShortcut,
}

class DetailChatScreen extends StatefulWidget {
  final Chat chat;
  final int id;

  const DetailChatScreen({Key key,
    this.chat,
    this.id,
  }) : super(key: key);

  @override
  State<DetailChatScreen> createState() => _DetailChatScreen();
}

class _DetailChatScreen extends State<DetailChatScreen> {
  Chat _chat;
  String _message = '';
  // PopupMenuButton<ChatDetailMoreMenuOptions> _morePopMenu;
  Future<List<Message>> _fMessages;
  List<Message> _messages;
  TextEditingController textFieldController;

  double _fontSize = 15.0; // default = medium
  TextInputAction _textInputAction = TextInputAction.newline;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      int size = prefs.getInt(SharedPreferencesHelpers.fontSize);
      setState(() {
        if(size == 0) { // small
          _fontSize = 13.0;
        }
        else if(size == 1) { // medium
          _fontSize = 15.0;
        }
        else if(size == 2) { // large
          _fontSize = 18.0;
        }
      });
      bool enterIsSend = prefs.getBool(SharedPreferencesHelpers.enterIsSend) ?? SharedPreferencesHelpers.defaultEnterIsSend;
      setState(() {
        if(enterIsSend) {
          _textInputAction = TextInputAction.send;
        }
        else {
          _textInputAction = TextInputAction.newline;
        }
      });
    });

    _chat = widget.chat;
    int chatId = widget.chat?.id ?? widget.id;
    _fMessages =
        ChatService.getChat(chatId).then((chat) {
          setState(() {
            _chat = chat;
            _messages = chat.messages.reversed.toList();
          });
          return null;
        });
    // _morePopMenu = PopupMenuButton<ChatDetailMoreMenuOptions>(
    //   onSelected: _onSelectMoreMenuOption,
    //   itemBuilder: (BuildContext context) {
    //     return [
    //       PopupMenuItem<ChatDetailMoreMenuOptions>(
    //         child: Text('Report'),
    //         value: ChatDetailMoreMenuOptions.report,
    //       ),
    //       PopupMenuItem<ChatDetailMoreMenuOptions>(
    //         child: Text('Block'),
    //         value: ChatDetailMoreMenuOptions.block,
    //       ),
    //       PopupMenuItem<ChatDetailMoreMenuOptions>(
    //         child: Text('Clear chat'),
    //         value: ChatDetailMoreMenuOptions.clearChat,
    //       ),
    //       PopupMenuItem<ChatDetailMoreMenuOptions>(
    //         child: Text('Export chat'),
    //         value: ChatDetailMoreMenuOptions.exportChat,
    //       ),
    //       PopupMenuItem<ChatDetailMoreMenuOptions>(
    //         child: Text('Add shortcut'),
    //         value: ChatDetailMoreMenuOptions.addShortcut,
    //       ),
    //     ];
    //   },
    // );
    textFieldController = TextEditingController()
      ..addListener(() {
        setState(() {
          _message = textFieldController.text;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatDetailScaffoldBgColor,
      appBar: AppBar(
        leading: FlatButton(
          shape: const CircleBorder(),
          padding: const EdgeInsets.only(left: 1.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.arrow_back,
                size: 24.0,
                color: Colors.white,
              ),
              CircleAvatar(
                radius: 15.0,
                backgroundImage: _chat == null ? null : NetworkImage(_chat.avatarUrl),
              ),
            ],
          ),
        ),
        title: Material(
          color: Colors.white.withOpacity(0.0),
          child: InkWell(
            highlightColor: highlightColor,
            splashColor: secondaryColor,
            onTap: () {
              Application.router.navigateTo(
                context,
                //"/profile?id=${_chat.id}",
                Routes.futureTodo,
                transition: TransitionType.inFromRight,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        _chat == null ? '' : _chat.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Video Call Button tapped'))
                  );
                },
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Call Button tapped'))
                  );
                },
              );
            },
          ),
          PopupMenuButton<ChatDetailMenuOptions>(
            tooltip: "More options",
            onSelected: _onSelectMenuOption,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<ChatDetailMenuOptions>(
                  value: ChatDetailMenuOptions.viewContact,
                  child: Text("View contact"),
                ),
                const PopupMenuItem<ChatDetailMenuOptions>(
                  value: ChatDetailMenuOptions.media,
                  child: Text("Media"),
                ),
                const PopupMenuItem<ChatDetailMenuOptions>(
                  value: ChatDetailMenuOptions.search,
                  child: Text("Search"),
                ),
                const PopupMenuItem<ChatDetailMenuOptions>(
                  value: ChatDetailMenuOptions.muteNotifications,
                  child: Text("Mute notifications"),
                ),
                const PopupMenuItem<ChatDetailMenuOptions>(
                  value: ChatDetailMenuOptions.wallpaper,
                  child: Text("Wallpaper"),
                ),
                const PopupMenuItem<ChatDetailMenuOptions>(
                  value: ChatDetailMenuOptions.more,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    title: Text("More"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: FutureBuilder(
                future: _fMessages,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(
child: CircularProgressIndicator(
                          valueColor:
AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      );
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return const Center(
child: CircularProgressIndicator(
                          valueColor:
AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return ListView.builder(
                          reverse: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, i) {
                            return MessageItem(
                              content: _messages[i].content,
                              timestamp: _messages[i].timestamp,
                              isYou: _messages[i].isYou,
                              isRead: _messages[i].isRead,
                              isSent: _messages[i].isSent,
                              fontSize: _fontSize,
                            );
                          });
                  }
                  return null; //
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          padding: const EdgeInsets.all(0.0),
                          disabledColor: iconColor,
                          color: iconColor,
                          icon: const Icon(Icons.insert_emoticon),
                          onPressed: () {},
                        ),
                        Flexible(
                          child: TextField(
                            controller: textFieldController,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: _textInputAction,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
contentPadding: EdgeInsets.all(0.0),
                              hintText: 'Type a message',
hintStyle: TextStyle(
                                color: textFieldHintColor,
                                fontSize: 16.0,
                              ),
                              counterText: '',
                            ),
                            onSubmitted: (String text) {
                              if(_textInputAction == TextInputAction.send) {
                                _sendMessage();
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: 100,
                          ),
                        ),
                        IconButton(
                          color: iconColor,
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {},
                        ),
                        _message.isEmpty || _message == null
                            ? IconButton(
                                color: iconColor,
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () {},
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: FloatingActionButton(
                    elevation: 2.0,
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    onPressed: _sendMessage,
                    child: _message.isEmpty || _message == null
                        ? const Icon(Icons.settings_voice)
                        : const Icon(Icons.send),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _onSelectMenuOption(ChatDetailMenuOptions option) {
    switch (option) {
      case ChatDetailMenuOptions.viewContact:
        Application.router.navigateTo(
          context,
          //"/profile?id=${_chat.id}",
          Routes.futureTodo,
          transition: TransitionType.inFromRight,
        );
        break;
      case ChatDetailMenuOptions.media:
        Application.router.navigateTo(
          context,
          //"/chat/media?id=${_chat.id}",
          Routes.futureTodo,
          transition: TransitionType.inFromRight,
        );
        break;
      case ChatDetailMenuOptions.search:
        break;
      case ChatDetailMenuOptions.muteNotifications:
        break;
      case ChatDetailMenuOptions.wallpaper:
        break;
      case ChatDetailMenuOptions.more:
        break;
    }
  }

  // _onSelectMoreMenuOption(ChatDetailMoreMenuOptions option) {}

  int offsetUnsentMessage = 0;

  void _sendMessage() {
    if(_message == null || _message.isEmpty) return;

    ChatService.updateChat(_chat.id, _message).then((chat) {
      setState(() {
        _messages[offsetUnsentMessage-1].isSent = true;
        offsetUnsentMessage--;
      });
    });
    
    setState(() {
      _messages.insert(
        0,
          Message(
            content: _message,
            timestamp: DateTime.now(),
            isRead: false,
            isYou: true,
            isSent: false,
          )
      );
      offsetUnsentMessage++;
      _message = '';
      textFieldController.text = '';
    });
    
  }
}