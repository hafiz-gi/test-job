import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'Video_provider.dart';

final _fireStore = Firestore.instance;

class VideoStream extends StatefulWidget {

final String category;
VideoStream({this.category});

  @override
  _VideoStreamState createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> with SingleTickerProviderStateMixin {

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
    final _data = Provider.of<VideoProvider>(context);

    var size = MediaQuery.of(context).size ;

    Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
        BuildContext context) async* {

      yield* _fireStore.collection('Collection').where('category', isEqualTo: widget.category).snapshots();
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: getUsersTripsStreamSnapshots(context),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final message = snapshot.data.documents;

          return RotatedBox(
            quarterTurns: 1,
            child: TabBarView(
              controller: _tabController,
              children: List.generate(message.length, (index) {
                return
                  VideoPlayerItem(
                  videoUrl: message[index]['videoUrl'],
                  size: size,
                  likes: message[index]['likes'],
                  category :message[index]['category'] ,
                );
              }),
            ),
          );

          // List<VideoPlay> messages = message.map((doc) {
          //   return VideoPlay(
          //       videoUrl: doc.data['videoUrl'],
          //       category: doc.data['category'],
          //       likes:doc.data['likes']);
          // }).toList();
          // return ListView(
          //   children: messages,
          // );
        },
      ),
    );
  }

}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String likes;
  final String category;

  VideoPlayerItem(
      {Key key,
        @required this.size,
        this.likes,
        this.videoUrl,
        this.category})
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
        _videoController.play();
        _videoController.setLooping(true);
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
              children: <Widget>[
                Container(
                  height: widget.size.height * .9,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: Colors.black),
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
                // Container(
                //   height: widget.size.height,
                //   width: widget.size.width,
                //   child: Padding(
                //     padding:
                //     const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                //     child: SafeArea(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           HeaderHomePage(),
                //           Expanded(
                //               child: Row(
                //                 children: <Widget>[
                //                   LeftPanel(
                //                     size: widget.size,
                //                     name: "${widget.name}",
                //                     caption: "${widget.caption}",
                //                     songName: "${widget.songName}",
                //                   ),
                //                   RightPanel(
                //                     size: widget.size,
                //                     likes: "${widget.likes}",
                //                     comments: "${widget.comments}",
                //                     shares: "${widget.shares}",
                //                     profileImg: "${widget.profileImg}",
                //                     albumImg: "${widget.albumImg}",
                //                   )
                //                 ],
                //               ))
                //         ],
                //       ),
                //     ),
                //   ),
                // )
              ],
            )),
      ),
    );
  }
}

// class VideoPlay extends StatelessWidget {
//   final String videoUrl;
//   final String category;
//   final String likes;
//
//   VideoPlay({this.videoUrl, this.category, this.likes});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=> TrainerChat(id: id,name: name,imageUrl: imageUrl,)));
//           },
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: ClipOval(
//                     child: (imageUrl!=null)?Image.network(imageUrl,height:70,width:70,fit: BoxFit.cover,):Image.asset('assets/images/profile.png',height:70,width:70,fit: BoxFit.cover,color: Colors.white,)
//                 ),
//               ),
//               Text(name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
//             ],
//           ),
//         ),
// //        ListTile(
// //          leading: ClipOval(
// //            child: (imageUrl!=null)?Image.network(imageUrl,height:60,width:60,fit: BoxFit.cover,):Image.asset('assets/images/a.png',fit: BoxFit.cover,)
// //          ),
// //          title: Text(name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
// //        ),
//         Divider(color: Colors.white,)
//       ],
//     );
//   }
// }
