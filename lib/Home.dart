
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Video/MusicVideo.dart';
import 'Video/animalVideos.dart';
import 'provider/Video_provider.dart';
import 'Video/footballVideo.dart';
import 'Video/funnyVideo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categoryList = ['animals', 'football', 'funny', 'music'];

  int _index = 0;
  String _category = 'animals';

  @override
  Widget build(BuildContext context) {
    Provider.of<VideoProvider>(context, listen: false).getValue();
    Provider.of<VideoProvider>(context, listen: false).getUnlockCategory();
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .9,
            child: selectionCheck(_category),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            color: Colors.black,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _index = index;
                          _category = categoryList[index];
                        });
                      },
                      child: Text(
                        categoryList[index],
                        style: TextStyle(
                            color:
                                (_index == index) ? Colors.white : Colors.grey,
                            fontSize: 20),
                      ),
                    ),
                  ));
                }),
          ),
        ],
      ),
    );
  }

  selectionCheck(String category) {
    final _data = Provider.of<VideoProvider>(context, listen: false);
    if (category == 'animals') {
      return AnimalStream(
        category: category,
      );
    }
    // if (category == 'football') {
    //   return FootballStream(
    //     category: category,
    //   );
    // }
    // if (category == 'funny') {
    //   return FunnyStream(
    //     category: category,
    //   );
    // }
    // if (category == 'music') {
    //   return MusicStream(
    //     category: category,
    //   );
    // }

    if (_data.selectedCategory == category && _data.get.length == 5) {
      return FootballStream(
        category: category,
      );
    }
    if (_data.selectedCategory == category && _data.get.length == 5) {
      print(_data.selectedCategory );
      return FunnyStream(
        category: category,
      );
    }
    if (_data.selectedCategory == category && _data.get.length == 5) {
      return MusicStream(
        category: category,
      );
    }
    return Center(child: Text('Lock Category'));
  }
}
