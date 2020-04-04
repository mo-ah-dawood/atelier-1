import 'package:atelier/blocs/design.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:atelier/screens/login&signUp/signUp.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';
import 'dart:async';

class Terms extends StatefulWidget {
  bool signup;
  Terms({this.signup});
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    // String code =Localizations.localeOf(context).languageCode;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
          if (widget.signup != null)
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUp()));
          else
            bloc.currentUser().type == "user"
                ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AtelierCenter(
                          screen: 3,
                        )))
                : Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AtelierProviderCenter(
                          screen: 3,
                        )));
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            body: Container(
              width: size.width,
              height: size.height,
              child: Stack(
                alignment: bloc.lang() == "ar"
                    ? Alignment.topRight
                    : Alignment.topLeft,
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    left: localCode == "ar" ? 0 : null,
                    right: localCode == "ar" ? null : 0,
                    child: Opacity(
                      opacity: 0.2,
                      child: Container(
                          alignment: localCode == "ar"
                              ? Alignment.bottomLeft
                              : Alignment.bottomRight,
                          width: size.width - 50,
                          height: size.height - 50,
                          child: Image.asset(
                            'assets/images/$girle',
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                  SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: <Widget>[
                            SmallIconButton(
                              onPressed: () {
                                if (widget.signup != null)
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                else
                                  bloc.currentUser().type == "user"
                                      ? Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AtelierCenter(
                                                    screen: 3,
                                                  )))
                                      : Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AtelierProviderCenter(
                                                    screen: 3,
                                                  )));
                              },
                              icon: Icons.arrow_back_ios,
                            ),
                            Text(
                              AppLocalizations.of(context).tr("more.terms"),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 20, top: 10, left: 20),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).tr("more.terms?"),
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              bloc.staticData().terms,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
