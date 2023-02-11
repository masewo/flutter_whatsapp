import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';

class SettingItemHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final EdgeInsets padding;

  const SettingItemHeader({Key key, this.title, this.subtitle, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(subtitle != null) {
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: subtitle == null ? null : Text(
            subtitle
        ),
        contentPadding: padding,
      );
    }
    return Padding(
        padding: padding,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            color: secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }

}