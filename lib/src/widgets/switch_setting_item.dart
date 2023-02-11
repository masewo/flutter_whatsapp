import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';

class SwitchSettingItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final Function onChanged;
  final bool value;
  final EdgeInsets padding;

  const SwitchSettingItem({Key key, this.icon, this.title, this.subtitle, this.onChanged, this.value, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(subtitle == null) {
      ListTileTheme(
        contentPadding: padding ?? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: SwitchListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Text(
              title,
            ),
          ),
          value: value,
          activeColor: secondaryColor,
          onChanged: onChanged,
        ),
      );
    }
    return ListTileTheme(
      contentPadding: padding ?? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: SwitchListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Text(
            title,
          ),
        ),
        subtitle: Text(
          subtitle,
        ),
        value: value,
        activeColor: secondaryColor,
        onChanged: onChanged,
      ),
    );
  }
}