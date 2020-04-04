import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// add methods
Future addSharedString(String key,String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
Future addSharedInt(String key,int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}
Future addSharedBool(String key,bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}
Future addSharedDouble(String key,double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, value);
}
Future addSharedListOfString(String key,List<String> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}
// get methods
Future<String> getSharedStringOfKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString(key);
  return stringValue;
}
Future getSharedBoolOfKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool boolValue = prefs.getBool(key);
  return boolValue;
}
Future getSharedIntOfKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int intValue = prefs.getInt(key);
  return intValue;
}
Future getSharedDoubleOfKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double doubleValue = prefs.getDouble(key);
  return doubleValue;
}
Future<List<String>> getSharedListOfStringOfKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> listOfString = prefs.getStringList(key);
  return listOfString;
}
Future<Set<String>> getSharedKeys() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> keys = prefs.getKeys();
  return keys;
}
// remove methods
Future removeSharedOfKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
Future removeAllShared() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}