import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDress extends StatefulWidget {
  Product product;
  AddDress({this.product});
  @override
  _AddDressState createState() => _AddDressState();
}

class _AddDressState extends State<AddDress> {
  FocusNode dressNameNode = FocusNode();
  FocusNode dressPriceNode = FocusNode();
  FocusNode dressMobileNode = FocusNode();
  FocusNode dressTypeNode = FocusNode();
  FocusNode dressOreNode = FocusNode();
  FocusNode dressColorNode = FocusNode();
  FocusNode dressSizeNode = FocusNode();
  FocusNode dressPlaceNode = FocusNode();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController ore = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController place = TextEditingController();

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  File _image;
  File _cropped;
  Map<int, String> oldImages = {};
  ScrollController imagesController = ScrollController();
  bool validate = false;
  bool empty = false;
  bool imageNull = false;
  bool loading = false;
  Map<int, File> dressImagesFiles = {};
  Map<int, File> unCroppedDressImagesFiles = {};
  Map<int, Widget> dressImages = {};
  List<Widget> dressImagesWidgets = [];
  Container addImageContainer;
  Future getImage(ImageSource source) async {
    var p =await Permission.storage.request();
var p2 =await Permission.camera.request();
var p1 =await Permission.mediaLibrary.request();
var p4 =await Permission.photos.request();
var p3 =await Permission.storage.request();

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
      addImageContainer = addImage();
    });
  }

///////////////////////// علشان أعرض الصورة في شكل الديزاين
  showImageWidget({bool assets}) {
    setState(() {
      imageNull = false;
      int pos = dressImages.isEmpty ? 0 : dressImages.keys.last + 1;
      if (assets == null) {
        dressImagesFiles[pos] = (_cropped);
        bloc.onDressImagesChange(dressImagesFiles.values.toList());
      }
      dressImages[pos] = Container(
          width: 165,
          height: 190,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Stack(
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: assets != null
                    ? FadeInImage(
                        placeholder:
                            AssetImage('assets/images/placeholder.gif'),
                        image: NetworkImage(
                          oldImages[pos],
                        ),
                        fit: BoxFit.fill,
                        width: 155,
                        height: 180,
                      )
                    : Image.file(
                        dressImagesFiles[pos],
                        fit: BoxFit.fill,
                        width: 155,
                        height: 180,
                      ),
              ),
              assets != null
                  ? SizedBox()
                  : Container(
                      width: 165,
                      height: 190,
                      decoration: BoxDecoration(
                          color: blackAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
              assets != null
                  ? SizedBox()
                  : InkWell(
                      onTap: () async {
                        await cropImage(unCroppedDressImagesFiles[pos]);

                        setState(() {
                          dressImagesFiles[pos] = _cropped;
                          bloc.onDressImagesChange(
                              dressImagesFiles.values.toList());
                        });
                        await refreshImageWidget(pos);
                      },
                      child: Icon(
                        Icons.crop,
                        size: 35,
                        color: bumbi,
                      ),
                    ),
              Positioned(
                top: -20,
                left: -20,
                child: SmallIconButton(
                  color: bumbi,
                  icon: Icons.close,
                  onPressed: () {
                    setState(() {
                      dressImages.remove(pos);
                      if (assets == null) {
                        dressImagesFiles.remove(pos);
                        unCroppedDressImagesFiles.remove(pos);
                        bloc.onDressImagesChange(
                            dressImagesFiles.values.toList());
                      } else
                        oldImages.remove(pos);
                    });
                  },
                ),
              )
            ],
          ));
    });
  }

///////////////////////////////////////////////////////////////
  /////////////////////// علشان احدث شكل الصورة بعدما اتقصت
  refreshImageWidget(int pos) {
    if (dressImagesFiles[pos] != null)
      setState(() {
        dressImages[pos] = Container(
            width: 165,
            height: 190,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Stack(
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.file(
                    dressImagesFiles[pos],
                    fit: BoxFit.fill,
                    width: 155,
                    height: 180,
                  ),
                ),
                Container(
                  width: 165,
                  height: 190,
                  decoration: BoxDecoration(
                      color: blackAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                InkWell(
                  onTap: () async {
                    await cropImage(unCroppedDressImagesFiles[pos]);

                    setState(() {
                      dressImagesFiles[pos] = _cropped;
                      bloc.onDressImagesChange(
                          dressImagesFiles.values.toList());
                    });
                    await refreshImageWidget(pos);
                  },
                  child: Icon(
                    Icons.crop,
                    size: 35,
                    color: bumbi,
                  ),
                ),
                Positioned(
                  top: -20,
                  left: -20,
                  child: SmallIconButton(
                    color: bumbi,
                    icon: Icons.close,
                    onPressed: () {
                      setState(() {
                        dressImages.remove(pos);
                        dressImagesFiles.remove(pos);
                        unCroppedDressImagesFiles.remove(pos);
                        bloc.onDressImagesChange(
                            dressImagesFiles.values.toList());
                      });
                    },
                  ),
                )
              ],
            ));
      });
  }

