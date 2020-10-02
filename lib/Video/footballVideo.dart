import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_job/provider/football_provider.dart';
import 'package:video_player/video_player.dart';


final _fireStore = Firestore.instance;

class FootballStream extends StatefulWidget {
  final String category;

  FootballStream({this.category});

  @override
  _FootballStreamState createState() => _FootballStreamState();
}

class _FootballStreamState extends State<FootballStream>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: Provider.of<FootballProvider>(context, listen: false).fetchData(widget.category),
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
              child: Consumer<FootballProvider>(
                builder: (context,footballData,_){
                  return TabBarView(
                    controller: _tabController,
                    children: List.generate(footballData.footballList.length, (index) {
                      return VideoPlayerItem(
                        videoUrl: footballData.footballList[index].videoUrl,
                        size: size,
                        likes: footballData.footballList[index].likes,
                        category: footballData.footballList[index].category,
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

  VideoPlayerItem({Key key, @required this.size, this.videoUrl, this.category,this.likes})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        // _videoController.play();
        // _videoController.setLooping(true);
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          );
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
                            decoration: BoxDecoration(),
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

