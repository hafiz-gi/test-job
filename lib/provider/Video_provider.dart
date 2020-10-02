import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VideoProvider with ChangeNotifier{

  List _ge=[];
  String _selectedCategory;

  List get get {
    return [..._ge];
  }

  String get selectedCategory => _selectedCategory;

  getValue()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List get = prefs.getStringList('videoCount');

    _ge = get;

    notifyListeners();

  }

  getUnlockCategory()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedCategory = prefs.getString('unlockCategory');
    notifyListeners();
  }


}
