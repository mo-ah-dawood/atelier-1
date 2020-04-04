import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/login&signUp/forgetPassword.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';

class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  @override
  void initState() {
    bloc.onPasswordChange(null);
    super.initState();
  }

  final emailNode = new FocusNode();
  bool validate = false;
  bool loading = false;
  bool empty = false;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));

    var data = EasyLocalizationProvider.of(context).data;
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    return EasyLocalizationProvider(
        data: data,
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ForgetPassword()));
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
                    width: bloc.size().width,
                    height: bloc.size().height,
                    child: Stack(
                      alignment: Alignment.topRight,
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
                                  width: bloc.size().width - 50,
                                  height: bloc.size().height - 50,
                                  child: Image.asset(
                                    'assets/images/$girle',
                                    fit: BoxFit.fill,
                                  ))),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SmallIconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPassword()));
                                  },
                                  icon: Icons.arrow_back_ios,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    Container(
                                      width: bloc.size().width,
                                      margin: EdgeInsets.only(
                                          top: bloc.size().height / 6),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)
                                                .tr("newPassword.enterNew"),
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
                                                .tr("newPassword.underEnter"),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          StreamBuilder<String>(
                                            stream: validate
                                                ? bloc.passwordStream
                                                : null,
                                            builder: (context, s) =>
                                                AtelierTextField(
                                              lang: Localizations.localeOf(
                                                      context)
                                                  .languageCode
                                                  .toString(),
                                              error: s.hasError
                                                  ? AppLocalizations.of(context)
                                                      .tr("validators.passwordValidate")
                                                  : null,
                                              value:
                                                  empty ? bloc.password() : "",
                                              unFocus: () {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(emailNode);
                                                });
                                              },
                                              password: true,
                                              focusNode: emailNode,
                                              label: AppLocalizations.of(
                                                      context)
                                                  .tr("newPassword.password"),
                                              onChanged: bloc.onPasswordChange,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 400,
                                            height: 40,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                BumbiButton(
                                                  colored: false,
                                                  child: Container(),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                StreamBuilder<Object>(
                                                    stream: bloc.passwordStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return BumbiButton(
                                                        colored: true,
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)
                                                                .tr(
                                                          "newPassword.confirm",
                                                        ),
                                                        onPressed: () async {
                                                          setState(() {
                                                            validate = true;
                                                          });
                                                          if (bloc.password() ==
                                                                  null ||
                                                              snapshot.hasError)
                                                            setState(() {
                                                              empty = true;
                                                            });
                                                          else {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            await resetPassword();
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                            if (bloc
                                                                    .errorUser()
                                                                    .msg !=
                                                                null){
                                                                   if(bloc.errorUser().status==401)
                                                          {
                                                            await clearUserData();
                                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                                          }else
                                                              scaffold
                                                                  .currentState
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(bloc
                                                                    .errorUser()
                                                                    .msg),
                                                              ));}
                                                            else {
                                                              print(bloc
                                                                  .currentUser()
                                                                  .activation_code);
                                                              //changed
                                                              if (bloc
                                                                      .currentUser()
                                                                      .type ==
                                                                  "user") {
                                                                ////

                                                                bloc.setUserType(
                                                                    "user");
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Login()),
                                                                );
                                                              } ////
                                                              else if (bloc
                                                                      .currentUser()
                                                                      .type ==
                                                                  "provider") {
                                                                /////

                                                                bloc.setUserType(
                                                                    "provider");
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Login()));
                                                              }
                                                            } ////////////
                                                          }
                                                        },
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        loading ? LoadingFullScreen() : SizedBox()
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
