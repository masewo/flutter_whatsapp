import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final Function onTap;
  final EdgeInsets padding;

  const SettingItem({Key key, this.icon, this.title, this.subtitle, this.onTap, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(subtitle == null) {
      return ListTile(
        contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: icon == null ? null : Container(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: const Color.fromRGBO(7, 94, 84, 0.7),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      );
    }
    return ListTile(
      contentPadding: padding,
      leading: icon == null ? null : Container(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: const Color.fromRGBO(7, 94, 84, 0.7),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
          subtitle
      ),
      onTap: onTap,
    );
  }

}