import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/home/profileSetting.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';

class ChangePassword extends StatefulWidget {
  String from;
  ChangePassword({this.from});
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  void initState() {
    bloc.onPasswordChange(null);
    bloc.onOldPasswordChange(null);
    super.initState();
  }

  final password1 = new FocusNode();
  final password2 = new FocusNode();
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
            if (widget.from == "user")
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ProfileSetting(
                        provider: false,
                      )));
            else
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ProfileSetting(
                        provider: true,
                      )));
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
                                    if (widget.from == "user")
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileSetting(
                                                    provider: false,
                                                  )));
                                    else
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileSetting(
                                                    provider: true,
                                                  )));
                                  },
                                  icon: Icons.arrow_back_ios,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    Container(
                                      width: bloc.size().width,
                                      margin: EdgeInsets.only(
                                          top: bloc.size().height / 8),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)
                                                .tr("profile.doYou"),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          StreamBuilder<String>(
                                            stream: validate
                                                ? bloc.oldPasswordStream
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
                                                      .requestFocus(password1);
                                                });
                                              },
                                              password: true,
                                              focusNode: password1,
                                              label: AppLocalizations.of(
                                                      context)
                                                  .tr("profile.oldPassword"),
                                              onChanged:
                                                  bloc.onOldPasswordChange,
                                            ),
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
                                                      .requestFocus(password2);
                                                });
                                              },
                                              password: true,
                                              focusNode: password2,
                                              label: AppLocalizations.of(
                                                      context)
                                                  .tr("profile.newPassword"),
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
                                                  text: AppLocalizations.of(
                                                          context)
                                                      .tr(
                                                    "profile.cancel",
                                                  ),
                                                  onPressed: () {
                                                    widget.from == "user"
                                                        ? Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProfileSetting(
                                                                              provider: false,
                                                                            )))
                                                        : Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProfileSetting(
                                                                              provider: true,
                                                                            )));
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                StreamBuilder<Object>(
                                                    stream: bloc
                                                        .combineTwoPasswordFields,
                                                    builder:
                                                        (context, snapshot) {
                                                      return BumbiButton(
                                                        colored: true,
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)
                                                                .tr(
                                                          "profile.save",
                                                        ),
                                                        onPressed: () async {
                                                          setState(() {
                                                            validate = true;
                                                          });
                                                          if (bloc.oldPassword() ==
                                                                  null ||
                                                              bloc.password() ==
                                                                  null)
                                                            setState(() {
                                                              empty = true;
                                                            });
                                                          else if (snapshot
                                                              .hasError)
                                                            setState(() {
                                                              validate = true;
                                                            });
                                                          else {
                                                            //
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            await updatePassword();
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
                                                              scaffold
                                                                  .currentState
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(bloc
                                                                    .errorUser()
                                                                    .msg),
                                                              ));}
                                                            else {
                                                              widget.from ==
                                                                      "user"
                                                                  ? Navigator.of(context).pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ProfileSetting(
                                                                                provider: false,
                                                                              )))
                                                                  : Navigator.of(
                                                                          context)
                                                                      .pushReplacement(MaterialPageRoute(
                                                                          builder: (context) => ProfileSetting(
                                                                                provider: true,
                                                                              )));
                                                            }
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
          )),
    );
  }
}
