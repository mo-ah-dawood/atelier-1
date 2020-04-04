import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/notificationModel.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  String from;
  Notifications({this.from});
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    var data = EasyLocalizationProvider.of(context).data;
    String localCode = Localizations.localeOf(context).languageCode.toString();
    return EasyLocalizationProvider(
        data: data,
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
            return Future.value(false);
          },
          child: SafeArea(
            child: Scaffold(
              body: Container(
                width: bloc.size().width,
                height: bloc.size().height,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: SmallIconButton(
                                icon: Icons.arrow_back_ios,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .tr("notifi.notifi"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: getNotificationCards(context),
                        initialData: <Widget>[LoadingFullScreen()],
                        builder:(context,s){
                        return Column(
                          children:s.data,
                        );
                      }),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class NotificationCard extends StatefulWidget {
  String text;
  String event;
  Function onPressed;
  NotificationCard({this.event, this.text, this.onPressed});
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool notifi = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: blackAccent,
                offset: Offset(-2, 2),
                spreadRadius: -2,
                blurRadius: 2),
            BoxShadow(color: Colors.white, blurRadius: 2)
          ],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: MaterialButton(
        highlightColor: bumbiAccent.withOpacity(0.2),
        highlightElevation: 2,
        splashColor: bumbiAccent.withOpacity(.3),
        padding: EdgeInsets.all(0),
        onPressed: () async{
          // await getAllNotifications();
          setState(() {
            notifi = false;
          });
          widget.onPressed();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  BumbiIconButton(
                    width: 25,
                    iconData: Icons.notifications,
                    onPressed: () {
                      setState(() {
                        notifi = false;
                      });
                      widget.onPressed();
                    },
                  ),
                  notifi
                      ? Icon(
                          Icons.notifications_active,
                          size: 25,
                          color: bumbi,
                        )
                      : SizedBox()
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Wrap(
                  children: <Widget>[
                    Text(
                      widget.text??"",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.event??"",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
