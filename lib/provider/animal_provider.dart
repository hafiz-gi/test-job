import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final _fireStore = Firestore.instance;

class AnimalProvider with ChangeNotifier{

  List<Animal> _animalList=[];

  List<Animal> get animalList {
    return [..._animalList];
  }


  fetchData(String category)async{
     final list = await _fireStore.collection('Collection').where('category', isEqualTo: category).getDocuments();
     final List<Animal> sample = [];
     list.documents.forEach((element) {
       sample.add(Animal(
         videoUrl: element.data['videoUrl'],
         category: element.data['category'],
         likes: element.data['likes'],
       ));
     });
     _animalList = sample;
     notifyListeners();
  }
}


class Animal  {

  final String videoUrl;
  final String category;
  final String likes;

  Animal({
    this.videoUrl,this.category,this.likes
});

}