import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/MainPageWidget.dart';
import 'package:flutter_demo/widgets/SearchTextFieldWidget.dart';
import 'package:flutter_demo/widgets/image/NetworkImgWidget.dart';
import 'package:flutter_demo/widgets/TitleWidget.dart';
import 'package:flutter_demo/pages/movie/TodayPlayMovieWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child:
            TodayPlayMovieWidget([
              'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p480747492.webp',
              'https://img1.doubanio.com/view/photo/s_ratio_poster/public/p1150103377.webp',
              'https://img1.doubanio.com/view/photo/s_ratio_poster/public/p1374786017.webp'
            ])
        ),
      ),
    );
  }
}
//http://img1.doubanio.com/view/photo/s_ratio_poster/public/p457760035.webp


