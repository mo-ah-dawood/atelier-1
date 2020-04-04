import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/shared_preferences_helper.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';

class PayPAckage extends StatefulWidget {
  @override
  _PayPAckageState createState() => _PayPAckageState();
}

class _PayPAckageState extends State<PayPAckage> {
  bool validate = false;
  final emailNode = new FocusNode();
  bool loading = false;
  final passwordNode = new FocusNode();
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
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
                MaterialPageRoute(builder: (context) => Login()));
            return Future.value(false);
          },
          child: SafeArea(
            child: Scaffold(
              key: scaffold,
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
                                  width: bloc.size().width,
                                  margin: EdgeInsets.only(
                                      top: bloc.size().height / 8),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("payPackage.header"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("payPackage.underHeader"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: bloc.sizeArea() * 2.9,
                                      ),
                                      FutureBuilder(
                                          future: packagesWidgets(),
                                          initialData: LoadingFullScreen(),
                                          builder: (context, s) => s.data),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        width: 400,
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            BumbiButton(
                                              colored: false,
                                              child: Container(),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: 10,
                                              ),
                                            ),
                                            BumbiButton(
                                              colored: true,
                                              text: AppLocalizations.of(context)
                                                  .tr(
                                                "payPackage.pay",
                                              ),
                                              onPressed: () async {
                                                if (bloc.selectedPackage() ==
                                                    null)
                                                  showSnackBarContent(
                                                      Text(AppLocalizations.of(
                                                              context)
                                                          .tr("validators.payPackage")),
                                                      scaffold);
                                                else {
                                                  print("${bloc.email()}");
                                                  await atelierPayMent(
                                                      double.parse(bloc
                                                          .packages[bloc
                                                              .selectedPackage()]
                                                          .price
                                                          .toString()),
                                                      "http://atelierapps.com/api/v1/package/${bloc.selectedPackage()}/user/${bloc.currentUser().id}",
                                                      "http://atelierapps.com/api/v1/failed_transfer",
                                                      context);
                                                  // var alrt = AlertDialog(
                                                  //   title: Text(
                                                  //       "هذه رسالة تجريبية لتوضيح سبب استمرار ظهور هذه الشاشة .. الدفع لم يتم بعد فالمستخدم لم يشترك بالفعل في أي باقة ولهذا تستمر في الظهور"),
                                                  //   actions: <Widget>[
                                                  //     FlatButton(
                                                  //         onPressed: () {
                                                  //           Navigator.of(
                                                  //                   context)
                                                  //               .pop();
                                                  //         },
                                                  //         child: Text("حسناً")),
                                                  //     FlatButton(
                                                  //         onPressed: () {
                                                  //           Navigator.of(
                                                  //                   context)
                                                  //               .pushReplacement(
                                                  //                   MaterialPageRoute(
                                                  //                       builder: (context) =>
                                                  //                           AtelierProviderCenter(
                                                  //                             index: 0,
                                                  //                           )));
                                                  //         },
                                                  //         child: Text(
                                                  //             "تخطي الدفع"))
                                                  //   ],
                                                  // );
                                                  String p =
                                                      await getSharedStringOfKey(
                                                          "pass");
                                                          bloc.onPasswordChange(p);
                                                  if (p != null) {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    await loginPost();
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }
                                                  if (bloc
                                                          .currentUser()
                                                          .package_id !=
                                                      null)
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AtelierProviderCenter(
                                                                          index:
                                                                              0,
                                                                        )));
                                                  else
                                                    showSnackBarContent(
                                                        Text(AppLocalizations
                                                                .of(context)
                                                            .tr("payPackage.faild")),
                                                        scaffold);
                                                  // await showDialog(
                                                  //     context: context,
                                                  //     child: alrt);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        loading ? LoadingFullScreen() : SizedBox()
                      ],
                    )),
              ),
            ),
          )),
    );
  }
}
