import 'dart:async';
import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/screens/home/notifications.dart';
import 'package:atelier/screens/ordersScreens/acceptedOrderPage.dart';
import 'package:atelier/screens/ordersScreens/newOrderPage.dart';
import 'package:atelier/screens/ordersScreens/providerAcceptedOrderPage.dart';
import 'package:atelier/screens/ordersScreens/providerNewOrderPage.dart';
import 'package:atelier/screens/ordersScreens/providerRejectedOrderPage.dart';
import 'package:atelier/screens/ordersScreens/rejectedOrderPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:atelier/models/orderModel.dart';

class NotificationModel {
  int id;
  Order order;
  String title;
  String note;
  NotificationModel({this.id, this.note, this.title, this.order});
  factory NotificationModel.fromJson(Map<String, dynamic> notification) {
    try {
      return NotificationModel(
        id: notification['id'],
        title: notification['title'],
        note: notification['note'],
        order: notification['order'] != null
            ? Order.fromJson(notification['order'])
            : null,
      );
    } catch (e) {
      print(e);
      return NotificationModel();
    }
  }
}

Future<Map<String, dynamic>> getAllNotifications() async {
  http.Response response = await http.get(
      "https://atelierapps.com/api/v1/notification",
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final notification = json.decode(response.body);
  return notification;
}

Future<List<Widget>> getNotificationCards(BuildContext context) async {
  List<NotificationCard> notificationCards = [];
  List<NotificationModel> notiModel = [];
  Map<String, dynamic> allNotifications = await getAllNotifications();
  if (allNotifications['status'] == 200) {
    for (int i = 0; i < allNotifications['data'].length; i++) {
      notiModel.add(NotificationModel.fromJson(allNotifications['data'][i]));
    }
    for (int i = 0; i < notiModel.length; i++) {
      notificationCards.add(NotificationCard(
        text: notiModel[i].title,
        event: notiModel[i].note,
        onPressed: () {
          if (bloc.currentUser().type == "user") {
            if (notiModel[i].order == null) {
            } else if (notiModel[i].order.status == "waiting")
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewOrderPage(
                        order: notiModel[i].order,
                      )));
            else if (notiModel[i].order.status == "done")
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AcceptedOrderPage(
                        order: notiModel[i].order,
                      )));
            else if (notiModel[i].order.status == "cancelled")
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RejectedOrderPage(
                        order: notiModel[i].order,
                      )));
          } else if (bloc.currentUser().type == "provider") {
            if (notiModel[i].order == null) {
            } else if (notiModel[i].order.status == "waiting")
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProviderNewOrderPage(
                        order: notiModel[i].order,
                      )));
            else if (notiModel[i].order.status == "done")
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProviderAcceptedOrderPage(
                        order: notiModel[i].order,
                      )));
            else if (notiModel[i].order.status == "cancelled")
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProviderRejectedOrderPage(
                        order: notiModel[i].order,
                      )));
          }
        },
      ));
    }
    return notificationCards;
  } else
    return notificationCards;
}
