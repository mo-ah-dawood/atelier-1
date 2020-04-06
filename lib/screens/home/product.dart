import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/screens/home/atelierUserCenter.dart';
import 'package:atelier/screens/home/providerPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_fade/image_fade.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class NormalProduct extends StatefulWidget {
  Product product;
  NormalProduct({this.product});
  @override
  _NormalProductState createState() => _NormalProductState();
}

class _NormalProductState extends State<NormalProduct> {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SmallIconButton(
                                  icon: Icons.arrow_back_ios,
                                  onPressed: (){Navigator.of(context).pop();},
                                ),
                                SizedBox()
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
                                          widget.product.title??"",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              widget.product.price.toString()??"",
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
                                    Text(
                                      AppLocalizations.of(context).tr("myProduct.descrip"),
                                      style:
                                          TextStyle(fontSize: 14, color: hint),
                                    ),
                                    SizedBox(
                                      height: 6,
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
                                    //       widget.product.note??
                                              // AppLocalizations.of(context)
                                              //     .tr("myProduct.empty"),
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
                                          .tr("myProduct.owner"),
                                      style:
                                          TextStyle(fontSize: 14, color: hint),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 54,
                                          height: 54,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child:
                     FadeInImage(
                                    placeholder:AssetImage('assets/images/placeholder.gif'),

                                              image:NetworkImage( widget.product.user_image),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                               onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProviderPage(providerModel: widget.product.providerModel)));
                                                    },
                                              child: Text(
                                                widget.product.user_name??"مستخدم",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
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
                                          widget.product.providerModel.type=="user"?
                                         "${ widget.product.mobile}":
                                            "${widget.product.user_mobile}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
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
