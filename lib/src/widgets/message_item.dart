import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final String content;
  final DateTime timestamp;
  final bool isYou;
  final bool isRead;
  final bool isSent;
  final double fontSize;

  const MessageItem({Key key,
    this.content,
    this.timestamp,
    this.isYou,
    this.isRead = false,
    this.isSent = true,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildMessage();
  }

  Widget _buildMessage() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment:
          isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Container(
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
offset: Offset(1.0, 1.0),
                        blurRadius: 1.0)
                  ],
                  color: isYou ? messageBubbleColor : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              constraints: const BoxConstraints(
                minWidth: 100.0,
                maxWidth: 280.0,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 100.0,
                    ),
                    child: Text(
                      content,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 100.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              DateFormat('HH:mm').format(timestamp),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            isYou
                                ? _getIcon()
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ],
    );
  }

  Widget _getIcon() {
    if(!isSent) {
      return const Icon(
        Icons.check,
        size: 18.0,
        color: Colors.grey,
      );
    }
    return Icon(
      Icons.done_all,
      size: 18.0,
      color:
      isRead ? blueCheckColor : Colors.grey,
    );
  }
}