import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/shared_preferences_helper.dart';
import 'package:atelier/main.dart';

import 'package:atelier/screens/login&signUp/confirm.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:atelier/screens/login&signUp/providerSignUp.dart';

import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/more/terms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    nameCTL.text=bloc.name();
    emailCTL.text=bloc.email();
    siteCTL.text=bloc.site();
    mobileCTL.text=bloc.mobile();
    passwordCTL.text=bloc.password();
    super.initState();
  }
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  final nameNode = new FocusNode();
  final emailNode = new FocusNode();
  final siteNode = new FocusNode();
  final mobileNode = new FocusNode();
  final passwordNode = new FocusNode();
  final nameCTL = new TextEditingController();
  final emailCTL = new TextEditingController();
  final siteCTL = new TextEditingController();
  final mobileCTL = new TextEditingController();
  final passwordCTL = new TextEditingController();

  bool empty = false;
  bool agreed = false;
  bool rulesError = false;
  bool validate = false;
  bool loading = false;
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
                              icon: Icons.arrow_back_ios,
                             onPressed: (){          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
},
                            ),
                            Container(
                              width: bloc.size().width,
                              margin:
                                  EdgeInsets.only(top:70),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("signUp.joinUs"),
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
                                        .tr("signUp.underJoin"),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  // named field
                                  StreamBuilder<String>(
                                    stream: validate ? bloc.nameStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      // controller: name,
                                      value: empty ? bloc.name() : "",
                                      lang: Localizations.localeOf(context)
                                          .languageCode
                                          .toString(),
                                          controller: nameCTL,
                                      error: s.hasError
                                          ? AppLocalizations.of(context)
                                              .tr("validators.nameValidate")
                                          : null,
                                      unFocus: () {
                                        setState(() {
                                          emailNode.unfocus();
                                          siteNode.unfocus();
                                          mobileNode.unfocus();
                                          passwordNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(nameNode);
                                        });
                                      },
                                      password: false,
                                      focusNode: nameNode,
                                      label: AppLocalizations.of(context)
                                          .tr("signUp.name"),
                                      onChanged: bloc.onNameChange,
                                    ),
                                  ),
                                  //email field
                                  StreamBuilder<String>(
                                    stream: validate ? bloc.emailStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      controller: emailCTL,
                                      value: empty ? bloc.email() : "",
                                      lang: Localizations.localeOf(context)
                                          .languageCode
                                          .toString(),
                                      error: s.hasError
                                          ? AppLocalizations.of(context)
                                              .tr("validators.emailValidate")
                                          : null,
                                      type: TextInputType.emailAddress,
                                      unFocus: () {
                                        setState(() {
                                          nameNode.unfocus();
                                          siteNode.unfocus();

                                          mobileNode.unfocus();
                                          passwordNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(emailNode);
                                        });
                                      },
                                      password: false,
                                      focusNode: emailNode,
                                      label: AppLocalizations.of(context)
                                          .tr("signUp.email"),
                                      onChanged: bloc.onEmailChange,
                                    ),
                                  ),
                                  //mobile field
                                  StreamBuilder<String>(
                                    stream: validate ? bloc.mobileStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      controller: mobileCTL,
                                      value: empty ? bloc.mobile() : "",
                                      lang: Localizations.localeOf(context)
                                          .languageCode
                                          .toString(),
                                      error: s.hasError
                                          ? AppLocalizations.of(context)
                                              .tr("validators.mobileValidate")
                                          : null,
                                      type: TextInputType.number,
                                      unFocus: () {
                                        setState(() {
                                          nameNode.unfocus();
                                          siteNode.unfocus();

                                          emailNode.unfocus();
                                          passwordNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(mobileNode);
                                        });
                                      },
                                      password: false,
                                      focusNode: mobileNode,
                                      label: AppLocalizations.of(context)
                                          .tr("signUp.mobile"),
                                      onChanged: bloc.onMobileChange,
                                    ),
                                  ),
                                  //web site field
                                  bloc.userType() == "user"
                                      ? SizedBox()
                                      : StreamBuilder<String>(
                                          stream:
                                              validate ? bloc.siteStream : null,
                                          builder: (context, s) =>
                                              AtelierTextField(
                                                controller: siteCTL,
                                            value: "",
                                            lang:
                                                Localizations.localeOf(context)
                                                    .languageCode
                                                    .toString(),
                                            error: s.hasError
                                                ? AppLocalizations.of(context)
                                                    .tr("validators.siteValidate")
                                                : null,
                                            type: TextInputType.url,
                                            unFocus: () {
                                              setState(() {
                                                emailNode.unfocus();
                                                siteNode.unfocus();
                                                mobileNode.unfocus();
                                                passwordNode.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(siteNode);
                                              });
                                            },
                                            password: false,
                                            focusNode: siteNode,
                                            label: AppLocalizations.of(context)
                                                .tr("signUp.site"),
                                            onChanged: bloc.onSiteChange,
                                          ),
                                        ),
                                  //password field
                                  StreamBuilder(
                                    stream:
                                        validate ? bloc.passwordStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      controller: passwordCTL,
                                      value: empty ? bloc.password() : "",
                                      lang: Localizations.localeOf(context)
                                          .languageCode
                                          .toString(),
                                      error: s.hasError
                                          ? AppLocalizations.of(context)
                                              .tr("validators.passwordValidate")
                                          : null,
                                      unFocus: () {
                                        setState(() {
                                          nameNode.unfocus();
                                          mobileNode.unfocus();
                                          siteNode.unfocus();
                                          emailNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(passwordNode);
                                        });
                                      },
                                      focusNode: passwordNode,
                                      label: AppLocalizations.of(context)
                                          .tr("signUp.password"),
                                      onChanged: bloc.onPasswordChange,
                                      password: true,
                                    ),
                                  ),
                                  // rules and conditions
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          onTap: () {
                                            setState(() {
                                              agreed = !agreed;
                                              if (agreed) rulesError = false;
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            child: agreed
                                                ? Icon(
                                                    Icons.check,
                                                    size: 20,
                                                    color: bumbi,
                                                  )
                                                : SizedBox(),
                                            decoration: BoxDecoration(
                                                border: rulesError
                                                    ? Border.all(
                                                        color: Colors.red,
                                                        width: 1)
                                                    : null,
                                                color: bumbiAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: (){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Terms(signup: true,)));
                

                                          },
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .tr("signUp.agree"),
                                              style: TextStyle(
                                                  color: rulesError
                                                      ? Colors.red
                                                      : hint,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15)),
                                        ),
                                      ],
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
                                        StreamBuilder<Object>(
                                            stream:
                                                bloc.combineEditProfileFields,
                                            builder: (context, snapshot) {
                                              return BumbiButton(
                                                colored: true,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr(
                                                  "signUp.signUp",
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    validate=true;
                                                  });
                                                  if (agreed==false)
                                                    setState(() {
                                                      rulesError = true;
                                                    });

                                                 if (bloc.userType() ==
                                                      "provider") {
                                                    
                                                    if (bloc.email() == null ||
                                                        bloc.name() == null ||
                                                        bloc.mobile() == null ||
                                                        rulesError==true||
                                                        bloc.password() ==
                                                            null) {
                                                              
                                                      scaffold.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .tr("validators.empty")),
                                                      ));
                                                      setState(() {
                                                        empty = true;
                                                      });
                                                    }
                                                    else if(snapshot.hasError||rulesError==true)
                                                    setState(() {
                                                      validate=true;
                                                    });
                                                    
                                                    else
                                                      Navigator.of(context).pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProviderSignUp()));
                                                  }
                                                  ///provider
                                                  ///
                                                  ///user
                                       else           if (bloc.userType() ==
                                                      "user") {
                                                    
                                                      setState(() {
                                                        validate = true;
                                                      });

                                                   if (bloc.email() == null ||
                                                        bloc.name() == null ||
                                                        bloc.mobile() == null ||
                                                        rulesError==true||
                                                        bloc.password() ==
                                                            null) {
                                                              
                                                      scaffold.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .tr("validators.empty")),
                                                      ));
                                                      setState(() {
                                                        empty = true;
                                                      });
                                                    } else if(snapshot.hasError||rulesError==true)
                                                    setState(() {
                                                      validate=true;
                                                    });
                                                    else
                                                    
                                                    {//ok
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      await signUpUser();
                                                      
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      if (bloc
                                                              .errorUser()
                                                              .msg ==
                                                          null){
                                                         await   addSharedString("pass",bloc.password());
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Confirm(
                                                                          from:
                                                                              "signUp",
                                                                        )));}
                                                      else{
                                                         if(bloc.errorUser().status==401)
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
                                                        ));
                                                        
                                                        }
                                                    }
                                                  }//user
                                                },
                                              );
                                            }),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        BumbiButton(
                                          colored: false,
                                          text: AppLocalizations.of(context).tr(
                                            "signUp.logIn",
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
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
          )),
        ),
    
    );
  }
}
