import 'package:atelier/blocs/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
class Package{
  int id;
  int period;
  int price;
  String name;
  Package({this.id,this.name,this.period,this.price});
  factory Package.fromJson(Map<String,dynamic> package){
    return Package(
      id: package['id'],
      period: package['period'],
      name: package['name'],
      price: package['price']
    );
  }
 }
  List<Package> allPackages(List<Map<String,dynamic>> packages){
    List<Package> all=[];
    for(int i=0;i<packages.length;i++)
    all.add(Package.fromJson(packages[i]));
    return all;
  }
  Package currentPackage(Map<String,dynamic> pack){
  if(pack['current']!=null||pack['current']!="null")
    return Package.fromJson(pack['current']);
  else return null;
  }
  Future getPackagesDetails() async {
  http.Response response = await http
      .get("https://atelierapps.com/api/v1/package", headers: {
    "apiToken": "sa3d01${bloc.currentUser().apiToken}",
    "lang": bloc.lang() ?? "ar"
  });
  final packages = json.decode(response.body);
if(packages['status']==200){

}
else 
return null;
}
