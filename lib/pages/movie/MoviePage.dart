import 'package:flutter/material.dart';
import 'package:flutter_demo/http/API.dart';
import 'package:flutter_demo/pages/movie/TitleWidget.dart';
import 'package:flutter_demo/pages/movie/TodayPlayMovieWidget.dart';

import 'HotSoonMovieWidget.dart';
var _api = API();

///书影音-电影
class MoviePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoviePageState();
  }
}

class _MoviePageState extends State<MoviePage> {
  Widget titleWidget, todayPlayMovieWidget, hotSoonMovieWidget;

  @override
  void initState() {
    super.initState();
    titleWidget = TitleWidget();
    hotSoonMovieWidget = HotSoonMovieWidget();
    todayPlayMovieWidget = TodayPlayMovieWidget([
      'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p792776858.webp',
      'https://img1.doubanio.com/view/photo/s_ratio_poster/public/p1374786017.webp',
      'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p917846733.webp',
    ]);
    _api.getIntheaters((data){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: titleWidget,
            ),
            Padding(
              child: todayPlayMovieWidget,
              padding: EdgeInsets.only(top: 22.0),
            ),
            Padding(
              child: hotSoonMovieWidget,
              padding: EdgeInsets.only(top: 25.0),
            ),
          ]))
        ],
      ),
    );
  }
}
