import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter_whatsapp/src/widgets/deprecated/raised_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FutureTodoScreen extends StatelessWidget {
  const FutureTodoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
gradient: LinearGradient(colors: [darkColor, primaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight)
        ),
        child:
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Hi, thanks for checking out this project. I made this just for my '
                        'study/excersise on Flutter. This is obviously non-affiliated (duh!) and '
                        'I make no profit of it. Download the real WhatsApp by clicking the button below. Cheers!'
                    ,
                    textAlign: TextAlign.center,
style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                  RaisedButton(
                    child: const Text('Download WhatsApp'),
                    onPressed: (){
                      String url = 'https://www.whatsapp.com/download/';
                      _launchURL(url);
                    },
                  )
                ],
              ),
            )
      ),
    );
  }

  _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}