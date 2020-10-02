import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final _fireStore = Firestore.instance;

class MusicProvider with ChangeNotifier{

  List<Music> _musicList=[];

  List<Music> get musicList {
    return [..._musicList];
  }


  fetchData(String category)async{
    final list = await _fireStore.collection('Collection').where('category', isEqualTo: category).getDocuments();
    final List<Music> sample = [];
    list.documents.forEach((element) {
      sample.add(Music(
        videoUrl: element.data['videoUrl'],
        category: element.data['category'],
        likes: element.data['likes'],
      ));
    });
    _musicList = sample;

    notifyListeners();
  }
}


class Music  {

  final String videoUrl;
  final String category;
  final String likes;

  Music({
    this.videoUrl,this.category,this.likes
  });

}