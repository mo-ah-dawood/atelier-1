import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/shared_preferences_helper.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/login&signUp/confirm.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailNode = new FocusNode();
  bool validate = false;
  bool empty=false;
  bool loading=false;
  GlobalKey<ScaffoldState>scaffold=GlobalKey();
  @override
  void initState() {
    bloc.sendErrorUser(UserService(status: null, msg: null));
    bloc.onEmailChange(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    return EasyLocalizationProvider(
      data: data,
      child:WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
          return Future.value(false);
        },
        child:Scaffold(
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
                      left: bloc.lang() == "ar" ? 0 : null,
                      right: bloc.lang() == "ar" ? null : 0,
                      child: Opacity(
                          opacity: 0.2,
                          child: Container(
                              alignment: bloc.lang() == "ar"
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
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SmallIconButton(
                              onPressed: (){      
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
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
                                        .tr("forgetPassword.enterEmail"),
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
                                        .tr("forgetPassword.underEnterEmail"),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  StreamBuilder<String>(
                                    stream: validate ? bloc.emailStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      lang: Localizations.localeOf(context)
                                          .languageCode
                                          .toString(),
                                          value: empty?bloc.email():"",
                                      error: s.hasError
                                          ? AppLocalizations.of(context)
                                              .tr("validators.emailValidate")
                                          : null,
                                      unFocus: () {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(emailNode);
                                        });
                                      },
                                      password: false,
                                      focusNode: emailNode,
                                      label: AppLocalizations.of(context)
                                          .tr("login.email"),
                                      onChanged: bloc.onEmailChange,
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
                                          child: Container(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        StreamBuilder<Object>(
                                            stream: bloc.emailStream,
                                            builder: (context, snapshot) {
                                              return BumbiButton(
                                                colored: true,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr(
                                                  "forgetPassword.confirm",
                                                ),
                                                onPressed: () async{
                                                
                                                    setState(() {
                                                      validate = true;
                                                    });
                                                  if(bloc.email()==null){
                                                    setState(() {
                                                      empty=true;
                                                    });
                                                    scaffold.currentState.showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          AppLocalizations.of(context).tr("validators.empty")
                                                        ),
                                                      )
                                                    );
                                                  }
                                                  else if(snapshot.hasError)
                                                  setState(() {
                                                    validate=true;
                                                  });
                                                  
                                                  else {
                                                    setState(() {
                                                      loading=true;
                                                    });
                                                    await resendCode();
                                                    
                                                    setState(() {
                                                      loading=false;
                                                    });
                                                    if(bloc.errorUser().msg==null)
                                                    {
                                                      print(bloc.currentUser().activation_code);
                                                    await addSharedBool("forget",true);
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Confirm(from: "forget",)));
                                                                   }     
                                            else{ if(bloc.errorUser().status==401)
                                                          {
                                                            await clearUserData();
                                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                                          }else
                                              scaffold.currentState.showSnackBar(
                                                SnackBar(content: Text(bloc.errorUser().msg),)
                                              );}
                                                                    
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
                            )
                          ],
                        ),
                      ),
                    ),
                    loading?LoadingFullScreen():SizedBox()
                  ],
                )),
          ),)
        ),
      
    );
  }
}
