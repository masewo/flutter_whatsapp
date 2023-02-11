import 'package:async/async.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/config/application.dart';
import 'package:flutter_whatsapp/src/config/routes.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_whatsapp/src/screens/camera_screen.dart';
import 'package:flutter_whatsapp/src/services/chat_service.dart';
import 'package:flutter_whatsapp/src/services/status_service.dart';
import 'package:flutter_whatsapp/src/tabs/calls_tab.dart';
import 'package:flutter_whatsapp/src/tabs/chats_tab.dart';
import 'package:flutter_whatsapp/src/tabs/status_tab.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

enum HomeOptions {
  settings,
  // Chats Tab
  newGroup,
  newBroadcast,
  whatsappWeb,
  starredMessages,
  // Status Tab
  statusPrivacy,
  // Calls Tab
  clearCallLog,
  readMe,
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _actionButtons;
  List<List<PopupMenuItem<HomeOptions>>> _popupMenus;

  int _tabIndex;
  TabController _tabController;

  bool _isSearching;
  TextField _searchBar;
  TextEditingController _searchBarController;

  List<Widget> _fabs;

  static const TextStyle _textBold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  String _searchKeyword = '';

  AsyncMemoizer _memoizerChats = AsyncMemoizer();
  Future<dynamic> _chatList;
  AsyncMemoizer _memoizerStatus = AsyncMemoizer();
  Future<dynamic> _statusList;
  AsyncMemoizer _memoizerCalls = AsyncMemoizer();

  // int _unreadMessages = 0;
  AnimationController unreadChatsBadgeAnimationController;
  Animation unreadChatsBadgeAnimation;

  Future<dynamic> _getChatList() {
    return _memoizerChats.runOnce(() {
      return ChatService.getChats().then((chatlist) {
        updateAppBadge(chatlist.unreadMessages);
        return chatlist;
      });
    });
  }

  bool isNewStatus = false;