//////////////////////////////////////////////////////////
///////////////////////////// علشان القط الصورة واعرضها
  Future addNewDressImage() async {
    scaffold.currentState.showSnackBar(SnackBar(
        content: Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ///////////////////// أخذ الصورة من الكاميرا
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BumbiIconButton(
                iconData: Icons.linked_camera,
                onPressed: () async {
                  File image = await getImage(ImageSource.camera);
                  if (_image != null) {
                    await retrieveLostData();
                    int pos =
                        dressImages.isEmpty ? 0 : dressImages.keys.last + 1;
                    setState(() {
                      unCroppedDressImagesFiles[pos] = _image;
                    });
                    if (_image != null) await cropImage(_image);
if(_cropped!=null)
                    await showImageWidget();
                    _image = null;
                  }
                },
              ),
              Text(AppLocalizations.of(context).tr("profile.camera")),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: VerticalDivider(
              color: hint,
            ),
          ),

          //////////////////////// اخذ الصورة من المعرض
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              BumbiIconButton(
                iconData: Icons.image,
                onPressed: () async {
                  await getImage(ImageSource.gallery);
                  if (_image != null) {
                    await retrieveLostData();
                    int pos =
                        dressImages.isEmpty ? 0 : dressImages.keys.last + 1;
                    setState(() {
                      unCroppedDressImagesFiles[pos] = _image;
                    });

                    if (_image != null) await cropImage(_image);
                    if(_cropped!=null)
                    await showImageWidget();
                    _image = null;
                  }
                },
              ),
              Text(AppLocalizations.of(context).tr("profile.gallery")),
            ],
          )
        ],
      ),
    )));
  }

