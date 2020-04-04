import 'package:atelier/models/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:atelier/blocs/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class NewOrders extends StatefulWidget {
  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
    List<Widget> orders=[LoadingFullScreen()];
 getAllNewOrders()async{
    List<Widget> orderCards= await getAllOrdersOfStatus("waiting", context);
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
getAllNewOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        onRefresh: ()async{
          await getAllNewOrders();},
            header: BezierCircleHeader(),
            controller: _refreshController,
            enablePullDown: true,
        child:SingleChildScrollView(
        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            child: Column(
                              children:orders
                            ),
                          ),
      ),
    ));
  }
}
