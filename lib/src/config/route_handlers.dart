import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/helpers/logger.dart';
import 'package:flutter_whatsapp/src/home.dart';
import 'package:flutter_whatsapp/src/screens/camera_screen.dart';
import 'package:flutter_whatsapp/src/screens/chat_media_screen.dart';
import 'package:flutter_whatsapp/src/screens/contacts/contacs_help_screen.dart';
import 'package:flutter_whatsapp/src/screens/detail_call_screen.dart';
import 'package:flutter_whatsapp/src/screens/detail_chat_screen.dart';
import 'package:flutter_whatsapp/src/screens/detail_status_screen.dart';
import 'package:flutter_whatsapp/src/screens/edit_image_screen.dart';
import 'package:flutter_whatsapp/src/screens/future_todo_screen.dart';
import 'package:flutter_whatsapp/src/screens/new_call_screen.dart';
import 'package:flutter_whatsapp/src/screens/new_chat_broadcast_screen.dart';
import 'package:flutter_whatsapp/src/screens/new_chat_group_screen.dart';
import 'package:flutter_whatsapp/src/screens/new_chat_screen.dart';
import 'package:flutter_whatsapp/src/screens/new_text_status_screen.dart';
import 'package:flutter_whatsapp/src/screens/profile_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/account_changenum_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/account_delete_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/account_enable_twostep_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/account_privacy_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/account_request_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/account_security_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/account_twostep_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/privacy/privacy_blocked_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account/privacy/privacy_livelocation_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/account_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/chats_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/data_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/help/help_appinfo_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/help/help_contact_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/help/licenses_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/help_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/notifications_settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings/your_profile_screen.dart';
import 'package:flutter_whatsapp/src/screens/settings_screen.dart';
import 'package:flutter_whatsapp/src/screens/starred_messages_screen.dart';
import 'package:flutter_whatsapp/src/screens/status_privacy_screen.dart';
import 'package:flutter_whatsapp/src/screens/whatsapp_web_scan_screen.dart';
import 'package:flutter_whatsapp/src/screens/whatsapp_web_screen.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter_whatsapp/src/widgets/deprecated/flat_button.dart';

var rootHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return const Home();
  }
);

var chatDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      int profileId = int.tryParse(params['profileId']?.first);

      return DetailChatScreen(
        id: profileId,
      );
    }
);

var newChatHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const NewChatScreen();
    }
);

var newChatGroupHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const NewChatGroupScreen();
    }
);

var newChatBroadcastHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const NewChatBroadcastScreen();
    }
);

var whatsappWebHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const WhatsappWebScreen();
    }
);

var starredMessagesHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const StarredMessagesScreen();
    }
);

var settingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const SettingsScreen();
    }
);

var statusDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      int id = int.tryParse(params['id']?.first);

      return DetailStatusScreen(
        id: id,
      );
    }
);

var newStatusHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const CameraScreen();
    }
);

var newTextStatusHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const NewTextStatusScreen();
    }
);

var statusPrivacyHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const StatusPrivacyScreen();
    }
);

var callDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      int id = int.tryParse(params['id']?.first);

      return DetailCallScreen(
        id: id,
      );
    }
);

var newCallHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const NewCallScreen();
    }
);

var clearCallLogHandler = Handler(
    type: HandlerType.function,
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      showDialog(
        context: context,
        builder: (context) {
          return const OKCancelDialog(
            title: 'Do you want to clear your entire call log?',
            ok: 'OK',
            cancel: 'CANCEL',
          );
        }
      );
      return null;
    }
);

var logoutDeviceHandler = Handler(
    type: HandlerType.function,
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      showDialog(
          context: context,
          builder: (context) {
            return const OKCancelDialog(
              title: 'Log out from this device?',
              ok: 'LOG OUT',
              cancel: 'CANCEL',
            );
          }
      );
      return null;
    }
);

var editImageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String id = params['id']?.first;
      String resource = params['resource']?.first;

      logger.d('!!!!!!!!!!!!!!!!! $id : $resource');

      return EditImageScreen(
        id: id,
        resource: Uri.decodeComponent(resource),
      );
    }
);

var logoutAllDevicesHandler = Handler(
    type: HandlerType.function,
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      showDialog(
          context: context,
          builder: (context) {
            return const OKCancelDialog(
              title: 'Are you sure you want to log out from all devices?',
              ok: 'LOG OUT',
              cancel: 'CANCEL',
            );
          }
      );
      return null;
    }
);

var contactsHelpHandler  = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const ContactsHelpScreen();
    }
);

var profileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      // int id = int.tryParse(params['id']?.first) ?? null;

      return const ProfileScreen(
      );
    }
);

var yourProfileHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {

      return const YourProfileScreen(
      );
    }
);

var chatMediaHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      // int id = int.tryParse(params['id']?.first) ?? null;

      return const ChatMediaScreen();
    }
);

var accountSettingsHandler  = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountSettingsScreen();
    }
);
var chatsSettingsHandler  = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const ChatsSettingsScreen();
    }
);
var notificationsSettingsHandler  = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const NotificationsSettingsScreen();
    }
);
var dataSettingsHandler  = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const DataSettingsScreen();
    }
);
var helpSettingsHandler  = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const HelpSettingsScreen();
    }
);
var helpContactSettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const HelpContactSettingsScreen();
    }
);
var helpAppInfoSettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const HelpAppInfoSettingsScreen();
    }
);
var accountPrivacySettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountPrivacySettingsScreen();
    }
);
var accountSecuritySettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountSecuritySettingsScreen();
    }
);
var accountTwoStepSettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountTwoStepSettingsScreen();
    }
);
var accountEnableTwoStepSettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountEnableTwoStepSettingsScreen();
    }
);
var accountChangeNumSettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountChangeNumSettingsScreen();
    }
);
var accountRequestSettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountRequestSettingsScreen();
    }
);
var accountDeleteSettingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const AccountDeleteSettingsScreen();
    }
);

var licensesHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const LicensesScreen();
    }
);

var futureTodoHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const FutureTodoScreen();
    }
);

var whatsappWebScanHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const WhatsappWebScanScreen();
    }
);

var privacyLiveLocationHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const PrivacyLiveLocationScreen();
    }
);

var privacyBlockedHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return const PrivacyBlockedScreen();
    }
);

class OKCancelDialog extends StatelessWidget {

  final String title;
  final String ok;
  final String cancel;

  const OKCancelDialog({Key key, this.title, this.ok, this.cancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
      actions: <Widget>[
        Material(
          child: FlatButton(
            child: Text(
              cancel,
              style: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ),
        FlatButton(
          child: Text(
            ok,
            style: const TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

}