import 'package:atelier/models/articleModel.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/Fashion.dart';
import 'package:atelier/screens/home/addDress.dart';
import 'package:atelier/screens/home/home.dart';
import 'package:atelier/screens/more/more.dart';
import 'package:atelier/screens/home/profileSetting.dart';
import 'package:atelier/screens/ordersScreens/acceptedOrders.dart';
import 'package:atelier/screens/ordersScreens/newOrders.dart';
import 'package:atelier/screens/ordersScreens/rejectedOrders.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/design.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:bubble_animated_tabbar/bubble_animated_tabbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'notifications.dart';

class AtelierProviderCenter extends StatefulWidget {
  int index;
  int screen;
  AtelierProviderCenter({this.index, this.screen});
  @override
  _AtelierProviderCenterState createState() => _AtelierProviderCenterState();
}

class _AtelierProviderCenterState extends State<AtelierProviderCenter>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    
bloc.newNotifichation==null?bloc.changenewNotifichation(false):bloc.changenewNotifichation(bloc.newNotifichation);
    bloc.changeCloseFilters(true);
    bloc.onDressNameChange(null);
    bloc.onDressPriceChange(null);
    bloc.onDressDescripChange(null);
    bloc.selectFilter(0);
    screen = widget.screen != null ? widget.screen : 0;
    _currentIndex = widget.index != null ? widget.index : 0;
    _tabController =
        TabController(vsync: this, length: 3, initialIndex: _currentIndex);
    super.initState();
  }

  TabController _tabController;
  int screen;
  int _currentIndex;
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  PersistentBottomSheetController _controller; // <------ Instance variable
  @override
  Widget build(BuildContext context) {
    List<Map> bottomBar = bottomBarChildrens(context, bloc.currentUser().type);
    Size size = MediaQuery.of(context).size;
    double safe = MediaQuery.of(context).padding.top;
    bloc.setDeviceSize(Size(size.width, size.height - safe));
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: () {
          return bloc.onWillPop(context);
        },
        child: Stack(
          children: <Widget>[
            Scaffold(
              /// appBar
              appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: Text(bottomBar[screen]['title']),
                  actions: <Widget>[
                    screen == 0
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: StreamBuilder(
                                  stream: bloc.newNotifichationStream,
                                  builder: (context, notify) =>
                                      notify.data == true
                                          ? BumbiIconButton(
                                              onPressed: () {
                                                                                                bloc.changenewNotifichation(false);

                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Notifications()));
                                              },
                                              iconData: Icons.notifications_active,
                                            )
                                          : BumbiIconButton(
                                              onPressed: () {
                                                bloc.changenewNotifichation(false);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Notifications()));
                                              },
                                              iconData: Icons.notifications,
                                            ),
                                )),
                          )
                        : screen == 1
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: BumbiIconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileSetting(
                                                      provider: true,
                                                    )));
                                      },
                                      iconData: Icons.settings,
                                    )),
                              )
                            : screen == 2
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: BumbiIconButton(
                                          onPressed: () async {
                                            if (bloc.categories() != null)
                                              bloc.changeCloseFilters(
                                                  !bloc.closeFilters);
                                          },
                                          iconData: Icons.tune,
                                        )),
                                  )
                                : SizedBox()
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(_currentIndex != 0 ? 10 : 25),
                          bottomRight:
                              Radius.circular(_currentIndex != 0 ? 10 : 25))),
                  ////tab bar
                  bottom: screen != 0
                      ? null
                      : myOrdersTabBar(context, _tabController)),

              /// bottom bar
              bottomNavigationBar: AnimatedTabbar(
                children: bottomBar,
                currentIndex: screen,
                containerDecoration: getBoxDecoration(),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                onTap: (a) {
                  setState(() {
                    screen = a;
                  });
                },
              ),

              /// body
              body: Container(
                constraints: BoxConstraints(minWidth: size.width),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Scaffold(
                      body: Container(
                        child: screen == 0
                            ? TabBarView(
                                controller: _tabController,
                                children: [
                                  NewOrders(),
                                  AcceptedOrders(),
                                  RejectedOrders()
                                ],
                              )
                            : (screen == 1
                                ? ProviderProfile()
                                : (screen == 2
                                    ? Fashion(
                                        scaffold: scaffold,
                                        controller: _controller,
                                      )
                                    : More())),
                      ),
                    ),
                    screen == 1
                        ? Positioned(
                            left: bloc.lang() == "ar" ? 25 : null,
                            right: bloc.lang() == "ar" ? null : 25,
                            bottom: 20,
                            child: BumbiIconButton(
                              color: bumbi,
                              child: Container(
                                width: 30,
                                height: 30,
                                child: MaterialButton(
                                  highlightColor: bumbiAccent.withOpacity(0.2),
                                  highlightElevation: 2,
                                  splashColor: bumbiAccent.withOpacity(.3),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    bloc.onDressNameChange(null);
                                    bloc.onMobileChange(
                                        null); /////////////////////////

                                    bloc.onDressPriceChange(null);
                                    bloc.onDressDescripChange(null);
                                    bloc.onDressImagesChange(null);

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => AddDress()));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Image.asset(
                                    'assets/images/add_dress.png',
                                    width: 40,
                                    height: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          )
                        : SizedBox(),
                    StreamBuilder<bool>(
                      stream: bloc.closeFiltersStream,
                      initialData: true,
                      builder: (context, s) => AnimatedPositioned(
                          bottom: s.data ? -500 : 0,
                          child: Filter(scaffold, _controller),
                          duration: mill0Second),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
TabBar myOrdersTabBar(BuildContext context, TabController _tabController) {
  return TabBar(
    labelStyle: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Tajawal"),
    controller: _tabController,
    tabs: [
      Tab(
        text: AppLocalizations.of(context).tr("myOrders.new"),
      ),
      Tab(
        text: AppLocalizations.of(context).tr("myOrders.accepted"),
      ),
      Tab(
        text: AppLocalizations.of(context).tr("myOrders.rejected"),
      ),
    ],
    labelColor: blackAccent,
    indicator: CircleTabIndicator(color: blackAccent, radius: 3),
    unselectedLabelColor: hint,
    unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 15, fontFamily: "Tajawal"),
    indicatorSize: TabBarIndicatorSize.label,
    indicatorWeight: 3,
    indicatorColor: blackAccent,
  );
}

////////////////////////////////////////////////////////////////
List<Map> bottomBarChildrens(BuildContext context, String type) {
  List<Map> userBottomBar = [
    {
      'icon': Icons.home,
      'title': AppLocalizations.of(context).tr("bottomBar.home"),
      'iconSize': 23,
      'color': bumbiAccent,
      'textColor': bumbi,
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
    },
    {
      'icon': Icons.local_mall,
      'title': AppLocalizations.of(context).tr("bottomBar.orders"),
      'color': bumbiAccent,
      'textColor': bumbi,
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
    },
    {
      'icon': Icons.person,
      'title': AppLocalizations.of(context).tr("bottomBar.profile"),
      'color': bumbiAccent,
      'textColor': bumbi,
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
    },
    {
      'icon': Icons.more_horiz,
      'title': AppLocalizations.of(context).tr("bottomBar.more"),
      'iconSize': 23,
      'color': bumbiAccent,
      'textColor': bumbi,

      // 'textColor': Color.fromRGBO(173, 118, 23, 1),
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
    },
  ];
  List<Map> providerBottomBar = [
    {
      'icon': Icons.local_mall,
      'title': AppLocalizations.of(context).tr("bottomBar.orders"),
      'color': bumbiAccent,
      'textColor': bumbi,
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
    },
    {
      'icon': Icons.person,
      'title': AppLocalizations.of(context).tr("bottomBar.profile"),
      'color': bumbiAccent,
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
      'textColor': bumbi,
    },
    {
      'icon': Icons.bubble_chart,
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
      'title': AppLocalizations.of(context).tr("bottomBar.fashion"),
      'color': bumbiAccent,
      'textColor': bumbi,
    },
    {
      'icon': Icons.more_horiz,
      'title': AppLocalizations.of(context).tr("bottomBar.more"),
      'color': bumbiAccent,
      'customTextStyle': TextStyle(color: bumbi, fontWeight: FontWeight.w700),
      'textColor': bumbi,
    },
  ];

  return type == "user" ? userBottomBar : providerBottomBar;
}

class ProviderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25))),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 140,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    constraints: BoxConstraints(
                        maxWidth: bloc.size().width / 3,
                        maxHeight: bloc.size().height / 5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: FadeInImage(
                          placeholder:
                              AssetImage('assets/images/placeholder.gif'),
                          image: NetworkImage(bloc.currentUser().image != null
                              ? bloc.currentUser().image
                              : ""),
                        )),
                  ),
                ),
                Text(
                  bloc.currentUser().name != null
                      ? bloc.currentUser().name
                      : "دار أزياء",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RatingBar(
                  initialRating: double.parse(bloc.currentUser().rate ?? "0"),
                  minRating: 1,
                  glow: false,
                  textDirection: TextDirection.ltr,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 18,
                  ignoreGestures: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  bloc.currentUser().mobile == null
                      ? "+9665214551"
                      : bloc.currentUser().mobile,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: hint),
                ),
                bloc.currentUser().site_url != null
                    ? Text(
                        bloc.currentUser().site_url,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: hint),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.only(right: 20, top: 10, left: 20),
            alignment:
                bloc.lang() == "ar" ? Alignment.topRight : Alignment.topLeft,
            child: Text(
              AppLocalizations.of(context).tr("profile.myProducts"),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: hint),
            ),
          ),
          FutureBuilder(
            future:
                getProviderProducts(bloc.currentUser().id, context, mine: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return LoadingFullScreen();
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data.length < 1)
                return Container(
                  margin: EdgeInsets.only(top: 6),
                  width: bloc.size().width - 40,
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).tr("myProduct.emptyDress"),
                        style: TextStyle(
                            color: blackAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              else
                return Container(
                  margin: EdgeInsets.only(top: 6),
                  width: bloc.size().width - 40,
                  height: (30 + bloc.size().width / 2) *
                      ((snapshot.data.length / 2).ceil()),
                  child: GridView.count(
                    childAspectRatio: .8,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    children: snapshot.data,
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////// filter
class Filter extends StatefulWidget {
  PersistentBottomSheetController _controller; // <------ Instance variable
  GlobalKey<ScaffoldState> scaffold;
  Filter(this.scaffold, this._controller);
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: bloc.size().width,
          color: Colors.transparent,
          child: Container(
              width: bloc.size().width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45))),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                          child: Text(
                              AppLocalizations.of(context).tr("comments.view"),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                      SizedBox(
                        height: 10,
                      ),
                      FiltersButtons(
                          [AppLocalizations.of(context).tr("comments.all")],
                          widget.scaffold,
                          widget._controller)
                    ],
                  ))),
        ),
      ],
    );
  }
}

