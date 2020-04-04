import 'package:atelier/blocs/design.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
  }

  void whatsAppOpen(String mobile) async {
    var whatsappUrl ="whatsapp://send?phone=$mobile";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      await launch("tel:$mobile");
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
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
                alignment:bloc.lang()=="ar"? Alignment.topRight:Alignment.topLeft,
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
                                bloc.currentUser().type == "user"
                                    ? Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => AtelierCenter(
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
                              AppLocalizations.of(context).tr("more.about"),
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
                              AppLocalizations.of(context).tr("more.what"),
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
                             bloc.staticData().about,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocialIcon(
                            imageSRC: 'assets/images/f.png',
                            onPressed: () async {
                              await _launchURL(bloc.staticData().f);
                            },
                          ),
                          SocialIcon(
                            imageSRC: 'assets/images/t.png',
                            onPressed: () async {
                              await _launchURL(bloc.staticData().t);
                            },
                          ),
                          SocialIcon(
                            imageSRC: 'assets/images/s.png',
                            onPressed: () async {
                              await _launchURL(bloc.staticData().s);
                            },
                          ),
                          SocialIcon(
                            imageSRC: 'assets/images/w.png',
                            onPressed: ()  {
                               whatsAppOpen(bloc.staticData().mobile);
                            },
                          )
                        ],
                      )
                       ],),
                     )
                    ],
                  )
              
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  String imageSRC;
  Function onPressed;
  SocialIcon({this.onPressed, this.imageSRC});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 36,
      width: 36,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Image.asset(imageSRC),
      ),
    );
  }
}
