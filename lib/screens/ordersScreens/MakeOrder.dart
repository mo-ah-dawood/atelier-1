import 'package:atelier/blocs/design.dart';
import 'package:atelier/models/orderModel.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class MakeOrder extends StatefulWidget {
  Product product;
  Order order;
  MakeOrder({this.product, this.order});
  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  @override
  void initState() {
    
          bloc.ondressPlaceChange(null);
          bloc.ondressTypeChange(null);
          bloc.ondressSizeChange(null);
          bloc.ondressOreChange(null);
          bloc.ondressColorChange(null);
        
    if (widget.order != null)
      setState(() {
        counter = widget.order.count;
        if (widget.order.note != null) {
          type.text = widget.order.note.type;
          ore.text = widget.order.note.ore;
          color.text = widget.order.note.color;
          place.text = widget.order.note.place;
          sizeC.text = widget.order.note.size;
          bloc.ondressPlaceChange(widget.order.note.place);
          bloc.ondressTypeChange(widget.order.note.type);
          bloc.ondressSizeChange(widget.order.note.size);
          bloc.ondressOreChange(widget.order.note.ore);
          bloc.ondressColorChange(widget.order.note.color);
        } 
      });

    super.initState();
  }

  bool empty = false;
  bool validate = false;

  TextEditingController _textEditingController = TextEditingController();
  void whatsAppOpen(String mobile) async {
    var whatsappUrl = "whatsapp://send?phone=$mobile";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      await launch("tel:$mobile");
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  bool loading = false;
  String note;
  FocusNode dressTypeNode = FocusNode();
  FocusNode dressOreNode = FocusNode();
  FocusNode dressColorNode = FocusNode();
  FocusNode dressSizeNode = FocusNode();
  FocusNode dressPlaceNode = FocusNode();
  TextEditingController type = TextEditingController();
  TextEditingController ore = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController sizeC = TextEditingController();
  TextEditingController place = TextEditingController();

  int counter = 1;
  @override
  Widget build(BuildContext context) {
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
          return Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
            key: scaffold,
            body: GestureDetector(
              onTap: () {
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
                      // Positioned(
                      //   bottom: 0,
                      //   left: localCode == "ar" ? 0 : null,
                      //   right: localCode == "ar" ? null : 0,
                      //   child: Opacity(
                      //     opacity: 0.2,
                      //     child: Container(
                      //         alignment: localCode == "ar"
                      //             ? Alignment.bottomLeft
                      //             : Alignment.bottomRight,
                      //         width: size.width - 50,
                      //         height: size.height - 50,
                      //         child: Image.asset(
                      //           'assets/images/$girle',
                      //           fit: BoxFit.fill,
                      //         )),
                      //   ),
                      // ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                children: <Widget>[
                                  SmallIconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icons.arrow_back_ios,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("myOrders.makeOrder"),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, top: 10, left: 20),
                              child: Wrap(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .tr("myOrders.hint"),
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .tr("myOrders.count"),
                                    style: TextStyle(fontSize: 16, color: hint),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  height: 40,
                                  width: 120,
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.center,
                                          color: Colors.white,
                                          width: 100,
                                          height: 35,
                                          child: Text(
                                            "$counter",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      CounterButton(
                                        left: -5,
                                        iconData: Icons.remove,
                                        onLongPressed: () {
                                          setState(() {
                                            counter = 1;
                                          });
                                        },
                                        onPressed: () {
                                          setState(() {
                                            if (counter > 1) counter--;
                                          });
                                        },
                                      ),
                                      CounterButton(
                                        right: -5,
                                        iconData: Icons.add,
                                        onPressed: () {
                                          setState(() {
                                            counter++;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: <Widget>[
                                  StreamBuilder(
                                      //// type
                                      stream: validate
                                          ? bloc.dressTypeStream
                                          : null,
                                      builder: (context, snapshot) =>
                                          AtelierTextField(
                                            controller: type,
                                            value:
                                                empty ? bloc.dressType() : "",
                                            focusNode: dressTypeNode,
                                            unFocus: () {
                                              dressOreNode.unfocus();

                                              dressSizeNode.unfocus();
                                              dressPlaceNode.unfocus();
                                              dressColorNode.unfocus();
                                            },
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
                                            value: empty ? bloc.dressOre() : "",
                                            focusNode: dressOreNode,
                                            unFocus: () {
                                              dressTypeNode.unfocus();
                                              dressSizeNode.unfocus();
                                              dressPlaceNode.unfocus();
                                              dressColorNode.unfocus();
                                            },
                                            label: AppLocalizations.of(context)
                                                .tr("profile.dressOre"),
                                            onChanged: (v) {
                                              bloc.ondressOreChange(v);
                                            },
                                            password: false,
                                          )),
                                  StreamBuilder(
                                      //color
                                      stream: validate
                                          ? bloc.dressColorStream
                                          : null,
                                      builder: (context, snapshot) =>
                                          AtelierTextField(
                                            controller: color,
                                            value:
                                                empty ? bloc.dressColor() : "",
                                            focusNode: dressColorNode,
                                            unFocus: () {
                                              dressOreNode.unfocus();
                                              dressTypeNode.unfocus();
                                              dressSizeNode.unfocus();
                                              dressPlaceNode.unfocus();
                                            },
                                            label: AppLocalizations.of(context)
                                                .tr("profile.dressColor"),
                                            onChanged: (v) {
                                              bloc.ondressColorChange(v);
                                            },
                                            password: false,
                                          )),
                                  StreamBuilder(
                                      //size
                                      stream: validate
                                          ? bloc.dressSizeStream
                                          : null,
                                      builder: (context, snapshot) =>
                                          AtelierTextField(
                                            controller: sizeC,
                                            value:
                                                empty ? bloc.dressSize() : "",
                                            focusNode: dressSizeNode,
                                            unFocus: () {
                                              dressOreNode.unfocus();
                                              dressTypeNode.unfocus();
                                              dressPlaceNode.unfocus();
                                              dressColorNode.unfocus();
                                            },
                                            label: AppLocalizations.of(context)
                                                .tr("profile.dressSize"),
                                            onChanged: (v) {
                                              bloc.ondressSizeChange(v);
                                            },
                                            password: false,
                                          )),
                                  StreamBuilder(
                                      //place
                                      stream: validate
                                          ? bloc.dressPlaceStream
                                          : null,
                                      builder: (context, snapshot) =>
                                          AtelierTextField(
                                            controller: place,
                                            value:
                                                empty ? bloc.dressPlace() : "",
                                            focusNode: dressPlaceNode,
                                            unFocus: () {
                                              dressOreNode.unfocus();
                                              dressTypeNode.unfocus();
                                              dressSizeNode.unfocus();
                                              dressColorNode.unfocus();
                                            },
                                            label: AppLocalizations.of(context)
                                                .tr("profile.dressPlace"),
                                            onChanged: (v) {
                                              bloc.ondressPlaceChange(v);
                                            },
                                            password: false,
                                          )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                           Container(margin: EdgeInsets.symmetric(horizontal: 70),
                           padding: EdgeInsets.symmetric(vertical: 10),
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.all(Radius.circular(15))
                           ),
                             child: Column(children: <Widget>[
                                Center(
                              child: Text(
                                AppLocalizations.of(context).tr("profile.all"),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,color: bumbi),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    widget.order!=null?"${double.parse(widget.order.product.price) * double.parse(counter.toString())}":
                                      "${double.parse(widget.product.price) * double.parse(counter.toString())}",
                                       style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 4,),
                                      Text(
                                AppLocalizations.of(context).tr("payPackage.first.type"),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,color: bumbi),
                              ),
                                ],
                              ),
                             ],),
                           ),
                            
                            Container(
                              height: 40,
                              margin: EdgeInsets.all(20),
                              child: MaterialButton(
                                color: bumbi,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                highlightColor:
                                    Colors.redAccent.withOpacity(.5),
                                splashColor: Colors.red[50],
                                colorBrightness: Brightness.light,
                                padding: EdgeInsets.all(0),
                                child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .tr("myOrders.confirm"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                onPressed: () async {
                                  if (bloc.dressType() == null ||
                                      bloc.dressSize() == null ||
                                      bloc.dressColor() == null ||
                                      bloc.dressPlace() == null ||
                                      bloc.dressOre() == null ||
                                      bloc.dressType() == "" ||
                                      bloc.dressSize() == "" ||
                                      bloc.dressColor() == "" ||
                                      bloc.dressPlace() == "" ||
                                      bloc.dressOre() == "")
                                    setState(() {

                                      empty = true;
                                      showSnackBarContent(Text(AppLocalizations.of(context).tr("validators.empty")), scaffold);
                                    });
                                  else {
                                    setState(() {
                                      loading = true;
                                    });

                                    if (widget.order == null)
                                      await createOrder(
                                        context: context,
                                        count: counter,
                                        totalPrice:  widget.order!=null?"${double.parse(widget.order.product.price) * double.parse(counter.toString())}":
                                      "${double.parse(widget.product.price) * double.parse(counter.toString())}",
                                        product_id: widget.product.id,
                                      );
                                    else
                                      await updateOrderBeforeAccept(
                                        context: context,
                                        count: counter,
                                        totalPrice:  widget.order!=null?"${double.parse(widget.order.product.price) * double.parse(counter.toString())}":
                                      "${double.parse(widget.product.price) * double.parse(counter.toString())}",
                                        id: widget.order.id,
                                      );

                                    setState(() {
                                      loading = false;
                                    });
                                    if (bloc.doneMSG() != null)
                                      showSnackBarContent(
                                          Text(bloc.doneMSG()), scaffold);
                                    else {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AtelierCenter(
                                                    screen: 1,
                                                    index: 0,
                                                  )));
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      loading ? LoadingFullScreen() : SizedBox()
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class CounterButton extends StatelessWidget {
  CounterButton(
      {this.iconData,
      this.onPressed,
      this.left,
      this.right,
      this.onLongPressed});
  IconData iconData;
  Function onPressed;
  Function onLongPressed;
  double left;
  double right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200], blurRadius: .2, spreadRadius: .2),
              BoxShadow(color: Colors.white)
            ]),
        width: 36,
        height: 36,
        child: MaterialButton(
          splashColor: Colors.white,
          onLongPress: onLongPressed,
          highlightColor: bumbiAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          onPressed: onPressed,
          padding: EdgeInsets.all(0),
          child: Icon(
            iconData,
            color: bumbi,
          ),
        ),
      ),
    );
  }
}