  Future<dynamic> _getStatusList() {
    return _memoizerStatus.runOnce(() async {
      return StatusService.getStatuses().whenComplete(() {
        setState(() {
          isNewStatus = true;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _chatList = _getChatList();
    _statusList = _getStatusList();
    _tabIndex = 1; // Start at second tab.
    _isSearching = false;

    unreadChatsBadgeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );
    unreadChatsBadgeAnimation = Tween(
      begin: 1.0,
      end: 0.7,
    ).animate(unreadChatsBadgeAnimationController);

    _searchBarController = TextEditingController();
    _searchBarController.addListener(() {
      setState(() {
        _searchKeyword = _searchBarController.text;
      });
    });

    _searchBar = TextField(
      controller: _searchBarController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
      ),
    );
    _tabController = TabController(
      length: 4,
      initialIndex: _tabIndex,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
        _isSearching = false;
        _searchBarController?.text = "";
        if (_tabController.index == 2) {
          isNewStatus = false;
        }

        if (_tabController.index != 1) {
          unreadChatsBadgeAnimationController.forward();
        } else {
          unreadChatsBadgeAnimationController.reverse();
        }
      });
    });

    _actionButtons = <Widget>[
      IconButton(
        tooltip: "Search",
        icon: const Icon(Icons.search),
        onPressed: () {
          setState(() {
            _searhBarOpen = true;
            _isSearching = true;
            _searchBarController?.text = "";
          });
        },
      ),
      PopupMenuButton<HomeOptions>(
        key: const Key('moreOptions'),
        tooltip: "More options",
        onSelected: _selectOption,
        itemBuilder: (BuildContext context) {
          return _popupMenus[_tabIndex];
        },
      ),
    ];

    _popupMenus = [
      null,
      [
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.newGroup,
          child: Text("New group"),
        ),
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.newBroadcast,
          child: Text("New broadcast"),
        ),
        const PopupMenuItem<HomeOptions>(
          key: Key('Web'),
          value: HomeOptions.whatsappWeb,
          child: Text("WhatzApp Web"),
        ),
        const PopupMenuItem<HomeOptions>(
          key: Key('Starred'),
          value: HomeOptions.starredMessages,
          child: Text("Starred messages"),
        ),
        const PopupMenuItem<HomeOptions>(
          key: Key('Settings'),
          value: HomeOptions.settings,
          child: Text("Settings"),
        ),
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.readMe,
          child: Text("README", style: TextStyle(color: Colors.red)),
        ),
      ],
      [
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.statusPrivacy,
          child: Text("Status privacy"),
        ),
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.settings,
          child: Text("Settings"),
        ),
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.readMe,
          child: Text("README", style: TextStyle(color: Colors.red)),
        ),
      ],
      [
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.clearCallLog,
          child: Text("Clear call log"),
        ),
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.settings,
          child: Text("Settings"),
        ),
        const PopupMenuItem<HomeOptions>(
          value: HomeOptions.readMe,
          child: Text("README", style: TextStyle(color: Colors.red)),
        ),
      ],
    ];

    _fabs = [
      null,
      FloatingActionButton(
          backgroundColor: fabBgColor,
          foregroundColor: Colors.white,
          onPressed: () async {
            if (await allPermissionsGranted()) {
              goToNewChatScreen();
            } else {
              requestPermission();
            }
          },
          child: const Icon(Icons.message)),
      SizedBox(
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
                heroTag: 'newTextStatus',
                mini: true,
                backgroundColor: Colors.white,
                foregroundColor: fabBgSecondaryColor,
                onPressed: () {
                  Application.router.navigateTo(
                    context,
                    Routes.newTextStatus,
                    transition: TransitionType.inFromRight,
                  );
                },
                child: const Icon(Icons.edit)),
            const SizedBox(
              height: 16.0,
            ),
            FloatingActionButton(
                heroTag: 'newStatus',
                backgroundColor: fabBgColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  Application.router.navigateTo(
                    context,
                    Routes.newStatus,
                    transition: TransitionType.inFromRight,
                  );
                },
                child: const Icon(Icons.camera_alt)),
          ],
        ),
      ),
      FloatingActionButton(
          backgroundColor: fabBgColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Application.router.navigateTo(
              context,
              Routes.newCall,
              transition: TransitionType.inFromRight,
            );
          },
          child: const Icon(Icons.add_call)),
    ];
  }

  void goToNewChatScreen() {
    Application.router.navigateTo(
      context,
      "/chat/new",
      transition: TransitionType.inFromRight,
    );
  }

  @override
  void dispose() {
    unreadChatsBadgeAnimationController.dispose();
    _tabController.dispose();
    _searchBarController.dispose();
    super.dispose();
  }

  updateAppBadge(int count) async {
    bool appBadgeSupported = false;

    if (!kIsWeb) {
      try {
        bool res = await FlutterAppBadger.isAppBadgeSupported();
        appBadgeSupported = res;
      } on PlatformException {
        appBadgeSupported = false;
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (appBadgeSupported) {
      FlutterAppBadger.updateBadgeCount(count);
    }
  }

  bool _searhBarOpen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_searhBarOpen) {
          setState(() {
            _searhBarOpen = false;
            _isSearching = false;
            _searchBarController?.text = "";
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _tabIndex == 0
            ? null
            : AppBar(
                backgroundColor: _isSearching ? Colors.white : null,
                leading: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color(0xff075e54),
                        onPressed: () {
                          setState(() {
                            _searhBarOpen = false;
                            _isSearching = false;
                            _searchBarController?.text = "";
                          });
                        },
                      )
                    : null,
                title: _isSearching
                    ? _searchBar
                    : const Text(
                        'WhatzApp',
                        style: _textBold,
                      ),
                actions: _isSearching ? null : _actionButtons,
                bottom: _isSearching
                    ? null
                    : TabBar(
                        controller: _tabController,
                        tabs: <Widget>[
                          const Tab(
                            icon: Icon(Icons.camera_alt),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "CHATS",
                                  style: _textBold,
                                ),
                                FutureBuilder(
                                  future: _chatList,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Container();
                                    }
                                    if (snapshot.data.unreadMessages <= 0) {
                                      return Container();
                                    }

                                    return FadeTransition(
                                      opacity: unreadChatsBadgeAnimation,
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(left: 4.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(9.0))),
                                        alignment: Alignment.center,
                                        height: 18.0,
                                        width: 18.0,
                                        child: Text(
                                          '${snapshot.data.unreadMessages}',
                                          style: const TextStyle(
                                            fontSize: 9.0,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "STATUS",
                                  key: Key('Status'),
                                  style: _textBold,
                                ),
                                FutureBuilder(
                                  future: _statusList,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Container();
                                    }
                                    if (!isNewStatus) return Container();

                                    return const Padding(
                                      padding:
                                          EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        '•',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Tab(
                            child: Text(
                              "CALLS",
                              key: Key('Calls'),
                              style: _textBold,
                            ),
                          ),
                        ],
                        labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
              ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            const CameraScreen(
            ),
            ChatsTab(
                searchKeyword: _searchKeyword,
                chatList: _chatList,
                refresh: () {
                  setState(() {
                    _memoizerChats = AsyncMemoizer();
                    _chatList = _getChatList();
                  });
                }),
            StatusTab(
                searchKeyword: _searchKeyword,
                statusList: _statusList,
                refresh: () {
                  setState(() {
                    _memoizerStatus = AsyncMemoizer();
                    _statusList = _getStatusList();
                  });
                }),
            CallsTab(
                searchKeyword: _searchKeyword,
                memoizer: _memoizerCalls,
                refresh: () {
                  setState(() {
                    _memoizerCalls = AsyncMemoizer();
                  });
                }),
          ],
        ),
        floatingActionButton: _fabs[_tabIndex],
      ),
    );
  }

  void _selectOption(HomeOptions option) {
    switch (option) {
      case HomeOptions.newGroup:
        Application.router.navigateTo(
          context,
          //Routes.newChatGroup,
          Routes.futureTodo,
          transition: TransitionType.inFromRight,
        );
        break;
      case HomeOptions.newBroadcast:
        Application.router.navigateTo(
          context,
          //Routes.newChatBroadcast,
          Routes.futureTodo,
          transition: TransitionType.inFromRight,
        );
        break;
      case HomeOptions.whatsappWeb:
        Application.router.navigateTo(
          context,
          Routes.whatsappWeb,
          transition: TransitionType.inFromRight,
        );
        break;
      case HomeOptions.starredMessages:
        Application.router.navigateTo(
          context,
          Routes.starredMessages,
          transition: TransitionType.inFromRight,
        );
        break;
      case HomeOptions.settings:
        Application.router.navigateTo(
          context,
          Routes.settings,
          transition: TransitionType.inFromRight,
        );
        break;
      case HomeOptions.statusPrivacy:
        Application.router.navigateTo(
          context,
          //Routes.statusPrivacy,
          Routes.futureTodo,
          transition: TransitionType.inFromRight,
        );
        break;
      case HomeOptions.clearCallLog:
        Application.router.navigateTo(
          context,
          Routes.clearCallLog,
          transition: TransitionType.inFromRight,
        );
        break;
      case HomeOptions.readMe:
        Application.router.navigateTo(
          context,
          Routes.futureTodo,
          transition: TransitionType.inFromRight,
        );
        break;
    }
  }

  Future<bool> allPermissionsGranted() async {
    bool res = await Permission.contacts.isGranted;
    return res;
  }

  void requestPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      goToNewChatScreen();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission not granted'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}