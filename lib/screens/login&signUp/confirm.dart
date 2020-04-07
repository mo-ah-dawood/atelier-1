import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/shared_preferences_helper.dart';
import 'package:atelier/models/articleModel.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/login&signUp/forgetPassword.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:atelier/screens/login&signUp/payPackage.dart';
import 'package:atelier/screens/login&signUp/signUp.dart';
import 'package:atelier/screens/login&signUp/waitForAccept.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'newPassword.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

class Confirm extends StatefulWidget {
  String from;
  Confirm({this.from});
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  initState() {
    super.initState();
  }

  bool empty = false;
  bool validate = false;
  bool loading = false;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  final codeNode = new FocusNode();
  TextEditingController pinCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
          if (widget.from == "signUp")
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUp()));
          else
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ForgetPassword()));
          return Future.value(false);
        },
        child: Scaffold(
          key: scaffold,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                padding: EdgeInsets.only(top: 20),
                width: bloc.size().width,
                height: bloc.size().height,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    // Positioned(
                    //   bottom: 0,
                    //   left: bloc.lang() == "ar" ? 0 : null,
                    //   right: bloc.lang() == "ar" ? null : 0,
                    //   child: Opacity(
                    //       opacity: 0.2,
                    //       child: Container(
                    //           alignment: bloc.lang() == "ar"
                    //               ? Alignment.bottomLeft
                    //               : Alignment.bottomRight,
                    //           width: bloc.size().width - 50,
                    //           height: bloc.size().height - 50,
                    //           child: Image.asset(
                    //             'assets/images/$girle',
                    //             fit: BoxFit.fill,
                    //           ))),
                    // ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SmallIconButton(
                              onPressed: () {
                                if (widget.from == "signUp")
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                else
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                              },
                              icon: Icons.arrow_back_ios,
                            ),
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
                                        .tr("confirm.enterCode"),
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
                                        .tr("confirm.underEnter"),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  StreamBuilder(
                                    stream: validate ? bloc.codeStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      password: false,
                                      value: empty ? bloc.code() : "",
                                      error: s.hasError
                                          ? AppLocalizations.of(context)
                                              .tr("login.passwordValidate")
                                          : null,
                                      unFocus: () {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(codeNode);
                                        });
                                      },
                                      focusNode: codeNode,
                                      label: AppLocalizations.of(context)
                                          .tr("confirm.code"),
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: PinInputTextFormField(
                                          autoFocus: true,
                                          focusNode: codeNode,
                                          onChanged: bloc.onCodeChange,
                                          decoration: UnderlineDecoration(
                                              gapSpace: 20,
                                              enteredColor: bumbi,
                                              color: hint.withOpacity(0.5),
                                              lineHeight: 1.5),
                                          pinLength: 4,
                                        ),
                                      ),
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
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        BumbiButton(
                                          colored: false,
                                          text: AppLocalizations.of(context)
                                              .tr("confirm.reSend"),
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                            });

                                            await resendCode();
                                            setState(() {
                                              loading = false;
                                            });
                                            if (int.tryParse(bloc
                                                    .currentUser()
                                                    .activation_code) !=
                                                null)
                                             {  
        //                                         showDialog(
        //   context: context,
        //   builder: (context) => new AlertDialog(
        //     title: new Text("هذه الرسالة تجريبية "),
        //     content: new Text("هذه الرسالة بها كود التفعيل في حال عدم وصول الكود أو الرغبة بتجربة إيميلات غير حقيقية\nكود التفعيل \n ${bloc.currentUser().activation_code.toString()}"),
        //     actions: <Widget>[
        //       new FlatButton(
        //           onPressed: () => Navigator.of(context).pop(),
        //           child: new Text(AppLocalizations.of(context).tr("onPop.no"))),
        //       new FlatButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         child: new Text(AppLocalizations.of(context).tr("onPop.yes")),
        //       ),
        //     ],
        //   ),
        // );
                                              print(bloc
                                                  .currentUser()
                                                  .activation_code);}
                                            if (bloc.errorUser().msg != null){ if(bloc.errorUser().status==401)
                                                          {
                                                            await clearUserData();
                                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                                          }else
                                              scaffold.currentState
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text(bloc.errorUser().msg),
                                              ));}
                                            else
                                              scaffold.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    AppLocalizations.of(context)
                                                        .tr("confirm.done")),
                                              ));
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        StreamBuilder<Object>(
                                            stream: bloc.codeStream,
                                            builder: (context, snapshot) {
                                              return BumbiButton(
                                                colored: true,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr(
                                                  "confirm.confirm",
                                                ),
                                                onPressed: () async {
                                                  ////////////////// validation
                                                  setState(() {
                                                    validate = true;
                                                  });
                                                  if (bloc.code() == null ||
                                                      bloc.code().length < 4 ||
                                                      snapshot.hasError) {
                                                    scaffold.currentState
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .tr("validators.empty")),
                                                    ));
                                                    ///////////////////
                                                  } else {
                                                    
                                                    if (widget.from ==
                                                        "signUp") {
                                                      ////////from signup
                                                    if (bloc.code() ==
                                                          bloc
                                                              .currentUser()
                                                              .activation_code) {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      await activate();

                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      if (bloc
                                                              .errorUser()
                                                              .msg !=
                                                          null){ if(bloc.errorUser().status==401)
                                                          {
                                                            await clearUserData();
                                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                                          }else
                                                        scaffold.currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(bloc
                                                              .errorUser()
                                                              .msg),
                                                        ));}
                                                      else{
                                                      setState(() {
                                                        loading=true;
                                                      });
                                                                                                              await staticData();

  await loginData();
    await getAllArticleCategories(context);

setState(() {
  loading=false;
});
                                                        chooseScreen(context,false);}
                                                    } else
                                                        scaffold.currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .tr("validators.wrongCode")),
                                                        ));
                                                    
                                                     }//من التسجيل
                                                    else if (widget.from ==
                                                        "forget") {
                                                      if (bloc.code() ==
                                                          bloc
                                                              .currentUser()
                                                              .activation_code) {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        await activate();
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        if(bloc
                                                              .errorUser()
                                                              .msg !=
                                                          null){ if(bloc.errorUser().status==401)
                                                          {
                                                            await clearUserData();
                                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                                          }else
                                                        scaffold.currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(bloc
                                                              .errorUser()
                                                              .msg),
                                                        ));}
                                                      else
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            NewPassword()));
                                                      } else
                                                        scaffold.currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .tr("validators.wrongCode")),
                                                        ));
                                                    }
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }
                                                  await removeSharedOfKey("forget");
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
      ),
    );
  }
}