//////////////////////////////////////////////////////////////////////////////

  mergeDresswithAddButton() {
    setState(() {
      if (dressImages.length == 0)
        dressImagesWidgets = [addImageContainer];
      else if (dressImages.length == 4) {
        dressImagesWidgets = dressImages.values.toList();
      } else {
        dressImagesWidgets = dressImages.values.toList()..add(addImage());
      }
    });
  }

  @override
  void initState() {
    bloc.onDressImagesChange(null);
    if (widget.product != null) {
      name.text = widget.product.title;
      price.text = widget.product.price.toString();
      type.text=widget.product.dressNote.type;
      ore.text=widget.product.dressNote.ore;
      color.text=widget.product.dressNote.color;
      place.text=widget.product.dressNote.place;
      size.text=widget.product.dressNote.size;

      mobile.text = widget.product.mobile;
      // des.text = widget.product.note;
    }
    if (widget.product != null) {
      setState(() {
        for (int i = 0; i < widget.product.images.length; i++) {
          oldImages[i] = widget.product.images[i];
          // for (int i = 0; i < oldImages.length; i++)
          showImageWidget(assets: true);
        }
      });
      bloc.onDressNameChange(widget.product.title);
      bloc.ondressPlaceChange(widget.product.dressNote.place);
            bloc.ondressTypeChange(widget.product.dressNote.type);
      bloc.ondressSizeChange(widget.product.dressNote.size);
      bloc.ondressOreChange(widget.product.dressNote.ore);
            bloc.ondressColorChange(widget.product.dressNote.color);
      bloc.onMobileChange(widget.product.mobile); /////////////////////////
      bloc.onDressPriceChange(widget.product.price.toString());
      bloc.onDressDescripChange(widget.product.note);
    }
    addImageContainer = addImage();
    if (widget.product != null) {
      if (oldImages.length == 4)
        dressImagesWidgets = dressImages.values.toList();
      else
        dressImagesWidgets = dressImages.values.toList()
          ..add(addImageContainer);
    } else
      dressImagesWidgets = [addImageContainer];

    super.initState();
  }

  Container addImage({bool e}) {
    return Container(
        height: 180,
        width: 155,
        decoration: BoxDecoration(
            color: Colors.white,
            border: e != null ? Border.all(color: Colors.red) : null,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () async {
            dressOreNode.unfocus();
            dressTypeNode.unfocus();
            dressSizeNode.unfocus();
            dressPlaceNode.unfocus();
            dressColorNode.unfocus();
            dressMobileNode.unfocus();
            dressPriceNode.unfocus();
            dressNameNode.unfocus();
            await addNewDressImage();
          },
          child: Icon(
            Icons.add_a_photo,
            color: e != null ? Colors.red : hint,
            size: 35,
          ),
        ));
  }

  bool nameError = false;
  bool priceError = false;
  bool desError = false;
  @override
  Widget build(BuildContext context) {
    String nameValidate = AppLocalizations.of(context).tr("validators.name");
    String priceValidate = AppLocalizations.of(context).tr("validators.price");
    String descripValidate = AppLocalizations.of(context).tr("validators.des");
    String imageValidate = AppLocalizations.of(context).tr("validators.image");
    String allValidate = AppLocalizations.of(context).tr("validators.empty");
    mergeDresswithAddButton();

    var data = EasyLocalizationProvider.of(context).data;
    String localCode = Localizations.localeOf(context).languageCode.toString();

    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();

            return Future.value(false);
          },
          child: Scaffold(
              key: scaffold,
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  dressOreNode.unfocus();
                  dressTypeNode.unfocus();
                  dressSizeNode.unfocus();
                  dressPlaceNode.unfocus();
                  dressColorNode.unfocus();
                  dressNameNode.unfocus();
                  dressPriceNode.unfocus();
                  dressMobileNode.unfocus();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
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
                      Container(
                        height: bloc.size().height,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SmallIconButton(
                                      padding: EdgeInsets.only(
                                          top: 20,
                                          left: bloc.lang() == "ar" ? 10 : 0,
                                          right: bloc.lang() == "ar" ? 0 : 10,
                                          bottom: 40),
                                      icon: Icons.arrow_back_ios,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 22),
                                      child: Text(
                                        AppLocalizations.of(context).tr(
                                            widget.product != null
                                                ? "profile.editDress"
                                                : "profile.addDress"),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              StreamBuilder(
                                  stream:
                                      validate ? bloc.dressNameStream : null,
                                  builder: (context, snapshot) =>
                                      AtelierTextField(
                                        value: empty ? bloc.dressName() : "",
                                        focusNode: dressNameNode,
                                        controller: name,
                                        unFocus: () {
                                          dressPriceNode.unfocus();
                                          dressMobileNode.unfocus();
dressOreNode.unfocus();
            dressTypeNode.unfocus();
            dressSizeNode.unfocus();
            dressPlaceNode.unfocus();
            dressColorNode.unfocus();                                        },
                                        password: false,
                                        onChanged: (v) {
                                          bloc.onDressNameChange(v);
                                          if (v.isEmpty)
                                            setState(() {
                                              nameError = true;
                                            });
                                          else
                                            setState(() {
                                              nameError = false;
                                            });
                                        },
                                        label: AppLocalizations.of(context)
                                            .tr("profile.dressName"),
                                        error: snapshot.hasError || nameError
                                            ? nameValidate
                                            : null,
                                      )),
                                         
                              //////////////// رقم التواصل
                              bloc.currentUser().type == "user"
                                  ? StreamBuilder<String>(
                                      stream:
                                          validate ? bloc.mobileStream : null,
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
                                            dressNameNode.unfocus();
dressOreNode.unfocus();
            dressTypeNode.unfocus();
            dressSizeNode.unfocus();
            dressPlaceNode.unfocus();
            dressColorNode.unfocus();                                            dressPriceNode.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(dressMobileNode);
                                          });
                                        },
                                        password: false,
                                        focusNode: dressMobileNode,
                                        label: AppLocalizations.of(context)
                                            .tr("profile.mob"),
                                        onChanged: bloc.onMobileChange,
                                      ),
                                    )
                                  : SizedBox(),

                              /////////////////////// descrip
                              StreamBuilder(
                                  //// type
                                  stream:
                                      validate ? bloc.dressTypeStream : null,
                                  builder: (context, snapshot) =>
                                      AtelierTextField(
                                        controller: type,
                                        value:
                                            bloc.dressType()!=null ? bloc.dressType() : "",
                                        focusNode: dressTypeNode,
                                        unFocus: () {
                                          dressNameNode.unfocus();
                                          dressMobileNode.unfocus();
dressOreNode.unfocus();
                                          dressPriceNode.unfocus();

            dressSizeNode.unfocus();
            dressPlaceNode.unfocus();
            dressColorNode.unfocus();                                        },
                                        label: AppLocalizations.of(context)
                                            .tr("profile.dressType"),
                                        onChanged: (v) {
                                          bloc.ondressTypeChange(v);
                                          
                                        },
                                        password: false,
                                      )),
                              StreamBuilder(
                                //ore
                                  stream:
                                      validate ? bloc.dressOreStream : null,
                                  builder: (context, snapshot) =>
                                      AtelierTextField(
                                        controller: ore,
                                        value:
                                            bloc.dressOre()!=null ? bloc.dressOre() : "",
                                        focusNode: dressOreNode,
                                        unFocus: () {
                                          dressNameNode.unfocus();
                                          dressMobileNode.unfocus();
                                          dressPriceNode.unfocus();
            dressTypeNode.unfocus();
            dressSizeNode.unfocus();
            dressPlaceNode.unfocus();
            dressColorNode.unfocus();                                        },
                                        label: AppLocalizations.of(context)
                                            .tr("profile.dressOre"),
                                        onChanged: (v) {
                                          bloc.ondressOreChange(v);
                                        },
                                        password: false,
                                      )),
                              StreamBuilder(
                                //color
                                  stream:
                                      validate ? bloc.dressColorStream : null,
                                  builder: (context, snapshot) =>
                                      AtelierTextField(
                                        controller: color,
                                        value:
                                            bloc.dressColor()!=null ? bloc.dressColor() : "",
                                        focusNode: dressColorNode,
                                        unFocus: () {
                                          dressNameNode.unfocus();
                                          dressMobileNode.unfocus();
dressOreNode.unfocus();
            dressTypeNode.unfocus();
            dressSizeNode.unfocus();
            dressPlaceNode.unfocus();
            dressPriceNode.unfocus();                                        },
                                        label: AppLocalizations.of(context)
                                            .tr("profile.dressColor"),
                                        onChanged: (v) {
                                          bloc.ondressColorChange(v);
                                        },
                                        password: false,
                                      )),
                              StreamBuilder(
                                //size
                                  stream:
                                      validate ? bloc.dressSizeStream : null,
                                  builder: (context, snapshot) =>
                                      AtelierTextField(
                                        controller: size,
                                        value:
                                            bloc.dressSize()!=null ? bloc.dressSize() : "",
                                        focusNode: dressSizeNode,
                                        unFocus: () {
                                          dressNameNode.unfocus();
                                          dressMobileNode.unfocus();
dressOreNode.unfocus();
            dressTypeNode.unfocus();
            dressPriceNode.unfocus();
            dressPlaceNode.unfocus();
            dressColorNode.unfocus();                                        },
                                        label: AppLocalizations.of(context)
                                            .tr("profile.dressSize"),
                                        onChanged: (v) {
                                          bloc.ondressSizeChange(v);
                                        },
                                        password: false,
                                      )),
                              StreamBuilder(
                                //place
                                  stream:
                                      validate ? bloc.dressPlaceStream : null,
                                  builder: (context, snapshot) =>
                                      AtelierTextField(
                                        controller: place,
                                        value:
                                            bloc.dressPlace()!=null ? bloc.dressPlace() : "",
                                        focusNode: dressPlaceNode,
                                        unFocus: () {
                                          dressNameNode.unfocus();
                                          dressMobileNode.unfocus();
dressOreNode.unfocus();
            dressTypeNode.unfocus();
            dressSizeNode.unfocus();
            dressPriceNode.unfocus();
            dressColorNode.unfocus();                                        },
                                        label: AppLocalizations.of(context)
                                            .tr("profile.dressPlace"),
                                        onChanged: (v) {
                                          bloc.ondressPlaceChange(v);
                                        },
                                        password: false,
                                      )),
                              StreamBuilder(
                                  stream:
                                      validate ? bloc.dressPriceStream : null,
                                  builder: (context, snapshot) =>
                                      AtelierTextField(
                                        controller: price,
                                        type: TextInputType.numberWithOptions(),
                                        value:
                                            empty ? bloc.dressPrice() : "kkk",
                                        focusNode: dressPriceNode,
                                        unFocus: () {
                                          dressNameNode.unfocus();
                                          dressMobileNode.unfocus();
dressOreNode.unfocus();
            dressTypeNode.unfocus();
            dressSizeNode.unfocus();
            dressPlaceNode.unfocus();
            dressColorNode.unfocus();                                        },
                                        label: AppLocalizations.of(context)
                                            .tr("profile.dressPrice"),
                                        onChanged: (v) {
                                          bloc.onDressPriceChange(v);
                                          if (double.tryParse(v) != null)
                                            setState(() {
                                              if (double.parse(v) == 0.0)
                                                priceError = true;
                                              else
                                                priceError = false;
                                            });
                                          else
                                            setState(() {
                                              priceError = true;
                                            });
                                        },
                                        error: snapshot.hasError || priceError
                                            ? priceValidate
                                            : null,
                                        password: false,
                                      )),
                              /////////////////////////////// end of descrip
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("myProduct.dressImages"),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: imageNull ? Colors.red : hint,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 10, top: 10),
                                  width: 330,
                                  height: dressImagesWidgets.length > 2
                                      ? bloc.size().width + 20
                                      : bloc.size().width / 2,
                                  child: GridView.builder(
                                    padding: EdgeInsets.all(10),
                                    physics: BouncingScrollPhysics(),
                                    itemCount: dressImagesWidgets.length,
                                    itemBuilder: (context, index) {
                                      return dressImagesWidgets[index];
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: .86),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  width: bloc.size().width,
                                  height: 40,
                                  child: widget.product != null
                                      ? Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            StreamBuilder(
                                              stream: bloc.currentUser().type ==
                                                      "user"
                                                  ? bloc
                                                      .combineDressUserAddFields
                                                  : bloc.combineDressAddFields,
                                              builder: (context, s) =>
                                                  BumbiButton(
                                                colored: true,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr("profile.save"),
                                                onPressed: () async {
                                                  if (dressImages.length == 0)
                                                    setState(() {
                                                      addImageContainer =
                                                          addImage(e: true);
                                                      dressImagesWidgets = [
                                                        addImageContainer
                                                      ];
                                                    });
                                                  setState(() {
                                                    empty = true;
                                                    validate = true;
                                                  });
                                                  if (desError ||
                                                      s.hasError ||
                                                      nameError ||
                                                      priceError) {
                                                    showSnackBarContent(
                                                        Text(allValidate),
                                                        scaffold);
                                                  } else if (bloc
                                                              .currentUser()
                                                              .type ==
                                                          "user" &&
                                                      (bloc.mobile().isEmpty ||
                                                          bloc.mobile() ==
                                                              null))
                                                    showSnackBarContent(
                                                        Text(allValidate),
                                                        scaffold);
                                                  else if (dressImagesWidgets
                                                          .length <
                                                      2) {
                                                    {
                                                      setState(() {
                                                        imageNull = true;
                                                        showSnackBarContent(
                                                            Text(imageValidate),
                                                            scaffold);
                                                      });
                                                    }
                                                  } else if (!imageNull &&
                                                      !nameError &&
                                                      !desError &&
                                                      !priceError &&
                                                      !s.hasError) {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    await editDress(
                                                        widget.product.id,
                                                        oldImages.values
                                                            .toList(),
                                                            context);
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    Navigator.of(context).pop(
                                                        Navigator.of(context)
                                                            .pop());
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            BumbiButton(
                                              colored: false,
                                              text: AppLocalizations.of(context)
                                                  .tr("profile.cancel"),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        )
                                      : Row(
                                          children: <Widget>[
                                            StreamBuilder(
                                              stream: bloc.currentUser().type ==
                                                      "user"
                                                  ? bloc
                                                      .combineDressUserAddFields
                                                  : bloc.combineDressAddFields,
                                              builder: (context, s) =>
                                                  BumbiButton(
                                                colored: true,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .tr("profile.add"),
                                                onPressed: () async {
                                                  if (dressImages.length == 0)
                                                    setState(() {
                                                      addImageContainer =
                                                          addImage(e: true);
                                                      dressImagesWidgets = [
                                                        addImageContainer
                                                      ];
                                                    });
                                                  setState(() {
                                                    empty = true;
                                                    validate = true;
                                                  });
                                                  if (dressImagesWidgets
                                                          .length <
                                                      2)
                                                    setState(() {
                                                      imageNull = true;
                                                    });
                                                  if (desError ||
                                                      s.hasError ||
                                                      nameError ||
                                                      priceError) {
                                                    showSnackBarContent(
                                                        Text(allValidate),
                                                        scaffold);
                                                  } else if (bloc
                                                              .currentUser()
                                                              .type ==
                                                          "user" &&
                                                      (bloc.mobile().isEmpty ||
                                                          bloc.mobile() ==
                                                              null))
                                                    showSnackBarContent(
                                                        Text(allValidate),
                                                        scaffold);
                                                  else if (imageNull) {
                                                    setState(() {
                                                      showSnackBarContent(
                                                          Text(imageValidate),
                                                          scaffold);
                                                    });
                                                  } else if (!imageNull &&
                                                      !nameError &&
                                                      !desError &&
                                                      !priceError &&
                                                      !s.hasError) {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    await sendDress(context);

                                                    print(bloc.doneMSG());
                                                    setState(() {
                                                      loading = false;
                                                    });
if(bloc.doneMSG()!=null)
showSnackBarContent(Text(bloc.doneMSG()), scaffold);
else
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        )),
                            ],
                          ),
                        ),
                      ),
                      loading ? LoadingFullScreen() : SizedBox()
                    ],
                  ),
                ),
              ))),
    );
  }
}
/*
 
                              StreamBuilder(
                                  stream:
                                      validate ? bloc.dressDescripStream : null,
                                  builder: (context, snapshot) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            AnimatedDefaultTextStyle(
                                              duration: mill0Second,
                                              style: TextStyle(
                                                  color:
                                                      snapshot.error != null ||
                                                              desError
                                                          ? Colors.red
                                                          : hint,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: dressDescripNode
                                                              .hasPrimaryFocus ||
                                                          snapshot.error !=
                                                              null ||
                                                          desError
                                                      ? 15
                                                      : 0),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .tr("profile.dressDescrip"),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: snapshot.error !=
                                                              null ||
                                                          (empty
                                                                  ? bloc
                                                                      .dressDescrip()
                                                                  : "") ==
                                                              null ||
                                                          desError
                                                      ? Border.all(
                                                          color: Colors.red)
                                                      : null,
                                                  boxShadow: dressDescripNode
                                                          .hasPrimaryFocus
                                                      ? [
                                                          BoxShadow(
                                                              color: hint
                                                                  .withOpacity(
                                                                      .3),
                                                              spreadRadius: .5,
                                                              blurRadius: 0,
                                                              offset:
                                                                  Offset(0, 2)),
                                                          BoxShadow(
                                                              color: Colors
                                                                  .transparent,
                                                              spreadRadius: 0,
                                                              blurRadius: 1,
                                                              offset:
                                                                  Offset(0, 1))
                                                        ]
                                                      : null,
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              alignment: Alignment.bottomCenter,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: TextFormField(
                                                maxLines: 5,
                                                controller: des,
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          dressDescripNode);
                                                  dressPriceNode.unfocus();
                                                  dressMobileNode.unfocus();
                                                  dressNameNode.unfocus();
                                                  setState(() {});
                                                },
                                                cursorColor:
                                                    snapshot.error != null ||
                                                            desError
                                                        ? Colors.red
                                                        : bumbi,
                                                onChanged: (d) {
                                                  bloc.onDressDescripChange(d);
                                                  if (d.isEmpty)
                                                    setState(() {
                                                      desError = true;
                                                    });
                                                  else
                                                    setState(() {
                                                      desError = false;
                                                    });
                                                },
                                                focusNode: dressDescripNode,
                                                style: TextStyle(
                                                    color: blackAccent,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: snapshot.error !=
                                                                  null ||
                                                              desError
                                                          ? Colors.red
                                                          : hint,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: dressDescripNode
                                                                  .hasPrimaryFocus ||
                                                              snapshot.error ==
                                                                  null
                                                          ? 15
                                                          : 0),
                                                  hintText: snapshot.error !=
                                                              null ||
                                                          dressDescripNode
                                                              .hasPrimaryFocus ||
                                                          desError
                                                      ? ""
                                                      : AppLocalizations.of(
                                                              context)
                                                          .tr("profile.dressDescrip"),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            desError
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            bloc.lang() == "ar"
                                                                ? 15
                                                                : 0,
                                                        left:
                                                            bloc.lang() == "en"
                                                                ? 15
                                                                : 0),
                                                    child:
                                                        AnimatedDefaultTextStyle(
                                                      duration: mill0Second,
                                                      style: TextStyle(
                                                          color: desError
                                                              ? Colors.red
                                                              : hint,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: dressDescripNode
                                                                      .hasPrimaryFocus ||
                                                                  desError ||
                                                                  snapshot.error !=
                                                                      null
                                                              ? 11
                                                              : 0),
                                                      child: Text(
                                                        descripValidate,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                            /////
                                          ])),
 */
