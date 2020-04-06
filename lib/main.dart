import 'dart:io' show Platform;
import 'package:atelier/screens/home/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blocs/bloc.dart';
import 'dart:async';
import 'blocs/design.dart';
import 'package:easy_localization/easy_localization.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _matchteam;
  String get matchteam => _matchteam;
  set matchteam(String value) {
    _matchteam = value;
    _controller.add(this);
  }

  String _score;
  String get score => _score;
  set score(String value) {
    _score = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
          () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(itemId),
      ),
    );
  }
}
final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    .._matchteam = data['matchteam']
    .._score = data['score'];
  return item;
}
class DetailPage extends StatefulWidget {
  DetailPage(this.itemId);
  final String itemId;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Item _item;
  StreamSubscription<Item> _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.itemId];
    _subscription = _item.onChanged.listen((Item item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Match ID ${_item.itemId}"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Card(
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          Text('Today match:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                          Text( _item.matchteam, style: Theme.of(context).textTheme.title)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          Text('Score:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                          Text( _item.score, style: Theme.of(context).textTheme.title)
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
void main() {

  runApp(EasyLocalization(child: Atelier()));

}

class Atelier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
        theme: ThemeData(
          accentColor: blackAccent,
          primaryColor: bumbi,
          backgroundColor: backGround,
          buttonColor: bumbi,
          hintColor: hint,
          fontFamily: 'Tajawal',
        ),
        supportedLocales: [Locale("ar", "SA"), Locale("en", "US")],
        locale: data.savedLocale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          EasylocaLizationDelegate(locale: data.locale, path: 'assets/lang')
        ],
        home: Open(),
        title: 'Atelier',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Open extends StatefulWidget {
  @override
  _OpenState createState() => _OpenState();
}

class _OpenState extends State<Open> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  setUserData() async {}
///////////////////////////////////////////////////////////////////
  Future _fcm_listener(BuildContext context) async {
    ///
    if (Platform.isIOS) ios_permission();

    ///

    ///
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
                print(bloc.newNotifichation);
        if(bloc.currentUser()!=null){
        if(bloc.currentUser().admin_status=="approved")
      {  bloc.changenewNotifichation(true);
        _showItemDialog(message,context);
      }
        }
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
                if(bloc.currentUser()!=null){
        if(bloc.currentUser().admin_status=="approved")
      {  _navigateToItemDetail(message);
              bloc.changenewNotifichation(true);

      }
        }

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
                if(bloc.currentUser()!=null){
        if(bloc.currentUser().admin_status=="approved")
        {
        _navigateToItemDetail(message);
                bloc.changenewNotifichation(true);

        }
        }
      },
    );
    ///

    ///
    await  _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
            bloc.setDeviceType(Platform.operatingSystem);
      bloc.setDeviceToken(token);

      print("Push Messaging token: $token");
    });
    _firebaseMessaging.subscribeToTopic("matchscore");

  }
  void ios_permission() {
    ///
        _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

      ///
  }

  ///
  /////////////////////////////////////////////////////////////////////////
 ///***///////****///// */ */
  void _showItemDialog(Map<String, dynamic> message,BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }
    void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
    // Navigator.push(context,MaterialPageRoute(builder: (context)=>Notifications()));
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }
  bool _topicButtonsDisabled = false;
  final TextEditingController _topicController =
  TextEditingController(text: 'topic');
    Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("${item.matchteam} with score: ${item.score}"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
  ///**////**/////***/////// */ */ */
  @override
  void initState() {
    _fcm_listener(context);
    chooseScreen(context,true);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bloc.setDeviceSize(Size(width, height));
    return Scaffold(
        body: Container(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
           Positioned(
                  bottom: 0,
                  child: AnimatedOpacity(
                      duration: mill2Second,
                      opacity:0.5,
                      child: Container(
                          width: bloc.size().width,
                          height: bloc.size().height,
                          child: Image.asset(
                            'assets/images/bg.png',
                                                      width: bloc.size().width,
                          height: bloc.size().height,

                            fit: BoxFit.cover,
                          ))),
                ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: Image.asset('assets/images/more.png'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Theme(
                    data: ThemeData(accentColor: bumbi),
                    child: CircularProgressIndicator()),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

