import 'package:flutter/material.dart';

class FlatButton extends StatelessWidget {
  const FlatButton({
    Key key,
    this.shape,
    this.padding,
    this.onPressed,
    this.child,
  }) : super(key: key);

  final OutlinedBorder shape;
  final EdgeInsets padding;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.black87,
      minimumSize: Size(88, 36),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.0),
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: onPressed,
      child: child,
    );
  }
}
