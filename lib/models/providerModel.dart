import 'package:atelier/blocs/bloc.dart';
import 'package:atelier/models/productModel.dart';
import 'package:atelier/screens/home/home.dart';
import 'package:atelier/screens/login&signUp/splach.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ProviderModel {
  int status;

  int id;
  String name;
  String rate;
  String type;
  String mobile;
  String email;
  String note;
  String site_url;
  String image;
  int package_id;
  List<Map<String, dynamic>> products;
  ProviderModel(
      {this.name,
      this.id,
      this.email,
      this.note,
      this.site_url,
      this.rate,
      this.image,
      this.mobile,
      this.package_id,
      this.products,
      this.status,
      this.type});
factory ProviderModel.fromCommentson(Map<String, dynamic> providerJson) {
    try {
      return ProviderModel(
          id: providerJson['id'],
          rate: providerJson['rate'],
          email: providerJson['email']  ,
          image: providerJson['image'],
          mobile: providerJson['mobile'],
          name: providerJson['name'],
          type: providerJson['type']);
    } catch (e) {
      print(e);
    }
    return null;
  }
  factory ProviderModel.fromHomeJson(Map<String, dynamic> providerJson) {
    try {
      return ProviderModel(
          id: providerJson['id'],
          rate: providerJson['rate'],
          note:providerJson['note']  ,
          email: providerJson['email']  ,
          site_url: providerJson['site_url'] ,
          image: providerJson['image'],
          mobile: providerJson['mobile'],
          name: providerJson['name'],
          package_id: providerJson['package_id'],
          type: providerJson['type']);
    } catch (e) {
      print(e);
    }
    return null;
  }
  factory ProviderModel.fromJson(Map<String, dynamic> providerJson) {
    try {
      if (providerJson['status'] == 200)
        return ProviderModel(
            id: providerJson['data']['id'],
            rate: providerJson['data']['rate'],
          note:providerJson['note'] ,
          email: providerJson['email'],
          site_url: providerJson['site_url'] ,
            image: providerJson['data']['image'] ,
            mobile: providerJson['data']['mobile'],
            name: providerJson['data']['name'] ,
            package_id: providerJson['data']['package_id'],
            type: providerJson['data']['type'],
            products: providerJson['products']);
    } catch (e) {
      print(e);
    }
    return null;
  }
}

Future<List<Widget>> getProviderProducts(int id,BuildContext context,{bool mine}) async {
  List<Widget> products = [];
  http.Response response = await http.get(
      "https://atelierapps.com/api/v1/user/$id",
      headers: {"apiToken": "sa3d01${bloc.currentUser().apiToken}"});
  final productJson = json.decode(response.body);
  if (productJson['status'] == 200) {
    List allProducts = productJson['products'];
    for (int i = 0; i < allProducts.length; i++)
     {
       if(allProducts[i]['user']['name']!=null&&mine==true)
        products.add(HouseCard(
          mine: mine,
          fromproviderPage: true,
        product: Product.fromProviderJson(allProducts[i]),
      ));
      else
       if(allProducts[i]['user']['name']!=null)
        products.add(HouseCard(
          fromproviderPage: true,
        product: Product.fromProviderJson(allProducts[i]),
      ));
      
      }
    return products;
  }
  else
  if(productJson['status']==401){
    await clearUserData();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splach()));
  } else
    return products;
}

Future<List<Widget>> getAllProviders() async {
  List<Widget> providers = [];
  http.Response response =
      await http.get("https://atelierapps.com/api/v1/providers");
  final providersJson = json.decode(response.body);
  if (providersJson['status'] == 200) {
    List allProviders = providersJson['data'];
    for (int i = 0; i < allProviders.length; i++)
      providers.add(HouseCard(
        provider: ProviderModel.fromHomeJson(allProviders[i]),
      ));
    return providers;
  } else
    return providers;
}
