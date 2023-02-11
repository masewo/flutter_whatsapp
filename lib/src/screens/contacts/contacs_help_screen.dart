import 'package:flutter/material.dart';

class ContactsHelpScreen extends StatelessWidget {
  const ContactsHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> helpText = [
      'If some of your friends don\'t appear in the contacts list, we recommend the following steps:',
      'Make sure that your friend\'s phone number is in your address book',
      'Make sure that your friend is using WhatzApp Messenger',
    ];

    TextStyle textStyle = const TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts help'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Text(
                  helpText[0],
                style: textStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildBulletPointText(helpText[1], textStyle),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildBulletPointText(helpText[2], textStyle),
              ),
            ],
          )
      ),
    );
  }

  Widget _buildBulletPointText(String text, TextStyle style) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            '•',
          style: style,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
              text,
            style: style,
          ),
        ),
      ],
    );
  }
}