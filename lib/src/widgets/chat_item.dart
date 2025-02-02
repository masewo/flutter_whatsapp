import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/helpers/text_helpers.dart';
import 'package:flutter_whatsapp/src/models/chat.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter_whatsapp/src/widgets/line_painter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;
  final String searchKeyword;
  final Icon iconSubtitle;
  final Function onTapProfile;
  final Function onTap;

  const ChatItem(
      {Key key, this.chat,
      this.searchKeyword,
      this.iconSubtitle,
      this.onTapProfile,
      this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        leading: GestureDetector(
          onTap: () {
            onTapProfile();
          },
          child: CircleAvatar(
            radius: 30.0,
            backgroundImage: CachedNetworkImageProvider(chat.avatarUrl),
          ),
        ),
        title: searchKeyword == null || searchKeyword.isEmpty
            ? Text(
                chat.name,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            : TextHelpers.getHighlightedText(
                chat.name,
                searchKeyword,
                const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
        subtitle: Row(
          children: <Widget>[
            iconSubtitle == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 2.0), child: iconSubtitle),
            Flexible(
              child: Text(
                chat.lastMessage.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              DateFormat('dd/MM/yy').format(chat.lastMessage.timestamp),
              style: TextStyle(
                fontSize: 12.0,
                color: chat.unreadMessages > 0
                    ? notificationBadgeColor
                    : Colors.grey,
              ),
            ),
            chat.unreadMessages > 0
                ? Container(
                    decoration: const BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: notificationBadgeColor,
                    ),
                    width: 24.0,
                    height: 24.0,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 4.0, top: 4.0),
                    child: Text(
                      '${chat.unreadMessages}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : const Text(''),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}