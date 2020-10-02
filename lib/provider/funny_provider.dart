import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final _fireStore = Firestore.instance;

class FunnyProvider with ChangeNotifier{

  List<Funny> _funnyList=[];

  List<Funny> get funnyList {
    return [..._funnyList];
  }


  fetchData(String category)async{
    print(category);
    final list = await _fireStore.collection('Collection').where('category', isEqualTo: category).getDocuments();
    final List<Funny> sample = [];
    list.documents.forEach((element) {
      print(element.data['videoUrl']);
      sample.add(Funny(
        videoUrl: element.data['videoUrl'],
        category: element.data['category'],
        likes: element.data['likes'],
      ));
    });
    _funnyList = sample;

    notifyListeners();
  }
}


class Funny  {

  final String videoUrl;
  final String category;
  final String likes;

  Funny({
    this.videoUrl,this.category,this.likes
  });

}