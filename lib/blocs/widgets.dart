import 'package:atelier/models/orderModel.dart';
import 'package:atelier/models/staticData.dart';
import 'package:atelier/screens/login&signUp/forgetPassword.dart';
import 'package:atelier/screens/ordersScreens/acceptedOrderPage.dart';
import 'package:atelier/screens/ordersScreens/newOrderPage.dart';
import 'package:atelier/screens/ordersScreens/providerAcceptedOrderPage.dart';
import 'package:atelier/screens/ordersScreens/providerNewOrderPage.dart';
import 'package:atelier/screens/ordersScreens/providerRejectedOrderPage.dart';
import 'package:atelier/screens/ordersScreens/rejectedOrderPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_fade/image_fade.dart';
import 'bloc.dart';
import 'package:flutter/material.dart';
import 'design.dart';

// gloabl button in the application
class BumbiButton extends StatelessWidget {
  String text;
  Function onPressed;
  BoxDecoration boxDecoration;
  Widget child;
  bool expanded;
  bool colored;
  BumbiButton(
      {this.onPressed,
      this.text,
      this.expanded,
      this.boxDecoration,
      this.child,
      this.colored});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MaterialButton(
      color: colored ? bumbi : null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      highlightColor: colored
          ? Colors.redAccent.withOpacity(.5)
          : bumbiAccent.withOpacity(.5),
      splashColor: Colors.red[50],
      colorBrightness: Brightness.light,
      padding: EdgeInsets.all(0),
      child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: boxDecoration != null
              ? boxDecoration
              : BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
          child: child != null
              ? child
              : Text(
                  text,
                  style: TextStyle(
                      fontSize: 14,
                      color: colored ? Colors.white : bumbi,
                      fontWeight: FontWeight.bold),
                )),
      onPressed: onPressed,
    ));
  }
}

//// Icon button
class BumbiIconButton extends StatelessWidget {
  Function onPressed;
  IconData iconData;
  Widget child;
  Color color;
  double width;
  BumbiIconButton(
      {this.iconData, this.child, this.color, this.onPressed, this.width});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      highlightColor: bumbiAccent.withOpacity(.5),
      splashColor: Colors.red[100],
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: color != null ? color : bumbiAccent,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: child != null
            ? child
            : Icon(
                iconData,
                color: bumbi,
                size: width != null ? width : 22,
              ),
      ),
    );
  }
}

///
/// back button

