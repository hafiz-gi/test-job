import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final _fireStore = Firestore.instance;

class FootballProvider with ChangeNotifier{

  List<Football> _footballList=[];

  List<Football> get footballList {
    return [..._footballList];
  }


  fetchData(String category)async{
    final list = await _fireStore.collection('Collection').where('category', isEqualTo: category).getDocuments();
    final List<Football> sample = [];
    list.documents.forEach((element) {
      sample.add(Football(
        videoUrl: element.data['videoUrl'],
        category: element.data['category'],
        likes: element.data['likes'],
      ));
    });
    _footballList = sample;

    notifyListeners();
  }
}


class Football  {

  final String videoUrl;
  final String category;
  final String likes;

  Football({
    this.videoUrl,this.category,this.likes
  });

}