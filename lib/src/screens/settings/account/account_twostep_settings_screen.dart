import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/config/application.dart';
import 'package:flutter_whatsapp/src/config/routes.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter_whatsapp/src/widgets/deprecated/raised_button.dart';

class AccountTwoStepSettingsScreen extends StatelessWidget {
  const AccountTwoStepSettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String text = 'For added security, enable two-step '
      'verfication, which will require a PIN when '
      'registering your phone number with '
      'WhatzApp again.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-step verification'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, bottom: 28.0),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.1,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: fabBgColor,
              child: const Text(
                  'ENABLE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                Application.router.navigateTo(
                  context,
                  //Routes.accountEnableTwoStepSettings,
                  Routes.futureTodo,
                  transition: TransitionType.inFromRight,
                );
              },
            ),
          )
        ],
      ),
    );
  }

}