import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_job/provider/animal_provider.dart';
import 'package:test_job/provider/football_provider.dart';
import 'package:test_job/provider/funny_provider.dart';
import 'package:test_job/provider/music_provider.dart';
import 'package:test_job/signup.dart';

import 'provider/Video_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
        value: VideoProvider(),),
        ChangeNotifierProvider.value(
          value:AnimalProvider() ,
        ),
        ChangeNotifierProvider.value(
          value:FootballProvider() ,
        ),
        ChangeNotifierProvider.value(
          value:FunnyProvider() ,
        ),
        ChangeNotifierProvider.value(
          value:MusicProvider() ,
        )
      ],
        child: MaterialApp(
          title: 'Test Job',

          home: SignUp(),
        ),
      );
  }
}