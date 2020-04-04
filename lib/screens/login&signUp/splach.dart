import 'package:atelier/blocs/design.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:atelier/screens/login&signUp/signUp.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';
import 'dart:async';

import 'package:permission/permission.dart';
class Splach extends StatefulWidget {
  @override
  _SplachState createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  bool start = false;
  bool up = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () {
      setState(() {
        start = true;
      });
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        up = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    bloc.sendlang(localCode);
    return WillPopScope(
      onWillPop: () {
        return bloc.onClose(context);
      },
      child: EasyLocalizationProvider(
          data: EasyLocalizationProvider.of(context).data,
          child: Scaffold(
              body: Container(
            width: bloc.size().width,
            height: bloc.size().height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  left: localCode == "ar" ? 0 : null,
                  right: localCode == "ar" ? null : 0,
                  child: AnimatedOpacity(
                      duration: mill2Second,
                      opacity: start ? 0.2 : 0.0,
                      child: Container(
                          alignment: localCode == "ar"
                              ? Alignment.bottomLeft
                              : Alignment.bottomRight,
                          width: bloc.size().width - 50,
                          height: bloc.size().height - 50,
                          child: Image.asset(
                            'assets/images/$girle',
                            fit: BoxFit.fill,
                          ))),
                ),
                logo(up, start),
                selectUserRow(up, context),
                AnimatedPositioned(
                  duration: mill0Second,
                  bottom: up ? 20 : -50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    highlightColor: bumbiAccent.withOpacity(.5),
                    splashColor: Colors.red[50],
                    onPressed: () {
                      this.setState(() {
                        if (Localizations.localeOf(context)
                                .languageCode
                                .toString() ==
                            "en") {
                          data.changeLocale(Locale("ar", "SA"));
                          bloc.sendlang("ar");
                        } else {
                          data.changeLocale(Locale("en", "US"));
                          bloc.sendlang("en");
                        }
                      });
                    },
                    child: Text(
                        AppLocalizations.of(context).tr("splach.changeLang")),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}

Widget logo(bool up, bool start) {
  return AnimatedPositioned(
    duration: mill1Second,
    bottom: up ? (bloc.size().height / 2) + 20 : bloc.size().height / 2 - 20,
    child: AnimatedOpacity(
        duration: mill1Second,
        opacity: start ? 1.0 : 0.0,
        child: Container(
          width: 100,
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        )),
  );
}
    requestPermissions() async {
    List<PermissionName> permissionNames = [];
     permissionNames.add(PermissionName.Camera);
     permissionNames.add(PermissionName.Contacts);
     permissionNames.add(PermissionName.Microphone);
     permissionNames.add(PermissionName.Phone);
     permissionNames.add(PermissionName.Storage);
     permissionNames.add(PermissionName.Internet);
    var permissions = await Permission.requestPermissions(permissionNames);
  }


Widget selectUserRow(bool up, BuildContext context) {
  return AnimatedPositioned(
    duration: mill0Second,
    bottom: up ? (bloc.size().height / 2) - 60 : -50,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: bloc.size().width,
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BumbiButton(
            colored: true,
            text: AppLocalizations.of(context).tr("splach.userButton"),
            onPressed: ()async {
              bloc.setUserType("user");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          SizedBox(
            width: 10,
          ),
          BumbiButton(
            colored: true,
            text: AppLocalizations.of(context).tr("splach.fashionHouseButton"),
            onPressed: ()async {
              bloc.setUserType("provider");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      ),
    ),
  );
}
