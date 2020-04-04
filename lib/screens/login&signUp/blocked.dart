import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:atelier/screens/login&signUp/splach.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Blocked extends StatefulWidget {
  @override
  _BlockedState createState() => _BlockedState();
}

class _BlockedState extends State<Blocked> {
  bool validate = false;
  final emailNode = new FocusNode();
  final passwordNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    var data = EasyLocalizationProvider.of(context).data;
    String girle = AppLocalizations.of(context).tr("signUp.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
         Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context)=>Login()
         ));  
        return Future.value(false); 
        },
        child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                width: bloc.size().width,
                height: bloc.size().height,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: bloc.size().width,
                              margin:
                                  EdgeInsets.only(top: bloc.size().height / 6),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("signUp.hello"),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("signUp.underHello"),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: bloc.sizeArea() * 2.5,
                                  ),
                                  Container(
                                      height: bloc.size().height / 1.8,
                                      alignment: localCode == "ar"
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: Image.asset("assets/images/girle_$localCode.png")),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),)
      ),
    );
  }
}