class SmallIconButton extends StatelessWidget {
  IconData icon;
  EdgeInsets padding;
  Color color;
  Function onPressed;
  SmallIconButton({this.icon, this.onPressed, this.color, this.padding});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null ? padding : EdgeInsets.all(15),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: Icon(
            icon,
            color: color ?? blackAccent,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/////
/// text field

class AtelierTextField extends StatefulWidget {
  String label;
  Function unFocus;
  bool password;
  FocusNode focusNode;
  BuildContext context;
  Function onChanged;
  String error;
  String value;
  TextEditingController controller;
  String forget;
  String lang;
  Widget child;
  TextInputType type;

  AtelierTextField(
      {this.label,
      this.lang,
      this.controller,
      this.type,
      this.value,
      this.onChanged,
      this.password,
      this.child,
      this.focusNode,
      this.error,
      this.forget,
      this.unFocus});
  @override
  _AtelierTextFieldState createState() => _AtelierTextFieldState();
}

class _AtelierTextFieldState extends State<AtelierTextField> {
  bool visiable = true;
  bool tapped = false;
  BuildContext context;
  String data;
  @override
  void initState() {
    visiable = widget.password ? false : true;
    context = widget.context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          duration: Duration(microseconds: 0),
          style: TextStyle(
            
              color: widget.error != null ? Colors.red : hint,
              fontWeight: FontWeight.w600,
              fontSize: widget.focusNode.hasPrimaryFocus || widget.error != null
                  ? 15
                  : 0),
          child: Text(
            widget.label,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          height: 45,
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: widget.child != null
              ? widget.child
              : TextFormField(
                  controller:
                      widget.controller != null ? widget.controller : null,
                  onTap: () {
                    widget.unFocus();
                    setState(() {
                      FocusScope.of(context).requestFocus(widget.focusNode);
                    });
                  },
                  keyboardType:
                      widget.type != null ? widget.type : TextInputType.text,
                  cursorColor: widget.error != null ? Colors.red : bumbi,
                  onChanged: widget.onChanged,
                  focusNode: widget.focusNode,
                  obscureText: visiable ? false : true,
                  style: TextStyle(
                      color: blackAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: widget.error != null ? Colors.red : hint,
                        fontWeight: FontWeight.w600,
                        fontSize: widget.focusNode.hasPrimaryFocus ||
                                widget.error == null
                            ? 15
                            : 0),
                    hintText:
                        widget.error != null || widget.focusNode.hasPrimaryFocus
                            ? ""
                            : widget.label,
                    suffixIcon: widget.password
                        ? InkWell(
                            child: !visiable
                                ? Icon(
                                    Icons.visibility,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                  ),
                            onTap: () {
                              setState(() {
                                visiable = !visiable;
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                ),
          decoration: BoxDecoration(
              border: widget.error != null || widget.value == null
                  ? Border.all(color: Colors.red)
                  : null,
              boxShadow: widget.focusNode.hasPrimaryFocus
                  ? [
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
                    ]
                  : null,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        widget.error != null
            ? Container(
                padding: EdgeInsets.only(
                    right: widget.lang == "ar" ? 15 : 0,
                    left: widget.lang == "en" ? 15 : 0),
                child: AnimatedDefaultTextStyle(
                  duration: mill0Second,
                  style: TextStyle(
                      color: widget.error != null ? Colors.red : hint,
                      fontWeight: FontWeight.w600,
                      fontSize: widget.focusNode.hasPrimaryFocus ||
                              widget.error != null
                          ? 11
                          : 0),
                  child: Text(
                    widget.error,
                  ),
                ),
              )
            : SizedBox(),
        (widget.password && widget.forget != null)
            ? Align(
                alignment: widget.lang == "ar"
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  highlightColor: bumbiAccent.withOpacity(.5),
                  splashColor: Colors.red[50],
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgetPassword()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.forget,
                      style: TextStyle(
                          color: hint,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}

///// bottom bar item button
class AtelierBottomBarItem extends StatefulWidget {
  String title;
  Widget child;
  IconData icon;
  AtelierBottomBarItem({this.icon, this.child, this.title});
  @override
  _AtelierBottomBarItemState createState() => _AtelierBottomBarItemState();
}

class _AtelierBottomBarItemState extends State<AtelierBottomBarItem> {
  String selectedScreen() {
    if (widget.title == "الرئيسية")
      return "Home";
    else if (widget.title == "طلباتي")
      return "Orders";
    else if (widget.title == "الملف الشخصي")
      return "Profile";
    else if (widget.title == "المزيد")
      return "More";
    else
      return widget.title;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.selectedScreenStream,
      builder: (context, data) => Flexible(
        flex: (selectedScreen() == data.data && selectedScreen() == "Profile")
            ? 4
            : selectedScreen() == data.data ? 2 : 1,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: (selectedScreen() == data.data)
                    ? bumbiAccent
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            height: 40,
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                highlightColor: bumbiAccent.withOpacity(.5),
                splashColor: Colors.red[100],
                padding: EdgeInsets.all(0),
                clipBehavior: Clip.none,
                onPressed: () {
                  bloc.selectScreen(selectedScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: 5,
                    ),
                    Icon(
                      widget.icon,
                      color: (selectedScreen() == data.data) ? bumbi : hint,
                      size: 20,
                    ),
                    SizedBox(
                      height: 40,
                      width: 5,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          AnimatedOpacity(
                            duration: mill0Second,
                            opacity: (selectedScreen() == data.data) ? 1 : 0,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: (selectedScreen() == data.data)
                                      ? bumbi
                                      : hint,
                                  fontSize:
                                      (selectedScreen() == data.data) ? 13 : 0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ]),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////
class AtelierProviderBottomBarItem extends StatefulWidget {
  String title;
  Widget child;
  IconData icon;
  AtelierProviderBottomBarItem({this.icon, this.child, this.title});
  @override
  _AtelierProviderBottomBarItemState createState() =>
      _AtelierProviderBottomBarItemState();
}

class _AtelierProviderBottomBarItemState
    extends State<AtelierProviderBottomBarItem> {
  String selectedScreen() {
    if (widget.title == "عالم الأزياء")
      return "Fashion";
    else if (widget.title == "طلباتي")
      return "Orders";
    else if (widget.title == "الملف الشخصي")
      return "Profile";
    else if (widget.title == "المزيد")
      return "More";
    else
      return widget.title;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.selectedScreenStream,
      builder: (context, data) => Flexible(
        flex: (selectedScreen() == data.data && selectedScreen() == "Profile")
            ? 4
            : selectedScreen() == data.data ? 2 : 1,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: (selectedScreen() == data.data)
                    ? bumbiAccent
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            height: 40,
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                highlightColor: bumbiAccent.withOpacity(.5),
                splashColor: Colors.red[100],
                padding: EdgeInsets.all(0),
                clipBehavior: Clip.none,
                onPressed: () {
                  bloc.selectScreen(selectedScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: 5,
                    ),
                    widget.child != null
                        ? widget.child
                        : Icon(
                            widget.icon,
                            color:
                                (selectedScreen() == data.data) ? bumbi : hint,
                            size: 20,
                          ),
                    SizedBox(
                      height: 40,
                      width: 5,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          AnimatedOpacity(
                            duration: mill0Second,
                            opacity: (selectedScreen() == data.data) ? 1 : 0,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: (selectedScreen() == data.data)
                                      ? bumbi
                                      : hint,
                                  fontSize:
                                      (selectedScreen() == data.data) ? 13 : 0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ]),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
////////////////////

class LoadingFullScreen extends StatelessWidget {
  const LoadingFullScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: backGround.withOpacity(.3),
      // width: bloc.size().width,
      // height: bloc.size().height,
      child: Theme(
          data: ThemeData(accentColor: bumbi),
          child: CircularProgressIndicator()),
    );
  }
}

////////////////////
class BumbiCheckBox extends StatefulWidget {
  int id;
  BumbiCheckBox({this.id});
  @override
  _BumbiCheckBoxState createState() => _BumbiCheckBoxState();
}

class _BumbiCheckBoxState extends State<BumbiCheckBox> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.selectedPackageStream,
      builder: (context, s) => InkWell(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        onTap: () {
          setState(() {
            bloc.selectPackage(widget.id);
            print(bloc.selectedPackage());
          });
        },
        child: Container(
          width: 30,
          height: 30,
          child: s.data == widget.id
              ? Icon(
                  Icons.check,
                  size: 20,
                  color: bumbi,
                )
              : SizedBox(),
          decoration: BoxDecoration(
              color: bumbiAccent,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}

////////////////
class PackageCard extends StatelessWidget {
  SinglePackage package;
  bool history;
  String date;
  PackageCard(
      {
      this.package,
      this.date,
      this.history,
      });
  @override
  Widget build(BuildContext context) {
    String membership= AppLocalizations.of(context)
                                            .tr("payPackage.membership");
                                          String months=AppLocalizations.of(context)
                                            .tr("payPackage.months");
      
    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              onTap: date != null || history != null
                  ? null
                  : () {
                      bloc.selectPackage(package.id);
                    },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                height: date != null ? 120 : 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        date != null || history != null
                            ? SizedBox()
                            : BumbiCheckBox(
                                id: package.id,
                              ),
                        SizedBox(
                          width: date != null || history != null ? 12 : 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 0,
                            ),
                            Text(
                              package.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: date != null ? 20 : 16,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                               "$membership ${package.period} $months",
                              style: TextStyle(
                                  color: hint,
                                  fontSize: date != null ? 16 : 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            date != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 9),
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                          color: hint,
                                          fontSize: date != null ? 16 : 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                        "${package.price}",
                          style: TextStyle(
                              color: bumbi,
                              fontSize: date != null ? 46 : 22,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          AppLocalizations.of(context)
                                              .tr("payPackage.first.type"),
                          style: TextStyle(
                              color: bumbi,
                              fontSize: date != null ? 16 : 15,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////
class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

/////////// order card
class OrderCard extends StatelessWidget {
  Order order;
  OrderCard(
      {this.order,
     });
  GlobalKey card = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        // height: 120,
        onPressed: () {
          if (bloc.currentUser().type == "user") 
          {
            if(order.status=="waiting")
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewOrderPage(order: order,)));
              else if(order.status=="done")
                        Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AcceptedOrderPage(order: order,)));
              else
                        Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>RejectedOrderPage(order: order,)));
          } 
          else if (bloc.currentUser().type == "provider")
           {

            if(order.status=="waiting")
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProviderNewOrderPage(order: order,)));
              else if(order.status=="done")
                        Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>ProviderAcceptedOrderPage(order: order,)));
              else
                        Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>ProviderRejectedOrderPage(order: order,)));

           }

        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // image
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: bloc.lang() == "ar" ? 5 : 0,
                      right: bloc.lang() == "ar" ? 0 : 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child:
                    
                     FadeInImage(
                                    placeholder:AssetImage('assets/images/placeholder.gif'),

                          image:NetworkImage(order.product.images[0])
                              ,
                          fit: BoxFit.fill),
                  ),
                ),
              ],
            ),

            //
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Text(order.product.title,
                            style: TextStyle(
                                color: blackAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    SizedBox(height: 8,),

                    Wrap(
                      children: <Widget>[
                        Text("${AppLocalizations.of(context).tr("myOrders.orderNo")}  ${order.id}",
                            style: TextStyle(
                                color: blackAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                                        SizedBox(height: 8,),

                    Wrap(
                      children: <Widget>[
                        Text(order.product.user_name,
                            style: TextStyle(
                                color: hint,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
               order.status=="done"? Container(
                  width: 66,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: bloc.lang() == "ar" ? 10 : 0,
                      top: 10,
                      right: bloc.lang() == "ar" ? 0 : 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: order.paid ? bumbiAccent : hintAccent,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    order.paid?AppLocalizations.of(context).tr("myOrders.paied"):AppLocalizations.of(context).tr("myOrders.notPaied"),
                    style: TextStyle(
                        color: order.paid? bumbi : hint,
                        fontSize: 10,
                        fontWeight: FontWeight.w800),
                  ),
                ):SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }
}

///////////////// تتحط جوا كولوم بتتكون من مربع فيه اي حاجة وفوقه بوتوم شييت له هيدر وبودي
class DetailsWithCustomBottomSheet extends StatefulWidget {
  Widget detailsBody;
  Widget headerBottomSheet;
  Widget bodyBottomSheet;
  double spaceForHeader;
  DetailsWithCustomBottomSheet(
      {this.bodyBottomSheet,
      this.detailsBody,
      this.headerBottomSheet,
      this.spaceForHeader});
  @override
  _DetailsWithCustomBottomSheetState createState() =>
      _DetailsWithCustomBottomSheetState();
}

class _DetailsWithCustomBottomSheetState
    extends State<DetailsWithCustomBottomSheet> {
  GlobalKey bottomSheetBodyKey = GlobalKey();
  GlobalKey bottomSheetHeaderKey = GlobalKey();
  Size bottomSheetBodySize;
  Size bottomSheetHeaderSize;
  double bottom = 0;
  double bodyBottom = -500;
  double start = 0;
  double current = 0;
  double end = 0;
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
  }

  double height = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Color(0xffF9F9F9),
                child: widget.detailsBody),
            Stack(
              children: <Widget>[
                widget.headerBottomSheet,
                Positioned.fill(
                    child: Container(
                  color: backGround,
                ))
              ],
            )
          ],
        ),
        ///////////////////
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
                key: bottomSheetHeaderKey,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: bloc.size().width,
                child: widget.headerBottomSheet),
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
                  color: Colors.white,
                  alignment: Alignment.topRight,
                  ///////////// body
                  key: bottomSheetBodyKey,
                  child: widget.bodyBottomSheet),
            ),
            duration: mill000Second)
      ],
    );
  }
}
