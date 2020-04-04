import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:atelier/screens/more/repay.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/blocs/widgets.dart';

class Packages extends StatefulWidget {
  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  bool validate = false;
  final emailNode = new FocusNode();
  final passwordNode = new FocusNode();
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
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AtelierProviderCenter(screen: 3,)));
            return Future.value(false);
          },
          child: SafeArea(
            child: Scaffold(
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                    width: size.width,
                    height: size.height,
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
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: <Widget>[
                                      SmallIconButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AtelierProviderCenter(
                                                        screen: 3,
                                                      )));
                                        },
                                        icon: Icons.arrow_back_ios,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("more.packages"),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("more.current"),
                                        style: TextStyle(
                                            fontSize: 14, color: hint),
                                      )
                                    ],
                                  ),
                                ),

                                //// current
                                Container(
                                  width: bloc.size().width,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                                                            FutureBuilder(
                                          future: packagesHistoryWidgets(),
                                          initialData: LoadingFullScreen(),
                                          builder: (context, s) => s.data),

                                      // PackageCard(
                                      //   title: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.name"),
                                        // date:
                                        //     "${AppLocalizations.of(context).tr("more.date")}   1 أكتوبر",
                                      //   desc: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.period"),
                                      //   cost: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.cost"),
                                      //   moneyType: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.type"),
                                      // ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      // Text(
                                      //   AppLocalizations.of(context)
                                      //       .tr("more.history"),
                                      //   style: TextStyle(
                                      //       fontSize: 14, color: hint),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // PackageCard(
                                      //   history: true,
                                      //   title: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.name"),
                                      //   desc: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.period"),
                                      //   cost: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.cost"),
                                      //   moneyType: AppLocalizations.of(context)
                                      //       .tr("payPackage.first.type"),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // PackageCard(
                                      //   history: true,
                                      //   title: AppLocalizations.of(context)
                                      //       .tr("payPackage.second.name"),
                                      //   desc: AppLocalizations.of(context)
                                      //       .tr("payPackage.second.period"),
                                      //   cost: AppLocalizations.of(context)
                                      //       .tr("payPackage.second.cost"),
                                      //   moneyType: AppLocalizations.of(context)
                                      //       .tr("payPackage.second.type"),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // PackageCard(
                                      //   history: true,
                                      //   title: AppLocalizations.of(context)
                                      //       .tr("payPackage.third.name"),
                                      //   desc: AppLocalizations.of(context)
                                      //       .tr("payPackage.third.period"),
                                      //   cost: AppLocalizations.of(context)
                                      //       .tr("payPackage.third.cost"),
                                      //   moneyType: AppLocalizations.of(context)
                                      //       .tr("payPackage.third.type"),
                                      // ),
                                      // SizedBox(
                                      //   height: 40,
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: bloc.size().width,
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                BumbiButton(
                                  colored: true,
                                  text: AppLocalizations.of(context).tr(
                                    "more.repay",
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => RePay()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          )),
    );
  }
}
