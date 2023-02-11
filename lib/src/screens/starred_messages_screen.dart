import 'package:flutter/material.dart';

enum StarredMessageOptions {
  unstarAll,
}

class StarredMessagesScreen extends StatefulWidget {
  const StarredMessagesScreen({Key key}) : super(key: key);

  @override
  State<StarredMessagesScreen> createState() => _StarredMessagesScreenState();
}

class _StarredMessagesScreenState extends State<StarredMessagesScreen> {

  List<String> messages;

  @override
  void initState() {
    super.initState();

    messages = <String>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starred messages'),
        actions: messages.isEmpty
            ? []
            : <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: (){},
          ),
          PopupMenuButton<StarredMessageOptions>(
            tooltip: "More options",
            onSelected: _selectOption,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<StarredMessageOptions>(
                  value: StarredMessageOptions.unstarAll,
                  child: Text('Unstar all'),
                ),
              ];
            },
          )
        ],
      ),
      body: messages.isEmpty
          ? _buildEmptyPage()
          : const Center(
        child: Text('TODO'),
      ),
    );
  }

  _buildEmptyPage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(75.0),
            color: const Color(0xff1dbea5),
          ),
          child: const Icon(
            Icons.star,
            color: Colors.white,
            size: 75.0,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 80.0, left: 80.0, top: 32.0),
          child: Text(
            'Tap and hold on any message in any chat to star it, so you can easily find it later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.2,
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
        )
      ],
    );
  }

  _selectOption(StarredMessageOptions option) {
    switch(option) {
      case StarredMessageOptions.unstarAll:
        break;
    }
  }
}