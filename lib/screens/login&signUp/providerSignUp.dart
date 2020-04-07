import 'dart:io';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/shared_preferences_helper.dart';
import 'package:atelier/models/userModel.dart';
import 'package:atelier/screens/login&signUp/confirm.dart';
import 'package:atelier/screens/login&signUp/login.dart';
import 'package:atelier/screens/login&signUp/signUp.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProviderSignUp extends StatefulWidget {
  @override
  _ProviderSignUpState createState() => _ProviderSignUpState();
}

class _ProviderSignUpState extends State<ProviderSignUp> {
  bool imageUplading = false;
  final noteNode = new FocusNode();
  bool agreed = false;
  bool loading = false;
  bool rulesError = false;
  bool validate = false;
  Future getImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

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
            activeControlsWidgetColor: Colors.deepOrange,
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _cropped = croppedFile;
    });
    bloc.onHouseImageChange(_cropped);
  }

  File _image;
  File _cropped;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    setState(() {});

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
                MaterialPageRoute(builder: (context) => SignUp()));
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
                        // Positioned(
                        //   bottom: 0,
                        //   left: localCode == "ar" ? 0 : null,
                        //   right: localCode == "ar" ? null : 0,
                        //   child: Opacity(
                        //       opacity: 0.2,
                        //       child: Container(
                        //           alignment: localCode == "ar"
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
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  icon: Icons.arrow_back_ios,
                                ),
                                Container(
                                  width: bloc.size().width,
                                  margin: EdgeInsets.only(
                                      top: bloc.size().height / 10),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("signUp.complete"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800),
                                      ),

                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("signUp.houseImage"),
                                        style: TextStyle(
                                            color: hint,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // image field
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: bloc.size().width -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .horizontal -
                                                          35,
                                                      maxHeight: 200),
                                                  alignment: _image != null
                                                      ? (localCode == "en"
                                                          ? Alignment.bottomLeft
                                                          : Alignment
                                                              .centerRight)
                                                      : Alignment.center,
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                      border: (validate &&
                                                              _cropped == null)
                                                          ? Border.all(
                                                              color: Colors.red)
                                                          : null,
                                                      color: _image != null
                                                          ? null
                                                          : Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(15))),
                                                  child: _image == null
                                                      ? InkWell(
                                                          highlightColor: bumbiAccent
                                                              .withOpacity(.9),
                                                          splashColor:
                                                              Colors.red[500],
                                                          borderRadius:
                                                              BorderRadius.all(Radius.circular(45)),
                                                          onTap: () {
                                                            scaffold
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content:
                                                                  Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          80,
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: <
                                                                            Widget>[
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              BumbiIconButton(
                                                                                iconData: Icons.linked_camera,
                                                                                onPressed: () async {
                                                                                  File image = await getImage(ImageSource.camera);
                                                                                  await retrieveLostData();
                                                                                  if (_image != null) cropImage(_image);
                                                                                },
                                                                              ),
                                                                              Text(AppLocalizations.of(context).tr("profile.camera")),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                VerticalDivider(
                                                                              color: hint,
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              BumbiIconButton(
                                                                                iconData: Icons.image,
                                                                                onPressed: () async {
                                                                                  await getImage(ImageSource.gallery);
                                                                                  await retrieveLostData();
                                                                                  if (_image != null) cropImage(_image);
                                                                                },
                                                                              ),
                                                                              Text(AppLocalizations.of(context).tr("profile.gallery")),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )),
                                                            ));
                                                          },
                                                          child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              child: Icon(
                                                                Icons
                                                                    .add_photo_alternate,
                                                                size: 35,
                                                                color: validate
                                                                    ? Colors.red
                                                                    : hint,
                                                              )))
                                                      : Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                          200,
                                                                      maxHeight:
                                                                          200),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                                child: _cropped !=
                                                                        null
                                                                    ? Image
                                                                        .file(
                                                                        _cropped,
                                                                      )
                                                                    : _image !=
                                                                            null
                                                                        ? Image
                                                                            .file(
                                                                            _image,
                                                                          )
                                                                        : SizedBox(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                InkWell(
                                                                    highlightColor:
                                                                        bumbiAccent.withOpacity(
                                                                            .9),
                                                                    splashColor:
                                                                        Colors.red[
                                                                            500],
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            5)),
                                                                    onTap: () {
                                                                      if (_image !=
                                                                          null)
                                                                        cropImage(
                                                                            _image);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 35,
                                                                      height:
                                                                          35,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .crop,
                                                                        color: bumbi
                                                                            .withOpacity(.7),
                                                                      ),
                                                                    )),
                                                                InkWell(
                                                                    highlightColor:
                                                                        bumbiAccent.withOpacity(
                                                                            .9),
                                                                    splashColor:
                                                                        Colors.red[
                                                                            500],
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5)),
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        _image =
                                                                            null;
                                                                        _cropped =
                                                                            null;
                                                                        bloc.onHouseImageChange(
                                                                            null);
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                        width: 35,
                                                                        height: 35,
                                                                        child: Icon(
                                                                          Icons
                                                                              .delete_sweep,
                                                                          color:
                                                                              bumbi,
                                                                        )))
                                                              ],
                                                            ),
                                                          ],
                                                        ))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .tr("signUp.note"),
                                        style: TextStyle(
                                            color: hint,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // notes
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              height: 120,
                                              child: DraggableScrollbar.rrect(
                                                backgroundColor: hint,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                                alwaysVisibleScrollThumb: false,
                                                controller: controller,
                                                heightScrollThumb: 40,
                                                child: ListView(
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    controller: controller,
                                                    children: <Widget>[
                                                      TextFormField(
                                                        cursorColor: bumbi,
                                                        maxLines: 9,
                                                        focusNode: noteNode,
                                                        onChanged:
                                                            bloc.onNoteChange,
                                                        decoration: InputDecoration(
                                                            border: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none)),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ]),
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: hint
                                                            .withOpacity(.3),
                                                        spreadRadius: .5,
                                                        blurRadius: 0,
                                                        offset: Offset(0, 2)),
                                                    BoxShadow(
                                                        color:
                                                            Colors.transparent,
                                                        spreadRadius: 0,
                                                        blurRadius: 1,
                                                        offset: Offset(0, 1))
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                            ),
                                          ),
                                        ],
                                      ),

                                      //////
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
                                              child: SizedBox(),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            StreamBuilder<Object>(
                                                stream: null,
                                                builder: (context, snapshot) {
                                                  return BumbiButton(
                                                    colored: true,
                                                    text: AppLocalizations.of(
                                                            context)
                                                        .tr(
                                                      "confirm.confirm",
                                                    ),
                                                    onPressed: () async {
                                                      if (bloc.houseImage() ==
                                                          null) {
                                                        scaffold.currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .tr("validators.nullImage")),
                                                        ));
                                                        setState(() {
                                                          validate = true;
                                                        });
                                                      } else {
                                                        if (bloc.note() == null)
                                                          bloc.onNoteChange("");

                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        await signUpProvider();
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        if (bloc
                                                                .errorUser()
                                                                .msg ==
                                                            null) {
                                                       await   addSharedString(
                                                              "pass",
                                                              bloc.password());

                                                          //لما الدار تسجل
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Confirm(
                                                                            from:
                                                                                "signUp",
                                                                          )));
                                                          print(bloc
                                                              .currentUser()
                                                              .activation_code);
                                                        } else {
                                                          if (bloc
                                                                  .errorUser()
                                                                  .status ==
                                                              401) {
                                                            await clearUserData();
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Login()));
                                                          } else
                                                            scaffold
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(bloc
                                                                  .errorUser()
                                                                  .msg),
                                                            ));
                                                        }
                                                      }
                                                    },
                                                  );
                                                }),
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
