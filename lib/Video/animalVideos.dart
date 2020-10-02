import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_job/provider/animal_provider.dart';
import 'package:video_player/video_player.dart';



class AnimalStream extends StatefulWidget {

final String category;
AnimalStream({this.category});

  @override
  _AnimalStreamState createState() => _AnimalStreamState();
}
class _AnimalStreamState extends State<AnimalStream> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    print(widget.category);
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size ;

    return FutureBuilder(
      future: Provider.of<AnimalProvider>(context, listen: false).fetchData(widget.category),
      builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    }
    else {
      if (snapshot.error != null) {
        return Center(
          child: Text('An error occurred!'),
        );
      }

      else {
        return RotatedBox(
          quarterTurns: 1,
          child: Consumer<AnimalProvider>(
            builder: (context,animalData,_){
              return TabBarView(
                controller: _tabController,
                children: List.generate(animalData.animalList.length, (index) {
                  return VideoPlayerItem(
                    videoUrl: animalData.animalList[index].videoUrl,
                    size: size,
                    likes:  animalData.animalList[index].likes,
                    category: animalData.animalList[index].category,
                  );
                }),
              );
            },
          ),
        );
      }
    }
    },
    );

  }

}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String category;
  final String likes;

  VideoPlayerItem(
      {Key key,
        @required this.size,
        this.videoUrl,
        this.category,
      this.likes})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  int unlockCount = 0;

  @override
  void initState() {
    super.initState();
   localStorage();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        // _videoController.play();
        // _videoController.setLooping(true);
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  final _random = new Random();
  List<String> _firstTime=[];

  localStorage()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List videoCount = prefs.getStringList('videoCount');

    if(videoCount!=null  && !videoCount.contains(widget.videoUrl)){
      List a = videoCount;
      a.add(widget.videoUrl);
      prefs.setStringList('videoCount',a);

      if(videoCount.length==5){

        List interestedList = prefs.getStringList('interestedCategory');
        var selectedCategory = interestedList[_random.nextInt(interestedList.length)];
        prefs.setString('unlockCategory', selectedCategory);
        showDialog(
                context: (context),
                builder: (context)=>AlertDialog(
                  content: Text('This $selectedCategory category is unlocked'),
                )
            );
      }
    }
    else if(prefs.getStringList('videoCount')==null){
      _firstTime.add(widget.videoUrl);
      prefs.setStringList('videoCount',_firstTime);
    }
  }


  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
  Widget isPlaying(){
    return _videoController.value.isPlaying && !isShowPlaying  ? Container() : Icon(Icons.play_arrow,size: 80,color: Colors.white.withOpacity(0.5),);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
            height: widget.size.height * .9,
            width: widget.size.width,
            child: Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                Container(
                  height: widget.size.height * .9,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: Colors.black),
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: Stack(
                      children: <Widget>[
                        VideoPlayer(_videoController),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                            ),
                            child: isPlaying(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border,color: Colors.white,size: 40,),
                      onPressed: (){},
                    ),
                    Text(widget.likes,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

