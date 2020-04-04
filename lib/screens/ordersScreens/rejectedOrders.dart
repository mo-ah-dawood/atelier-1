import 'package:atelier/blocs/widgets.dart';
import 'package:atelier/models/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RejectedOrders extends StatefulWidget {
  @override
  _RejectedOrdersState createState() => _RejectedOrdersState();
}

class _RejectedOrdersState extends State<RejectedOrders> {
  List<Widget> orders=[LoadingFullScreen()];
 void _getAllRejectedOrders()async{
    List<Widget> orderCards= await getAllOrdersOfStatus("cancelled", context);
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
_getAllRejectedOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        onRefresh: (){_getAllRejectedOrders();},
            header: BezierCircleHeader(),
            controller: _refreshController,
            enablePullDown: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: orders
            ),
          ),
        ),
      ),
    );
  }
}

