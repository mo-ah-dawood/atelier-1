import 'dart:io';

import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/shared_preferences_helper.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/login&signUp/changePassword.dart';
import 'package:atelier/screens/login&signUp/confirm.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_fade/image_fade.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileSetting extends StatefulWidget {
  bool provider;
  ProfileSetting({this.provider});
  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  void initState() {
    super.initState();
    note.text = bloc.currentUser().note;
    site.text = bloc.currentUser().site_url;
    bloc.onEmailChange(bloc.currentUser().email);
    bloc.onNameChange(bloc.currentUser().name);
    bloc.onMobileChange(bloc.currentUser().mobile);
    bloc.onNoteChange(bloc.currentUser().note);
    bloc.onSiteChange(bloc.currentUser().site_url);
  }

  final noteNode = new FocusNode();
  final ScrollController controller = ScrollController();

  TextEditingController name =
      TextEditingController(text: bloc.currentUser().name);
  TextEditingController email =
      TextEditingController(text: bloc.currentUser().email);
  TextEditingController mobile =
      TextEditingController(text: bloc.currentUser().mobile);
  TextEditingController site =
      TextEditingController(text: bloc.currentUser().site_url);
  TextEditingController note =
      TextEditingController(text: bloc.currentUser().note);

  final siteNode = new FocusNode();

  final nameNode = new FocusNode();
  final emailNode = new FocusNode();
  final mobileNode = new FocusNode();
  bool empty = false;
  bool agreed = false;
  bool rulesError = false;
  bool validate = false;
  bool loading = false;

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
          // _handleVideo(response.file);
        } else {
          setState(() {
            _image = response.file;
          });
        }
      });
    } else {
      print(response.exception);
    }
  }

  Future cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: AppLocalizations.of(context).tr("profile.cropper"),
            toolbarColor: Colors.white,
            toolbarWidgetColor: bumbi,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _cropped = croppedFile;
    });
  }

  File _image;
  File _cropped;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    return EasyLocalizationProvider(
        data: data,
        child: WillPopScope(
          onWillPop: () {
           
              Navigator.of(context).pop();
          
            return Future.value(false);
          },
          child: SafeArea(
            child: Scaffold(
              key: scaffold,
              body: Stack(
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: bloc.size().width,
                      height: bloc.size().height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25))),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SmallIconButton(
                                            onPressed: () {
                                              widget.provider
                                                  ? Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AtelierProviderCenter(
                                                                    screen: 1,
                                                                  )))
                                                  : Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AtelierCenter(
                                                                    screen: 2,
                                                                  )));
                                            },
                                            padding: EdgeInsets.all(0),
                                            icon: Icons.arrow_back_ios,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .tr("profile.edit"),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  height: 155,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 5),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  // key: imageKey,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 20, 0, 10),
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          bloc.size().width / 3,
                                                      maxHeight:
                                                          bloc.size().height /
                                                              4.2),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(15)),
                                                      child: _cropped != null
                                                          ? Image.file(_cropped)
                                                          :
                     FadeInImage(
                                    placeholder:AssetImage('assets/images/placeholder.gif'),

                                                              image:NetworkImage( bloc
                                                                  .currentUser()
                                                                  .image),
                                                            ))),
                                              SizedBox(
                                                width: 15,
                                              )
                                            ],
                                          ),
                                          BumbiIconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              scaffold.currentState
                                                  .showSnackBar(SnackBar(
                                                      content: Container(
                                                alignment: Alignment.center,
                                                height: 80,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        BumbiIconButton(
                                                          iconData: Icons
                                                              .linked_camera,
                                                          onPressed: () async {
                                                            await getImage(
                                                                ImageSource
                                                                    .camera);
                                                            await retrieveLostData();
                                                            if (_image != null)
                                                              cropImage(_image);
                                                          },
                                                        ),
                                                        Text(AppLocalizations
                                                                .of(context)
                                                            .tr("profile.camera")),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: VerticalDivider(
                                                        color: hint,
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        BumbiIconButton(
                                                          iconData: Icons.image,
                                                          onPressed: () async {
                                                            await getImage(
                                                                ImageSource
                                                                    .gallery);
                                                            await retrieveLostData();
                                                            if (_image != null)
                                                              cropImage(_image);
                                                          },
                                                        ),
                                                        Text(AppLocalizations
                                                                .of(context)
                                                            .tr("profile.gallery")),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )));
                                            },
                                            iconData: Icons.linked_camera,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // named field
                            StreamBuilder<String>(
                              stream: validate ? bloc.nameStream : null,
                              builder: (context, s) => AtelierTextField(
                                controller: name,
                                value: empty ? bloc.name() : "",
                                lang: Localizations.localeOf(context)
                                    .languageCode
                                    .toString(),
                                error: s.hasError
                                    ? AppLocalizations.of(context)
                                        .tr("validators.nameValidate")
                                    : null,
                                unFocus: () {
                                  setState(() {
                                    emailNode.unfocus();
                                    mobileNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(emailNode);
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
                                controller: email,
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

                                    mobileNode.unfocus();
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
                                controller: mobile,
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

                                    emailNode.unfocus();
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

                            ///
                            widget.provider
                                ? StreamBuilder<String>(
                                    stream: validate ? bloc.siteStream : null,
                                    builder: (context, s) => AtelierTextField(
                                      controller: site,
                                      value: "",
                                      lang: Localizations.localeOf(context)
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
                                  )
                                : SizedBox(),
                            widget.provider
                                ? Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                    
////////////////////////////////////////////////////////////////////////////////////
///
///
///
///
                                      StreamBuilder(
                                          stream: bloc.noteStream,
                                          builder:
                                              (context, snapshot) => Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        AnimatedDefaultTextStyle(
                                                          duration: mill0Second,
                                                          style: TextStyle(
                                                              color: snapshot
                                                                          .error !=
                                                                      null
                                                                  ? Colors.red
                                                                  : hint,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: noteNode
                                                                          .hasPrimaryFocus ||
                                                                      snapshot.error !=
                                                                          null
                                                                  ? 15
                                                                  : 0),
                                                          child: Text(
                                                           AppLocalizations.of(context)
                                                .tr("signUp.note"),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: snapshot.error !=
                                                                              null ||
                                                                          (empty ? bloc.email() : "") ==
                                                                              null
                                                                      ? Border.all(
                                                                          color: Colors
                                                                              .red)
                                                                      : null,
                                                                  boxShadow:
                                                                      noteNode
                                                                              .hasPrimaryFocus
                                                                          ? [
                                                                              BoxShadow(color: hint.withOpacity(.3), spreadRadius: .5, blurRadius: 0, offset: Offset(0, 2)),
                                                                              BoxShadow(color: Colors.transparent, spreadRadius: 0, blurRadius: 1, offset: Offset(0, 1))
                                                                            ]
                                                                          : null,
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: TextFormField(
                                                            maxLines: 5,
                                                            controller: note,
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      noteNode);
                                                              nameNode
                                                                  .unfocus();
                                                              siteNode
                                                                  .unfocus();
                                                              mobileNode
                                                                  .unfocus();
                                                              emailNode
                                                                  .unfocus();

                                                              setState(() {});
                                                            },
                                                            cursorColor:
                                                                snapshot.error !=
                                                                        null
                                                                    ? Colors.red
                                                                    : bumbi,
                                                            onChanged: bloc
                                                                .onNoteChange,
                                                            focusNode: noteNode,
                                                            style: TextStyle(
                                                                color:
                                                                    blackAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 15),
                                                            decoration:
                                                                InputDecoration(
                                                              hintStyle: TextStyle(
                                                                  color: snapshot
                                                                              .error !=
                                                                          null
                                                                      ? Colors
                                                                          .red
                                                                      : hint,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: noteNode
                                                                              .hasPrimaryFocus ||
                                                                          snapshot.error ==
                                                                              null
                                                                      ? 15
                                                                      : 0),
                                                              hintText: snapshot
                                                                              .error !=
                                                                          null ||
                                                                      noteNode
                                                                          .hasPrimaryFocus
                                                                  ? ""
                                                                  : AppLocalizations.of(context)
                                                .tr("signUp.note"),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                          ),
                                                        )
                                                      ])),

                                      ///
                                      ///
                                      ///
                                      ///
                                      ////////////////////////////////////////////
                                    ],
                                  )
                                : SizedBox(),
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: bloc.size().width,
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  StreamBuilder(
                                    stream: bloc.combineEditProfileFields,
                                    builder: (context, s) => BumbiButton(
                                      colored: true,
                                      text: AppLocalizations.of(context).tr(
                                        "profile.save",
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          validate=true;
                                        });
                                        if(bloc.name() == null ||
                                              bloc.mobile() == null ||
                                              bloc.email() == null||bloc.name().isEmpty ||
                                              bloc.mobile().isEmpty ||
                                              bloc.email().isEmpty)
                                          showSnackBarContent(Text("من فضلك أدخل البيانات الأساسية بشكل صحيح"), scaffold);
                                      else{    
                                        String oldEmail=bloc.currentUser().email;
                                        if (widget.provider) {
                                          if (_cropped != null)
                                            await bloc
                                                .onHouseImageChange(_cropped);
                                          setState(() {
                                            validate = true;
                                          });
                                          if (bloc.name() == null ||
                                              bloc.mobile() == null ||
                                              bloc.email() == null ||
                                              s.hasError)
                                            setState(() {
                                              empty = true;
                                            });
                                          else {
                                            setState(() {
                                              loading = true;
                                            });
                                            await updateProviderProfile();
                                            setState(() {
                                              loading = false;
                                            });
                                            if (bloc.errorUser().msg != null) {
                                              if (bloc.errorUser().status ==
                                                  401) {
                                                await clearUserData();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Login()));
                                              } else
                                                scaffold.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      bloc.errorUser().msg),
                                                ));
                                            } else
                                              Navigator.of(context).pop();
                                          }
                                        }

                                        //////user
                                        else {
                                          if (_cropped != null)
                                            await bloc
                                                .onUserImageChange(_cropped);
                                          setState(() {
                                            validate = true;
                                          });
                                          if (bloc.name() == null ||
                                              bloc.mobile() == null ||
                                              bloc.email() == null ||
                                              s.hasError)
                                            setState(() {
                                              empty = true;
                                            });
                                          //لو فاضيين
                                          else {
                                            setState(() {
                                              loading = true;
                                            });
                                            await updateUserProfile();
                                            setState(() {
                                              loading = false;
                                            });
                                            if (bloc.errorUser().msg != null) {
                                              if (bloc.errorUser().status ==
                                                  401) {
                                                await clearUserData();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Login()));
                                              } else
                                                scaffold.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      bloc.errorUser().msg),
                                                ));
                                            } else
                                              Navigator.of(context).pop();
                                          }
                                        }
                                        if(int.tryParse(bloc.currentUser().activation_code)!=null&&oldEmail!=bloc.currentUser().email)
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Confirm(from: "signUp",)));
                                        await removeSharedOfKey("forget");
                                      }},
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  BumbiButton(
                                    colored: false,
                                    text: AppLocalizations.of(context).tr(
                                      "profile.cancel",
                                    ),
                                    onPressed: () {
                                     Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              highlightColor: bumbiAccent.withOpacity(.5),
                              splashColor: Colors.red[50],
                              onPressed: () {
                                widget.provider
                                    ? Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePassword(
                                                  from: "provider",
                                                )))
                                    : Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePassword(
                                                  from: "user",
                                                )));
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .tr("profile.changePassword"),
                                style: TextStyle(color: hint),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  loading ? LoadingFullScreen() : SizedBox()
                ],
              ),
            ),
          ),
        ));
  }
}
