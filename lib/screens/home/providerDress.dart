
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/ordersScreens/MakeOrder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_fade/image_fade.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_show_more/flutter_show_more.dart';

class ProviderDress extends StatefulWidget {
  Product product;
  ProviderDress({this.product});
  @override
  _ProviderDressState createState() => _ProviderDressState();
}

class _ProviderDressState extends State<ProviderDress> {
  initState() {
    super.initState();
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

  PageController controller = PageController(
    initialPage: 0,
  );
   GlobalKey bottomSheetBodyKey = GlobalKey();
  GlobalKey bottomSheetHeaderKey = GlobalKey();
  Size bottomSheetBodySize;
  Size bottomSheetHeaderSize;
  double bottom = 0;
  double bodyBottom = -500;
  double start = 0;
  double current = 0;
  double end = 0;
  bool move=false;
  setBottomSheetSizes() async {
    final RenderBox body = bottomSheetBodyKey.currentContext.findRenderObject();
    final RenderBox header =
        bottomSheetHeaderKey.currentContext.findRenderObject();
    final bodySize = body.size;
    final headerSize = header.size;
    setState(() {
      bottomSheetBodySize = bodySize;
      bottomSheetHeaderSize = headerSize;
    });
  }

  double height = 0;
 

  List<Widget> images = [];

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          return Future.value(false);
        },
        child: Scaffold(
          body: Container(
            width: bloc.size().width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  width: bloc.size().width,
                  height: MediaQuery.of(context).size.height,
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: images,
                    reverse: true,
                    pageSnapping: true,
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: SmallIconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icons.arrow_back_ios,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                   

                    AnimatedPositioned(
          child: GestureDetector(
            onVerticalDragStart: (d) {
              setBottomSheetSizes();
              setState(() {
                bottom = end;
                start = d.globalPosition.dy;
                bodyBottom = bottom - bottomSheetBodySize.height;
              });
            },
            onVerticalDragUpdate: (d) {

              setState(() {
               if(bodyBottom>-bottomSheetBodySize.height)
                move=true;
                current = end + (start - d.globalPosition.dy);
                if (current > bottomSheetBodySize.height || current < 0) {
                  bodyBottom = bottom - bottomSheetBodySize.height;
                } else {
                  bottom = current;
                  bodyBottom = bottom - bottomSheetBodySize.height;
                }
              });
            },
            onVerticalDragEnd: (d) {
              setState(() {
                if (bottom - end >= 50) {
                  bottom = bottomSheetBodySize.height;
                  bodyBottom = bottom - bottomSheetBodySize.height;

                  end = bottom;
                } else if (bottom - end <= -50) {
                  move=false;
                  bottom = 0;
                  bodyBottom = bottom - bottomSheetBodySize.height;

                  end = bottom;
                } else {
                  bottom = end;
                  bodyBottom = bottom - bottomSheetBodySize.height;
                }
              });
            },
            child: Column(
              children: <Widget>[
                 Container(
                        //indicator

                        padding: EdgeInsets.only(bottom: 15),
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
                Container(
                    key: bottomSheetHeaderKey,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(45),
                          topLeft: Radius.circular(45)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: bloc.size().width,
                    child:Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: bloc.size().width / 3,
                                              vertical: 5),
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: bloc.size().width-130,
                                                child: Wrap(
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment: WrapCrossAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                     widget.product.title,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
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
                                          ),
                                         //فستان اسود
                                        SizedBox(
                                          height: 12,
                                        ),
                                       
                                        move
                                            ? SizedBox()
                                            : Wrap(
                                                children: <Widget>[
                                                  ShowMoreText(
                                                     
                                          AppLocalizations.of(context)
                                              .tr("myProduct.descrip"),
                                          style:
                                              TextStyle(fontSize: 14, color: hint),
                                        
                                                    maxLength: 25,
                                                    showMoreText: "",
                                                  ),
                                                ],
                                              ),
                                                                                      SizedBox(
                                          height: 6,
                                        ),

                                      ],
                                    ), 
                    /////////////////////////////////////
                    ),
              ],
            ),
          ),
          duration: mill000Second,
          bottom: bottom,
        ),
        AnimatedPositioned(
            bottom: bodyBottom,
            child: GestureDetector(
              onVerticalDragStart: (d) {
                setBottomSheetSizes();
                setState(() {
                  bottom = end;
                  start = d.globalPosition.dy;
                  bodyBottom = bottom - bottomSheetBodySize.height;
                });
              },
              onVerticalDragUpdate: (d) {
                setState(() {
                  current = end + (start - d.globalPosition.dy);
                  if (current > bottomSheetBodySize.height || current < 0) {
                    bodyBottom = bottom - bottomSheetBodySize.height;
                  } else {
                    bottom = current;
                    bodyBottom = bottom - bottomSheetBodySize.height;
                  }
                });
              },
              onVerticalDragEnd: (d) {
                setState(() {
                  if (bottom - end >= 50) {
                    bottom = bottomSheetBodySize.height;
                    bodyBottom = bottom - bottomSheetBodySize.height;

                    end = bottom;
                  } else if (bottom - end <= -50) {
                    bottom = 0;
                    bodyBottom = bottom - bottomSheetBodySize.height;

                    end = bottom;
                  } else {
                    bottom = end;
                    bodyBottom = bottom - bottomSheetBodySize.height;
                  }
                });
              },
              child: Container(
                width: bloc.size().width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  alignment: Alignment.topRight,
                  ///////////// body
                  key: bottomSheetBodyKey,
                  child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                        Container(
                                          width: bloc.size().width,
                                          constraints: BoxConstraints(maxHeight: bloc.size().height/4),
                                          child: SingleChildScrollView(
                                            child: Column(
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
                                          ),
                                        ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .tr("myProduct.providerHouse"),
                                      style:
                                          TextStyle(fontSize: 14, color: hint),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        widget.product.user_name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 40,
                                      width: bloc.size().width,
                                      child: Row(
                                        children: <Widget>[
                                          BumbiButton(
                                            colored: true,
                                            text: AppLocalizations.of(context)
                                                .tr("myProduct.orderDress"),
                                            onPressed: ()  {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MakeOrder(product: widget.product,)));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                  /////////////////////////////////
                  ),
            ),
            duration: mill000Second)
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}




