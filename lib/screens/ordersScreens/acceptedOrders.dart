import 'package:atelier/models/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AcceptedOrders extends StatefulWidget {
  @override
  _AcceptedOrdersState createState() => _AcceptedOrdersState();
}

class _AcceptedOrdersState extends State<AcceptedOrders> {
      List<Widget> orders=[LoadingFullScreen()];
 getAllAcceptedOrders()async{
    List<Widget> orderCards= await getAllOrdersOfStatus("done", context);
      if(mounted)
    setState(() {
      orders=orderCards;
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

  }
    RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
getAllAcceptedOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        onRefresh: ()async{
          await getAllAcceptedOrders();},
            header: BezierCircleHeader(),
            controller: _refreshController,
            enablePullDown: true,
        child:SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children:orders,
        ),
      ),
    )));
  }
}

