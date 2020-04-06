import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:atelier/screens/more/about.dart';
import 'package:atelier/screens/more/contact.dart';
import 'package:atelier/screens/more/packages.dart';
import 'package:atelier/screens/more/terms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/screens/home/userFashion.dart';
class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  initState(){

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    logOut() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text(AppLocalizations.of(context).tr("onPop.title")),
          content: new Text(AppLocalizations.of(context).tr("onPop.logOut")),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(AppLocalizations.of(context).tr("onPop.no"),
                    style: TextStyle(color: bumbi))),
            new FlatButton(
              onPressed: () {
                clearUserData();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Splach()));
                return false;
              },
              child: new Text(
                AppLocalizations.of(context).tr("onPop.yes"),
                style: TextStyle(color: bumbi),
              ),
            ),
          ],
        ),
      );
    }

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: bloc.size().width,
            height: bloc.size().height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    // image
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    height: 180,
                    width: 180,
                    child: Image.asset('assets/images/more.png'),
                  ),
                  bloc.currentUser().type == "user"
                      ? MoreButton(
                          onPressed: () {
                           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>UserFashion()));
                          },
                          iconSRC: 'assets/images/dress.png',
                          text: AppLocalizations.of(context).tr("more.new"),
                        )
                      : MoreButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Packages()));
                          },
                          iconSRC: 'assets/images/packages.png',
                          text:
                              AppLocalizations.of(context).tr("more.packages"),
                        ),
                  MoreButton(
                    onPressed: () {
                    
                    // print(bloc.deviceToken());
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => About()));
                    },
                    iconSRC: 'assets/images/aboutus.png',
                    text: AppLocalizations.of(context).tr("more.about"),
                  ),
                  MoreButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Contact()));
                    },
                    iconSRC: 'assets/images/contactus.png',
                    text: AppLocalizations.of(context).tr("more.contact"),
                  ),
                  MoreButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Terms()));
                    },
                    iconSRC: 'assets/images/terms.png',
                    text: AppLocalizations.of(context).tr("more.terms"),
                  ),
                  MoreButton(
                    onPressed: logOut,
                    iconSRC: 'assets/images/logout.png',
                    text: AppLocalizations.of(context).tr("more.logOut"),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MoreButton extends StatelessWidget {
  String text;
  Function onPressed;
  String iconSRC;
  MoreButton({this.iconSRC, this.onPressed, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: MaterialButton(
          elevation: 0,
          padding: EdgeInsets.all(10),
          highlightColor: bumbiAccent,
          splashColor: bumbiAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          onPressed: () {
            onPressed();
          },
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                iconSRC,
                height: 40,
                width: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                child: Wrap(
                  children: <Widget>[
                    Text(
                      text,
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
