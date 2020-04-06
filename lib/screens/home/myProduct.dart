import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/screens/home/addDress.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:http/http.dart';
import 'package:image_fade/image_fade.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProduct extends StatefulWidget {
  Product product;
  MyProduct({this.product});
  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  GlobalKey bottomSheetBodyKey = GlobalKey();
  GlobalKey bottomSheetHeaderKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  Offset bottomPosition;
  Size bottomSheetBodySize;
  Size bottomSheetHeaderSize;
  Size infoContainer;
  double bottom = 135 - bloc.size().height / 2;
  double start = 0;
  double current = 0;
  double end = 0;
  bool delete = false;
  bool move = false;
  initState() {
    super.initState();
            bloc.onDressNameChange(null);
      bloc.onDressPriceChange(null);
      bloc.onDressDescripChange(null); 
    for (int i = 0; i < widget.product.images.length; i++)
      images.add(
                     FullScreenWidget(
                       child: FadeInImage(
                                      placeholder:AssetImage('assets/images/placeholder.gif'),

          image:NetworkImage(widget.product.images[i]),
          height: 350,
          fit: BoxFit.fill,
        ),
                     ),
      );
  }

  _launchCaller(String mobile) async {
    String url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      scaffold.currentState.showSnackBar(SnackBar(
        content: Text("حاول مجدداً"),
      ));
    }
  }

  setBottomSheetSizes() async {
    final RenderBox body = bottomSheetBodyKey.currentContext.findRenderObject();
    final RenderBox header =
        bottomSheetHeaderKey.currentContext.findRenderObject();
    // final positionBottom =
    //     body.localToGlobal(Offset.zero);
    final bodySize = body.size;
    final headerSize = header.size;
    setState(() {
      bottomSheetBodySize = bodySize;
      bottomSheetHeaderSize = headerSize;
    });

    setState(() {
      end = bottom;
      bottom = -bottomSheetBodySize.height;
    });
  }

  List<Widget> images = [];
  PageController controller = PageController(
    initialPage: 0,
  );
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
            child: SingleChildScrollView(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SmallIconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icons.arrow_back_ios,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ), //images slider

                  //////////////////////////////////////////////////////////////////////////////////////
                  Container(
                    constraints:
                        BoxConstraints(maxHeight: bloc.size().height / 2),
                    child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        ListView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Color(0xffF9F9F9),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          widget.product.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              widget.product.price,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 26,
                                                  color: bumbi),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .tr("payPackage.first.type"),
                                              style: TextStyle(
                                                  fontSize: 14, color: bumbi),
                                            )
                                          ],
                                        )
                                      ],
                                    ), //فستان اسود
                                    SizedBox(
                                      height: 12,
                                    ),
                                   
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).tr("profile.dressType"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(height: 8,),
            Wrap(
              children: <Widget>[
                Text(widget.product.dressNote.type??AppLocalizations.of(context)
                                                  .tr("myProduct.empty"),
                                                   style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))
              ],
            ),
                    SizedBox(height: 8,),
                Text(
              AppLocalizations.of(context).tr("profile.dressOre"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(height: 8,),
            Wrap(
              children: <Widget>[
                Text(widget.product.dressNote.ore??AppLocalizations.of(context)
                                                  .tr("myProduct.empty"),
                                                   style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))
              ],
            ),
                    SizedBox(height: 8,),
            Text(
              AppLocalizations.of(context).tr("profile.dressColor"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(height: 8,),
            Wrap(
              children: <Widget>[
                Text(widget.product.dressNote.color??AppLocalizations.of(context)
                                                  .tr("myProduct.empty"),
                                                   style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))
              ],
            ),
                    SizedBox(height: 8,),
            Text(
              AppLocalizations.of(context).tr("profile.dressSize"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(height: 8,),
            Wrap(
              children: <Widget>[
                Text(widget.product.dressNote.size??AppLocalizations.of(context)
                                                  .tr("myProduct.empty"),
                                                   style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
              ],
            ),
                    SizedBox(height: 8,),
            Text(
              AppLocalizations.of(context).tr("profile.dressPlace"),
              style: TextStyle(fontSize: 14, color: hint),
            ),
            SizedBox(height: 8,),
            Wrap(
              children: <Widget>[
                Text(widget.product.dressNote.place??AppLocalizations.of(context)
                                                  .tr("myProduct.empty"),
                                                   style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))
              ],
            ),
                    SizedBox(height: 8,),
          ],
        ),
                                    // Wrap(
                                    //   children: <Widget>[
                                    //     Text(
                                    //       widget.product.note ??
                                    //           AppLocalizations.of(context)
                                    //               .tr("myProduct.empty"),
                                    //       style: TextStyle(
                                    //           fontSize: 16,
                                    //           fontWeight: FontWeight.w600),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .tr("myProduct.mobile"),
                                      style:
                                          TextStyle(fontSize: 14, color: hint),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _launchCaller(
                                          bloc.currentUser().type=="user"?
                                          widget.product.mobile:
                                            widget.product.user_mobile);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: hint,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                          bloc.currentUser().type=="user"?
                                         "${ widget.product.mobile}":
                                            "${widget.product.user_mobile}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      height: 40,
                                      width: bloc.size().width,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          BumbiButton(
                                            colored: true,
                                            text: AppLocalizations.of(context)
                                                .tr("myProduct.edit"),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddDress(
                                                            product:
                                                                widget.product,
                                                          )));
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          BumbiButton(
                                            colored: false,
                                            text: AppLocalizations.of(context)
                                                .tr("myProduct.delete"),
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return DeleteDress(widget.product.id);
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
 
                  
*/
class DeleteDress extends StatefulWidget {
  int id;
  DeleteDress(this.id);
  @override
  _DeleteDressState createState() => _DeleteDressState();
}

class _DeleteDressState extends State<DeleteDress> {
  bool delete = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: Color(0xff737373),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45), topLeft: Radius.circular(45))),
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              width: 148,
                              height: 100,
                              child: Image.asset('assets/images/delete.png')),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            AppLocalizations.of(context).tr("myProduct.delMessage"),
                            style: TextStyle(
                                fontSize: 18,
                                color: blackAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 40,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                BumbiButton(
                                  colored: true,
                                  text: AppLocalizations.of(context)
                                      .tr("myProduct.delete"),
                                  onPressed: () async {
                                    setState(() {
                                      delete = true;
                                    });
                                      await deletDress(widget.id,context);
                                    setState(() {
                                      delete = false;
                                    });
                                     Navigator.of(context).pop(Navigator.of(context).pop());
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                BumbiButton(
                                  colored: false,
                                  text: AppLocalizations.of(context)
                                      .tr("myOrders.cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
             delete?         Positioned.fill(
                        child: LoadingFullScreen(),
                      ):SizedBox(),
      
                      
                    ],
                  ))),
        ),
      ],
    );
  }
}
