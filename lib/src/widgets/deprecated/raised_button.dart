import 'package:flutter/material.dart';

class RaisedButton extends StatelessWidget {
  const RaisedButton({
    Key key,
    this.color,
    this.onPressed,
    this.child,
  }) : super(key: key);

  final Color color;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black87,
      backgroundColor: color ?? Colors.grey[300],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: onPressed,
      child: child,
    );
  }
}