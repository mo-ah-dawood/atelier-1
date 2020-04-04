import 'package:atelier/blocs/design.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/screens/home/AtelierProviderCenter.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'dart:async';

import 'package:flutter_email_sender/flutter_email_sender.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  void initState() {
    getTyps();
    super.initState();
  }
getTyps()async{
  Map<int,String>m=await getContactTyps();
  setState(() {
    typs=m;
  });
}
    Map<int,String> typs = {};


  final ScrollController controller = ScrollController();
  TextEditingController message = TextEditingController();
  final messageNode = new FocusNode();
  String messageText;
  bool empty = false;
  List<DropdownMenuItem> _dropdownMenuItems;
  bool loading = false;
  List<DropdownMenuItem> buildDropdownMenuItems(List typs) {
    List<DropdownMenuItem> items = List();
    for (int i = 0; i < typs.length; i++) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Container(
              child: Text(
            typs[i],
            style: TextStyle(
                fontWeight:
                    _selectedValue == i ? FontWeight.bold : FontWeight.normal),
          )),
        ),
      );
    }
    return items;
  }

  int _selectedValue = 0;
  onChangeDropdownItem(int selectedType) {
    setState(() {
      _selectedValue = selectedType;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _dropdownMenuItems = buildDropdownMenuItems(typs.values.toList());
    });
    var data = EasyLocalizationProvider.of(context).data;
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    String girle = AppLocalizations.of(context).tr("splach.girle").toString();
    String localCode = Localizations.localeOf(context).languageCode.toString();
    // String code =Localizations.localeOf(context).languageCode;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
          bloc.currentUser().type == "user"
              ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AtelierCenter(
                        screen: 3,
                      )))
              : Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AtelierProviderCenter(
                        screen: 3,
                      )));
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            body: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                width: size.width,
                height: size.height,
                child: Stack(
                  alignment: bloc.lang() == "ar"
                      ? Alignment.topRight
                      : Alignment.topLeft,
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
                            width: size.width - 50,
                            height: size.height - 50,
                            child: Image.asset(
                              'assets/images/$girle',
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                    SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            children: <Widget>[
                              SmallIconButton(
                                onPressed: () {
                                  bloc.currentUser().type == "user"
                                      ? Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => AtelierCenter(
                                                    screen: 3,
                                                  )))
                                      : Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AtelierProviderCenter(
                                                    screen: 3,
                                                  )));
                                },
                                icon: Icons.arrow_back_ios,
                              ),
                              Text(
                                AppLocalizations.of(context).tr("more.contact"),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 20, top: 10, left: 20),
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).tr("more.how"),
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).tr("more.happy"),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, top: 30, bottom: 5, left: 20),
                          child: Text(
                            AppLocalizations.of(context).tr("more.kind"),
                            style: TextStyle(fontSize: 14, color: hint),
                          ),
                        ),
                        Container(
                          //نوع التواصل
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: DropdownButton(
                            underline: SizedBox(),
                            isExpanded: true,
                            value: _selectedValue,
                            items: _dropdownMenuItems,
                            onChanged: (v) {
                              onChangeDropdownItem(v);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, top: 20, bottom: 5, left: 20),
                          child: Text(
                            AppLocalizations.of(context).tr("more.text"),
                            style: TextStyle(fontSize: 14, color: hint),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 120,
                                  child: DraggableScrollbar.rrect(
                                    backgroundColor: hint,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    alwaysVisibleScrollThumb: false,
                                    controller: controller,
                                    heightScrollThumb: 40,
                                    child: ListView(
                                        padding: EdgeInsets.only(right: 20),
                                        controller: controller,
                                        children: <Widget>[
                                          TextFormField(
                                            controller: message,
                                            cursorColor: bumbi,
                                            enabled:
                                                true, /////////////////////////////////////////////
                                            maxLines: 9,

                                            focusNode: messageNode,
                                            onChanged: (v) {
                                              setState(() {
                                                messageText = v;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: empty
                                                    ? AppLocalizations.of(context)
                                                        .tr("more.message")
                                                    : "",
                                                hintStyle: TextStyle(
                                                    fontSize: 13,
                                                    color: empty
                                                        ? Colors.red
                                                        : Colors.grey),
                                                border: UnderlineInputBorder(
                                                    borderSide: BorderSide.none)),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: hint.withOpacity(.3),
                                            spreadRadius: .5,
                                            blurRadius: 0,
                                            offset: Offset(0, 2)),
                                        BoxShadow(
                                            color: Colors.transparent,
                                            spreadRadius: 0,
                                            blurRadius: 1,
                                            offset: Offset(0, 1))
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.all(20),
                          child: MaterialButton(
                            color: bumbi,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            highlightColor: Colors.redAccent.withOpacity(.5),
                            splashColor: Colors.red[50],
                            colorBrightness: Brightness.light,
                            padding: EdgeInsets.all(0),
                            child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Text(
                                  AppLocalizations.of(context).tr("more.send"),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            onPressed: () async {
          //                     if (messageText == null || messageText.isEmpty)
          //                       setState(() {
          //                         empty = true;
          //                       });
          //                     else {
          //                       final Email email = Email(
          //                         body: messageText,
          //                         subject: typs[_selectedValue],
          //                         recipients: [bloc.staticData().email],
          //                         // cc: [bloc.currentUser().email], هيوصله االايميل والباقيين هيشوفوا انه وصله
          //                         // bcc: ['bcc@example.com'], هيوصله الايميل بدون ما الباقيين يشوفو انه وصله
          //                       );
          //                       await FlutterEmailSender.send(email);
          // bloc.currentUser().type == "user"
          //       ? Navigator.of(context).pushReplacement(MaterialPageRoute(
          //           builder: (context) => AtelierCenter(
          //                 screen: 3,
          //               )))
          //       : Navigator.of(context).pushReplacement(MaterialPageRoute(
          //           builder: (context) => AtelierProviderCenter(
          //                 screen: 3,
          //               )));
          //                     }
                                       
                              if (messageText != null) {
                                        if(messageText.isNotEmpty ){
                                        setState(() {
                                          loading = true;
                                        });
                                        var a =
                                            await contactUs(typs.keys.toList()[_selectedValue], messageText);
                                        setState(() {
                                          loading = false;
                                        });
                                        if (int.tryParse(a) == null) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Text(
                                                        a,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ));
                                              });
                                        } else {
                                          await clearUserData();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Splach()));
                                        }}
                                      }

                            },
                          ),
                        )
                      ],
                    )),
                    loading ? LoadingFullScreen() : SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
