import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/helpers/dialog_helpers.dart';
import 'package:flutter_whatsapp/src/models/call.dart';
import 'package:flutter_whatsapp/src/models/call_detail.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:intl/intl.dart';

enum CallDetailOptions {
  removeLog,
  block
}

class DetailCallScreen extends StatefulWidget {

  final int id;

  const DetailCallScreen({Key key,
    this.id,
  }) : super(key: key);

    @override
  State<DetailCallScreen> createState() => _DetailCallScreen();
}

class _DetailCallScreen extends State<DetailCallScreen> {
  @override
  Widget build(BuildContext context) {
    Call call = Call(
      name: 'NAME',
      avatarUrl: 'https://dummyimage.com/100x100',
      callDetails: <CallDetail>[
        CallDetail(
          timestamp: DateTime.now(),
          isMissed: true,
          isIncoming: true,
        )
      ]
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call info'),
        actions: <Widget>[
          IconButton(
            tooltip: 'New chat',
            icon: const Icon(Icons.message),
            onPressed: (){},
          ),
          PopupMenuButton<CallDetailOptions>(
            tooltip: 'More options',
            onSelected: _onSelectedOption,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<CallDetailOptions>(
                  value: CallDetailOptions.removeLog,
                  child: Text('Remove from call log'),
                ),
                const PopupMenuItem<CallDetailOptions>(
                  value: CallDetailOptions.block,
                  child: Text('Block'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(0.0),
            shape: const RoundedRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Dialog profileDialog = DialogHelpers.getProfileDialog(
                            context: context,
                            id: 1,
                            imageUrl: call.avatarUrl,
                            name: call.name,
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => profileDialog
                          );
                        },
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(call.avatarUrl),
                        ),
                      );
                    }
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        call.name,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.call),
                    color: Theme.of(context).primaryColor,
                    onPressed: (){},
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    color: Theme.of(context).primaryColor,
                    onPressed: (){},
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 16.0),
                  child: Text(
                    DateFormat('MMMM dd').format(call.lastCall.timestamp),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: secondaryColor,
                    ),
                  ),
                ),
                const Divider(),
                _buildCallDetails(call),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCallDetails(Call call) {
    List<Widget> callDetails = <Widget>[];

    for(CallDetail detail in call.callDetails.reversed.toList()) {
      callDetails.add(Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              detail.isIncoming ? Icons.call_received : Icons.call_made,
              color: detail.isMissed ? Colors.red : Colors.green,
              size: 20.0,
            ),
            const SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  detail.isMissed ? 'Missed' : (detail.isIncoming ? 'Incoming' : 'Outgoing'),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(detail.timestamp),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      ));
    }

    return Column(
      children: callDetails,
    );
  }

  _onSelectedOption(CallDetailOptions option) {
    switch(option) {
      case CallDetailOptions.removeLog:
        break;
      case CallDetailOptions.block:
        break;
    }
  }
}