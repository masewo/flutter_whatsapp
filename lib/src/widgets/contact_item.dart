import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_whatsapp/src/helpers/text_helpers.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final String searchKeyword;
  final Function onProfileTap;
  final Function onTap;

  const ContactItem({Key key,
    this.contact,
    this.searchKeyword,
    this.onProfileTap,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
      leading: SizedBox(
        width: 45.0,
        height: 45.0,
        child: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(
              Icons.account_circle,
              size: 45.0,
            ),
            color: lightGrey,
            onPressed: onProfileTap
        ),
      ),
      title: searchKeyword == null || searchKeyword.isEmpty
          ? Text(
              contact.displayName,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            )
          : TextHelpers.getHighlightedText(
              contact.displayName,
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
//      subtitle: Text(
//        _contact.displayName.lastMessage.content,
//        maxLines: 1,
//      ),
      onTap: onTap,
    );
  }
}