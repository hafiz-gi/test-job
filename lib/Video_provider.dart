import 'package:flutter/material.dart';

class VideoProvider with ChangeNotifier{

  String category = 'animals';


  // String get cate =>category;

  add(String cat){
    category = cat;
    notifyListeners();
  }

  int counter;

  int get cou =>counter;

  count(int count){

    counter = count++;

    notifyListeners();
  }
}
