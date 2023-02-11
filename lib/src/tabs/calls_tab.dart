import 'package:async/async.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/config/application.dart';
import 'package:flutter_whatsapp/src/helpers/dialog_helpers.dart';
import 'package:flutter_whatsapp/src/models/call_list.dart';
import 'package:flutter_whatsapp/src/services/call_service.dart';
import 'package:flutter_whatsapp/src/widgets/call_item.dart';
import 'package:flutter_whatsapp/src/widgets/deprecated/raised_button.dart';

class CallsTab extends StatelessWidget {

  final String searchKeyword;
  final AsyncMemoizer memoizer;
  final VoidCallback refresh;

  const CallsTab({Key key,
    this.memoizer,
    this.searchKeyword,
    this.refresh,
  }) : super(key: key);

  _getCallList() {
    return memoizer.runOnce(() {
      return CallService.getCalls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCallList(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center,),
                    RaisedButton(
                      onPressed: refresh,
                      child: const Text('Refresh'),
                    )
                  ]
              );
            }
            bool isFound = false;
            CallList callList = snapshot.data;
            return ListView.builder(
              itemCount: callList.calls.length,
              itemBuilder: (context, i) {
                if (searchKeyword.isNotEmpty) {
                  if (!callList.calls[i].name
                      .toLowerCase()
                      .contains(searchKeyword.toLowerCase())) {
                    if (!isFound && i >= callList.calls.length - 1) {
                      return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                                'No results found for \'$searchKeyword\''),
                          ));
                    }
                    return const SizedBox(
                      height: 0.0,
                    );
                  }
                }
                isFound = true;
                return CallItem(
                  call: callList.calls[i],
                  searchKeyword: searchKeyword,
                  onTap: (){
                    Application.router.navigateTo(
                      context,
                      "/call?id=${callList.calls[i]}",
                      transition: TransitionType.inFromRight,
                    );
                  },
                  onProfileTap: () {
                    Dialog profileDialog = DialogHelpers.getProfileDialog(
                      context: context,
                      id: callList.calls[i].id,
                      imageUrl: callList.calls[i].avatarUrl,
                      name: callList.calls[i].name,
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => profileDialog
                    );
                  },
                  onLeadingTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${callList.calls[i].name}...'))
                    );
                  },
                );
              },
            );
        }
        return null; // unreachable
      },
    );
  }
}