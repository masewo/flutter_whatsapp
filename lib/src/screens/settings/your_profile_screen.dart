import 'package:flutter/material.dart';

class YourProfileScreen extends StatelessWidget {
  const YourProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 32.0,
              bottom: 16.0,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                const Hero(
                  tag: 'profile-pic',
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage:
                        NetworkImage('https://placekitten.com/g/150/150'),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: FloatingActionButton(
                      mini: true,
                      child: const Icon(Icons.camera_alt),
                      onPressed: () {}),
                )
              ],
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: const Icon(
              Icons.account_circle,
              color: Color.fromRGBO(7, 94, 84, 0.7),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  'John Smith',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('This is not your username or pin. This name will be '
                  'visible to your WhatzApp contacts.'),
            ),
            trailing: const Icon(Icons.mode_edit),
            onTap: () {},
          ),
          const Divider(
            height: 0.0,
            indent: 72.0,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: const Icon(
              Icons.info_outline,
              color: Color.fromRGBO(7, 94, 84, 0.7),
            ),
            title: const Text(
              'About',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
              ),
            ),
            subtitle: const Text(
              'Hey, I am using WhatzApp!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            trailing: const Icon(Icons.mode_edit),
            onTap: () {},
          ),
          const Divider(
            height: 0.0,
            indent: 72.0,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: const Icon(
              Icons.call,
              color: Color.fromRGBO(7, 94, 84, 0.7),
            ),
            title: const Text(
              'Phone',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
              ),
            ),
            subtitle: const Text(
              '+62 123-1234-1234',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
