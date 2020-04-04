import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/models/providerModel.dart';
import 'package:atelier/screens/home/home.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<Map<String, List>> refreshHome(BuildContext context) async {
  List<Product> special = [];
  List<Product> used = [];
  List<ProviderModel> providers = [];
  Map<String, List<Widget>> homeData = {};
  /*headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  } */
  http.Response response =
      await http.get("https://atelierapps.com/api/v1/home");
  final homeJson = json.decode(response.body);
  if (homeJson['status'] == 200) {
    if (homeJson['data']['providers_array'].length > 0) {
      for (int i = 0; i < homeJson['data']["providers_array"].length; i++)
        providers.add(
            ProviderModel.fromHomeJson(homeJson['data']["providers_array"][i]));
    }
    if (homeJson['data']["special_products_array"].length > 0) {
      for (int i = 0;
          i < homeJson['data']["special_products_array"].length;
          i++)
        special.add(Product.fromHomeJson(
            homeJson['data']["special_products_array"][i]));
    }
    if (homeJson['data']["used_products_array"].length > 0) {
      for (int i = 0; i < homeJson['data']["used_products_array"].length; i++)
        used.add(
            Product.fromHomeJson(homeJson['data']["used_products_array"][i]));
    }

    homeData['special'] = [];
    homeData['used'] = [];
    homeData['providers'] = [];
    for (int i = 0; i < providers.length; i++)
      homeData['providers'].add(HouseCard(
        provider: providers[i],
      ));
    for (int i = 0; i < special.length&&i<4; i++)
      homeData['special'].add(HouseCard(product: special[i]));
    for (int i = 0; i < used.length; i++)
      homeData['used'].add(HouseCard(product: used[i]));
    return homeData;
  }else
  if(homeJson['status']==401){
    await clearUserData();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  }
   else {
    homeData['special'] = [];
    homeData['used'] = [];
    homeData['providers'] = [];
    return homeData;
  }
}