class FiltersButtons extends StatefulWidget {
  List<String> filters;
  GlobalKey<ScaffoldState> scaffold;
  PersistentBottomSheetController _controller; // <------ Instance variable
  FiltersButtons(this.filters, this.scaffold, this._controller);

  @override
  _FiltersButtonsState createState() => _FiltersButtonsState();
}

class _FiltersButtonsState extends State<FiltersButtons> {
  List<Widget> filters = [];
  List<Widget> filtersWidgets = [];
  List<Widget> fashionCard = [];
  refreshFiltersColumn() {
    setState(() {
      List<String> filt = [];
      filt.clear();
      filt.add(widget.filters[0]);
      for (int i = 0; i < bloc.categories().length; i++) {
        filt.add(bloc.categories()[i].name);
      }
      filters.clear();
      for (int i = 0; i < filt.length; i++) {
        filters.add(Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () async {
              setState(() {
                bloc.selectFilter(i);
              });
              List<Widget> cards = [];
              bloc.updateFasionCards([LoadingFullScreen()]);
              cards = await getAllArticles(
                  category: bloc.selectedFilter(), context: context);
              if (mounted) bloc.updateFasionCards(cards);
              bloc.changeCloseFilters(true);
              //  widget._controller.close();
            },
            child: Row(
              children: <Widget>[
                Icon(
                  bloc.selectedFilter() == i
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: bumbi,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(filt[i],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: bloc.selectedFilter() == i
                            ? FontWeight.bold
                            : FontWeight.w600))
              ],
            ),
          ),
        ));
        filtersWidgets = filters;
      }
    });
  }

  @override
  void initState() {
    refreshFiltersColumn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      filtersWidgets.clear();
      refreshFiltersColumn();
    });
    return Column(
      children: filtersWidgets,
    );
  }
}
