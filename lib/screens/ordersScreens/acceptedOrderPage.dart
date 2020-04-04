import 'dart:async';
import 'dart:ui';

import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/orderModel.dart';
import 'package:atelier/screens/home/providerPage.dart';
import 'package:atelier/screens/ordersScreens/MakeOrder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_fade/image_fade.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AcceptedOrderPage extends StatefulWidget {
  Order order;
  AcceptedOrderPage({this.order});
  @override
  _AcceptedOrderPageState createState() => _AcceptedOrderPageState();
}

class _AcceptedOrderPageState extends State<AcceptedOrderPage> {
  initState() {
    bloc.changerefresh(false);
    for (int i = 0; i < widget.order.product.images.length; i++) {
      images.add(FadeInImage(
          placeholder: AssetImage('assets/images/placeholder.gif'),
          image: NetworkImage(widget.order.product.images[i]),
          fit: BoxFit.fill));
    }
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  List<Widget> images = [];
  PageController controller = PageController(
    initialPage: 0,
  );
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    Size size = MediaQuery.of(context).size;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          key: scaffold,
          body: Container(
            width: size.width,
            height: size.height,
            child: StreamBuilder(
              stream: bloc.refreshStream,
              builder: (context, loading) => Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      // start of page
                      children: <Widget>[
                        Container(
                          width: size.width,
                          height: bloc.size().height / 2,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                // images
                                height: bloc.size().height / 2,
                                child: PageView(
                                  controller: controller,
                                  scrollDirection: Axis.horizontal,
                                  children: images,
                                  reverse: true,
                                  pageSnapping: true,
                                ),
                              ),
                              Container(
                                //indicator
                                margin: EdgeInsets.only(bottom: 50),
                                child: SmoothPageIndicator(
                                  controller: controller,
                                  count: images.length,
                                  effect: ExpandingDotsEffect(
                                      dotHeight: 12,
                                      dotWidth: 14,
                                      dotColor: Colors.white.withOpacity(.85),
                                      radius: 2),
                                ),
                              ),
                              Positioned(
                                //decoration
                                top: (bloc.size().height / 2) - 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffF9F9F9),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(45),
                                          topRight: Radius.circular(45))),
                                  height: 35,
                                  width: size.width,
                                ),
                              ),
                              Positioned(
                                // back button
                                top: 20,
                                child: Container(
                                  width: size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SmallIconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icons.arrow_back_ios,
                                      ),
                                      Container(
                                        height: 30,
                                        width: 66,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: widget.order.paid
                                                ? bumbiAccent
                                                : hintAccent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Text(
                                          widget.order.paid
                                              ? AppLocalizations.of(context)
                                                  .tr("myOrders.paied")
                                              : AppLocalizations.of(context)
                                                  .tr("myOrders.notPaied"),
                                          style: TextStyle(
                                              color: widget.order.paid
                                                  ? bumbi
                                                  : hint,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ), //images slider

                        Container(
                          constraints:
                              BoxConstraints(minHeight: bloc.size().height / 2),
                          child: DetailsWithCustomBottomSheet(
                              detailsBody: detailsBody(context, widget.order),
                              spaceForHeader: 100,
                              headerBottomSheet:
                                  headerBottomSheet(context, widget.order),
                              bodyBottomSheet: bodBottomSheet(
                                  context, widget.order, scaffold)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: bloc.size().width,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black45,
                            spreadRadius: 5,
                            blurRadius: 15)
                      ]),
                    ),
                    bottom: 0,
                  ),
                  bloc.refresh == true ? LoadingFullScreen() : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget detailsBody(BuildContext context, Order order) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            order.product.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                order.product.price,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 26, color: bumbi),
              ),
              Text(
                AppLocalizations.of(context).tr("payPackage.first.type"),
                style: TextStyle(fontSize: 14, color: bumbi),
              )
            ],
          )
        ],
      ), //فستان اسود
      SizedBox(
        height: 12,
      ),
      Text(
        AppLocalizations.of(context).tr("myProduct.descrip"),
        style: TextStyle(fontSize: 14, color: hint),
      ),
      SizedBox(
        height: 6,
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).tr("profile.dressType"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: <Widget>[
                Text(
                    order.product.dressNote.type ??
                        AppLocalizations.of(context).tr("myProduct.empty"),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).tr("profile.dressOre"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: <Widget>[
                Text(
                    order.product.dressNote.ore ??
                        AppLocalizations.of(context).tr("myProduct.empty"),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).tr("profile.dressColor"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: <Widget>[
                Text(
                    order.product.dressNote.color ??
                        AppLocalizations.of(context).tr("myProduct.empty"),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).tr("profile.dressSize"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: <Widget>[
                Text(
                    order.product.dressNote.size ??
                        AppLocalizations.of(context).tr("myProduct.empty"),
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context).tr("profile.dressPlace"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: <Widget>[
                Text(
                    order.product.dressNote.place ??
                        AppLocalizations.of(context).tr("myProduct.empty"),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 12,
      ),
      Text(
        AppLocalizations.of(context).tr("myProduct.providerHouse"),
        style: TextStyle(fontSize: 14, color: hint),
      ),
      SizedBox(
        height: 6,
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProviderPage(providerModel: order.product.providerModel)));
        },
        child: Text(
          order.product.user_name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}

Widget headerBottomSheet(BuildContext context, Order order) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: bloc.size().width / 3),
        child: Divider(
          thickness: 2,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).tr("myOrders.orderNo"),
                style: TextStyle(fontSize: 16, color: hint),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                order.id.toString(),
                style: TextStyle(fontSize: 16, color: hint),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 8, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: bumbiAccent),
            child: Text(
              order.count.toString(),
              style: TextStyle(
                  fontSize: 26, color: bumbi, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      SizedBox(
        height: 12,
      ),
      Text(
        AppLocalizations.of(context).tr("myProduct.descrip"),
        style: TextStyle(fontSize: 14, color: hint),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget bodBottomSheet(
    BuildContext context, Order order, GlobalKey<ScaffoldState> scaffold) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        constraints: BoxConstraints(maxHeight: bloc.size().height / 7),
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: bloc.size().width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).tr("profile.dressType"),
                style: TextStyle(fontSize: 14, color: hint),
              ),
              SizedBox(
                height: 8,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      order.note.type ??
                          AppLocalizations.of(context).tr("myProduct.empty"),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                AppLocalizations.of(context).tr("profile.dressOre"),
                style: TextStyle(fontSize: 14, color: hint),
              ),
              SizedBox(
                height: 8,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      order.note.ore ??
                          AppLocalizations.of(context).tr("myProduct.empty"),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                AppLocalizations.of(context).tr("profile.dressColor"),
                style: TextStyle(fontSize: 14, color: hint),
              ),
              SizedBox(
                height: 8,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      order.note.color ??
                          AppLocalizations.of(context).tr("myProduct.empty"),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                AppLocalizations.of(context).tr("profile.dressSize"),
                style: TextStyle(fontSize: 14, color: hint),
              ),
              SizedBox(
                height: 8,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      order.note.size ??
                          AppLocalizations.of(context).tr("myProduct.empty"),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                AppLocalizations.of(context).tr("profile.dressPlace"),
                style: TextStyle(fontSize: 14, color: hint),
              ),
              SizedBox(
                height: 8,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      order.note.place ??
                          AppLocalizations.of(context).tr("myProduct.empty"),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
     double.tryParse(order.rate.toString()) != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).tr("myOrders.rating"),
                    style: TextStyle(fontSize: 14, color: hint),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RatingBar(
                    initialRating: double.parse(order.rate.toString()),
                    minRating: 0.0,
                    glow: false,
                    textDirection: TextDirection.ltr,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    onRatingUpdate: (v) {},
                    itemCount: 5,
                    itemSize: 18,
                    ignoreGestures: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: bloc.size().width,
              height: 40,
              child: order.paid
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        BumbiButton(
                          colored: true,
                          text:
                              AppLocalizations.of(context).tr("myOrders.rate"),
                          onPressed: () {
                            scaffold.currentState.showBottomSheet((context) {
                              return Container(
                                child: Rate(
                                  order: order,
                                  scaffold: scaffold,
                                ),
                              );
                            });
                          },
                        )
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        BumbiButton(
                          colored: true,
                          text: AppLocalizations.of(context).tr("myOrders.pay"),
                          onPressed: () async {
                            await atelierPayMent(
                                double.parse(order.product.price) *
                                    double.parse(order.count.toString()),
                                "http://atelierapps.com/api/v1/order/${order.id}/pay",
                                "http://atelierapps.com/api/v1/failed_transfer",
                                context);

                            bloc.changerefresh(true);
                            Order o = await getOrder(order.id, context);
                            bloc.changerefresh(false);
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => AcceptedOrderPage(
                                          order: o,
                                        )));
                          },
                        ),
                      ],
                    ),
            ),
      SizedBox(
        height: 20,
      )
    ],
  );
}

