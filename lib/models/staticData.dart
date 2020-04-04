import 'package:atelier/blocs/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:atelier/blocs/bloc.dart';

class StaticData {
  String about;
  String terms;
  String mobile;
  String email;
  String f;
  String t;
  String s;
  StaticData(
      {this.about,
      this.email,
      this.f,
      this.mobile,
      this.s,
      this.t,
      this.terms});
  factory StaticData.fromJson(Map<String, dynamic> setting) {
    if (setting['status'] == 200)
      return StaticData(
          about: setting['data']['about'],
          email: setting['data']['email'],
          terms: setting['data']['terms'],
          mobile: setting['data']['mobile'],
          f: setting['data']['facebook'],
          t: setting['data']['twitter'],
          s: setting['data']['snap'] ?? setting['data']['insta']);
    else
      return StaticData(
          about: "", email: "", terms: "", mobile: "", f: "", t: "", s: "");
  }
}

Future staticData() async {
  http.Response response =
      await http.get("https://atelierapps.com/api/v1/setting");
  final staticData = json.decode(response.body);
  StaticData data = StaticData.fromJson(staticData);
  bloc.sendStaticData(data);
}

getContactTyps() async {
  http.Response response = await http.get(
      "https://atelierapps.com/api/v1/contact/reason",
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final reasonsData = json.decode(response.body);
  Map<int, String> reasons = {};
  if (reasonsData['status'] == 200) {
    for (int i = 0; i < reasonsData['data'].length; i++) {
      reasons[reasonsData['data'][i]['id']] = reasonsData['data'][i]['name'];
    }
  }
  bloc.addNewcontactTyps(reasons);
  return reasons;
}

contactUs(int id, String reason) async {
  http.Response response = await http.post(
      "https://atelierapps.com/api/v1/contact",
      body: {"reason_id": id.toString(), "message": reason},
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final reasonsData = json.decode(response.body);
  if (reasonsData['status'] == 200) {
    return "تم الإرسال";
  } else if (reasonsData['status'] == 401)
    return 401;
  else
    return reasonsData['msg'];
}

class SinglePackage {
  int id;
  int period;
  int price;
  String name;
  SinglePackage({this.price, this.id, this.name, this.period});
  factory SinglePackage.fromJson(Map<String, dynamic> pack) {
    return SinglePackage(
        id: pack['id'],
        period: pack['period'],
        price: pack['price'],
        name: pack['name']);
  }
}

Future packagesWidgets() async {
  http.Response response = await http
      .get("https://atelierapps.com/api/v1/package", headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final reasonsData = json.decode(response.body);
  List<SinglePackage> packages = [];
  if (reasonsData['data'] != null)
    for (int i = 0; i < reasonsData['data'].length; i++) {
      packages.add(SinglePackage.fromJson(reasonsData['data'][i]));
    }
  List<Widget> packWidgets = [];
  Map<int, SinglePackage> packMap = {};
  for (int i = 0; i < packages.length; i++) {
    packMap[packages[i].id] = packages[i];
    packWidgets.add(Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: PackageCard(package: packages[i]),
    ));
  }
  bloc.changepackages(packMap);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: packWidgets,
  );
}

Future packagesHistoryWidgets() async {
  http.Response response = await http
      .get("https://atelierapps.com/api/v1/package", headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final reasonsData = json.decode(response.body);
  List<SinglePackage> packages = [];
  if (reasonsData['data'] != null)
    for (int i = 0; i < reasonsData['data'].length; i++) {
      packages.add(SinglePackage.fromJson(reasonsData['data'][i]));
    }
  List<Widget> packWidgets = [];
  Map<int, SinglePackage> packMap = {};
  for (int i = 0; i < packages.length; i++) {
    packMap[packages[i].id] = packages[i];
  if(packages[i].id==bloc.currentUser().package_id)  packWidgets.add(Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: PackageCard(
        package: packages[i],
        date: "",
      ),
    ));
  }
  // bloc.changepackages(packMap);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: packWidgets,
  );
}
