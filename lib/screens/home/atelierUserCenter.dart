import 'package:atelier/blocs/design.dart';
import 'package:atelier/screens/home/notifications.dart';
import 'package:atelier/screens/home/profileSetting.dart';
import 'package:atelier/screens/ordersScreens/acceptedOrders.dart';
import 'package:atelier/screens/ordersScreens/newOrders.dart';
import 'package:atelier/screens/ordersScreens/rejectedOrders.dart';
import 'package:bubble_animated_tabbar/bubble_animated_tabbar.dart';

import 'home.dart';
import '../more/more.dart';
import 'profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/blocs/widgets.dart';

class AtelierCenter extends StatefulWidget {
  // String screen;
  // AtelierCenter({this.screen});
  int index;
  int screen;
  AtelierCenter({this.index,this.screen});
  @override
  _AtelierCenterState createState() => _AtelierCenterState();
}

class _AtelierCenterState extends State<AtelierCenter>
    with SingleTickerProviderStateMixin {
  // @override
  // void initState() {
  //   bloc.selectScreen(widget.screen != null ? widget.screen : "Home");
  //   super.initState();
  // }
  TabController _tabController;
  int _currentIndex;
int screen;
  @override
  void initState() {
    bloc.newNotifichation==null?bloc.changenewNotifichation(false):bloc.changenewNotifichation(bloc.newNotifichation);

            bloc.onDressNameChange(null);
      bloc.onDressPriceChange(null);
      bloc.onDressDescripChange(null); 
    screen=widget.screen!=null?widget.screen:0;
        _currentIndex=widget.index!=null?widget.index:0;
    _tabController = TabController(vsync: this, length: 3, initialIndex:_currentIndex);
    super.initState();
  }

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
            child: SafeArea(
                child: Scaffold(

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
                              : screen == 2
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
                                                            provider: false,
                                                          )));
                                            },
                                            iconData: Icons.settings,
                                          )),
                                    )
                                  : SizedBox()
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    screen != 1 ? 0 : 25),
                                bottomRight: Radius.circular(
                                    screen != 1 ? 0 : 25))),
                        ////tab bar
                        bottom: screen != 1
                            ? null
                            : myOrdersTabBar(context, _tabController)),

                    /// bottom bar
                    bottomNavigationBar: AnimatedTabbar(
                      children: bottomBar,
                      currentIndex: screen,
                      containerDecoration: getBoxDecoration(),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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
                                child: screen == 1
                                    ? TabBarView(
                                        controller: _tabController,
                                        children: [
                                          NewOrders(),
                                          AcceptedOrders(),
                                          RejectedOrders()
                                        ],
                                      )
                                    : screen == 2
                                        ? Profile()
                                        : screen == 0
                                            ? Home()
                                            : More(),
                              ))
                            ]))))));
  }
}

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

// Scaffold(
//             body: Container(
//               child: Stack(
//                 alignment: Alignment.topCenter,
//                 children: <Widget>[
//                   StreamBuilder(
//                     stream: bloc.selectedScreenStream,
//                     builder: (context, data) {
//                       if (data.data == "Orders")
//                         return Orders();
//                       else if (data.data == "Profile")
//                         return Profile();
//                       else if (data.data == "More")
//                         return More();
//                       else
//                         return Home();
//                     },
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 40),
//                         width: MediaQuery.of(context).size.width,
//                         height: 80,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(40),
//                                 topRight: Radius.circular(40)),
//                             color: Colors.white),
//                         child: Row(
//                           children: <Widget>[
//                             AtelierBottomBarItem(
//                               title: AppLocalizations.of(context)
//                                   .tr("bottomBar.home"),
//                               icon: Icons.home,
//                             ),
//                             AtelierBottomBarItem(
//                               title: AppLocalizations.of(context)
//                                   .tr("bottomBar.orders"),
//                               icon: Icons.local_mall,
//                             ),
//                             AtelierBottomBarItem(
//                               title: AppLocalizations.of(context)
//                                   .tr("bottomBar.profile"),
//                               icon: Icons.person,
//                             ),
//                             AtelierBottomBarItem(
//                               title: AppLocalizations.of(context)
//                                   .tr("bottomBar.more"),
//                               icon: Icons.more_horiz,
//                             ),
//                           ],
//                         )),
//                   )
//                 ],
//               ),
//             ),
// ),