class Rate extends StatefulWidget {
  Order order;
  GlobalKey<ScaffoldState> scaffold;
  Rate({this.order, this.scaffold});
  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {
  String comment;
  bool delete = false;
  bool error = false;
  double rate;
  @override
  Widget build(BuildContext context) {
    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(45),
                        topLeft: Radius.circular(45))),
                child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    width: 148,
                                    height: 100,
                                    child:
                                        Image.asset('assets/images/rate.png')),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .tr("myOrders.addRate"),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: blackAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RatingBar(
                                  initialRating: 0.0,
                                  minRating: 0.0,
                                  glow: false,
                                  textDirection: TextDirection.ltr,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 18,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      error = false;
                                      rate = rating;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: TextFormField(
                                    cursorColor: bumbi,
                                    onChanged: (v) {
                                      setState(() {
                                        comment = v;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        hintStyle: error
                                            ? TextStyle(color: Colors.red)
                                            : null,
                                        border: InputBorder.none,
                                        hintText: error
                                            ? AppLocalizations.of(context)
                                                .tr("comments.error")
                                            : AppLocalizations.of(context)
                                                .tr("myOrders.comment")),
                                  ),
                                  height: 50,
                                  width: bloc.size().width,
                                  decoration: BoxDecoration(
                                      color: Color(0xfff9f9f9),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      BumbiButton(
                                        colored: true,
                                        text: AppLocalizations.of(context)
                                            .tr("myOrders.cancelOrder"),
                                        onPressed: () async {
                                          if (rate == null) {
                                            setState(() {
                                              error = true;
                                            });
                                          } else {
                                            setState(() {
                                              delete = true;
                                            });
                                            RateModel rateModel =
                                                await rateOrder(
                                                    context: context,
                                                    order_id: widget.order.id,
                                                    rate: rate);
                                            Order order = await getOrder(
                                                widget.order.id, context);

                                            setState(() {
                                              delete = false;
                                            });
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AcceptedOrderPage(
                                                              order: order,
                                                            )));
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      BumbiButton(
                                        colored: false,
                                        text: AppLocalizations.of(context)
                                            .tr("myOrders.back"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        delete
                            ? Positioned.fill(
                                child: LoadingFullScreen(),
                              )
                            : SizedBox(),
                      ],
                    ))),
          ),
        ],
      ),
    );
  }
}
