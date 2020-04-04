import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/shared_preferences_helper.dart';
import 'package:atelier/models/articleModel.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/login&signUp/signUp.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void initState() {
    super.initState();
    bloc.sendErrorUser(UserService(status: null, msg: null));
    bloc.onEmailChange(null);
    bloc.onPasswordChange(null);
  }

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool validate = false;
  bool empty = false;
  final emailNode = new FocusNode();
  final passwordNode = new FocusNode();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));

    TextEditingController email = TextEditingController(text: bloc.email());
    TextEditingController password =
        TextEditingController(text: bloc.password());
    var data = EasyLocalizationProvider.of(context).data;
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    return EasyLocalizationProvider(
        data: data,
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Splach()));
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
                                            builder: (context) => Splach()));
                                  },
                                  icon: Icons.arrow_back_ios,
                                ),
                                Container(
                                  width: bloc.size().width,
                                  margin: EdgeInsets.only(
                                      top: bloc.size().height / 6),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("login.welcom"),
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
                                            .tr("login.underWelcom"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      StreamBuilder<String>(
                                        stream:
                                            validate ? bloc.emailStream : null,
                                        builder: (context, s) =>
                                            AtelierTextField(
                                          value: empty ? bloc.email() : "",
                                          lang: Localizations.localeOf(context)
                                              .languageCode
                                              .toString(),
                                          error: s.hasError
                                              ? AppLocalizations.of(context)
                                                  .tr("validators.${s.error}")
                                              : null,
                                          unFocus: () {
                                            setState(() {
                                              passwordNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(emailNode);
                                            });
                                          },
                                          controller: email,
                                          password: false,
                                          focusNode: emailNode,
                                          label: AppLocalizations.of(context)
                                              .tr("login.email"),
                                          onChanged: bloc.onEmailChange,
                                        ),
                                      ),
                                      StreamBuilder(
                                        stream: validate
                                            ? bloc.passwordStream
                                            : null,
                                        builder: (context, s) =>
                                            AtelierTextField(
                                          value: empty ? bloc.password() : "",
                                          lang: Localizations.localeOf(context)
                                              .languageCode
                                              .toString(),
                                          error: s.hasError
                                              ? AppLocalizations.of(context)
                                                  .tr("validators.${s.error}")
                                              : null,
                                          controller: password,
                                          unFocus: () {
                                            setState(() {
                                              emailNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(passwordNode);
                                            });
                                          },
                                          focusNode: passwordNode,
                                          label: AppLocalizations.of(context)
                                              .tr("login.password"),
                                          onChanged: bloc.onPasswordChange,
                                          password: true,
                                          forget: AppLocalizations.of(context)
                                              .tr("login.forgetPassword"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            StreamBuilder(
                                              stream:
                                                  bloc.combineEmailandPassword,
                                              builder: (context, s) =>
                                                  BumbiButton(
                                                colored: false,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr(
                                                  "login.signUp",
                                                ),
                                                onPressed: () {
                                                      bloc.sendErrorUser(UserService(status: null, msg: null));
    bloc.onEmailChange(null);
    bloc.onNameChange(null);
    bloc.onMobileChange(null);
    bloc.onCodeChange(null);
    bloc.onHouseImageChange(null);
    bloc.onNoteChange(null);
    bloc.onSiteChange(null);

                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SignUp()));
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            StreamBuilder(
                                              stream:
                                                  bloc.combineEmailandPassword,
                                              builder: (context, s) =>
                                                  BumbiButton(
                                                colored: true,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr(
                                                  "login.signIn",
                                                ),
                                                onPressed: () async {

                                                  setState(() {
                                                    validate = true;
                                                  });
                                                  if (bloc.email() == null ||
                                                      bloc.password() == null) {
                                                    scaffold.currentState
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .tr("validators.empty")),
                                                    ));
                                                    setState(() {
                                                      empty = true;
                                                    });
                                                  } else if (s.hasError)
                                                    setState(() {
                                                      validate = true;
                                                    });
                                                  else {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    await loginPost();
                                                        await staticData();

  await loginData();
    await getAllArticleCategories(context);


                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    if (bloc.errorUser().msg !=
                                                        null){
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
                                                      ));}
                                                    else{
                                                     await addSharedString("pass", bloc.password());
                                                      chooseScreen(context,false);
                                                  }}
                                                },
                                              ),
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
              ),
            ),
          ),
        ));
  }
}
