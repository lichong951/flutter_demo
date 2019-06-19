import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/movie/HotSoonMovieWidget.dart';
import 'package:flutter_demo/pages/movie/TitleWidget.dart';
import 'package:flutter_demo/pages/movie/TodayPlayMovieWidget.dart';
import 'package:flutter_demo/widgets/ContainerPageWidget.dart';
import 'package:flutter_demo/widgets/SubjectMarkImageWidget.dart';

import 'bean/MovieBean.dart';
import 'http/API.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(child: ContainerPageWidget()),
      ),
    );
  }
}
//http://img1.doubanio.com/view/photo/s_ratio_poster/public/p457760035.webp

class DemoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DemoAppState();
  }
}

class _DemoAppState extends State<DemoApp> {
  var _api = API();
  HotSoonMovieWidget w;
  List<MovieBean> hotMovieBeans = [];

  @override
  void initState() {
    super.initState();
    w = HotSoonMovieWidget();
    _api.getIntheaters((movieBeanList) {
      hotMovieBeans = movieBeanList;
      setState(() {

      });
    });
  }

  double childAspectRatio = 355.0 / 506.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: CustomScrollView(
          physics: ScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: TitleWidget(),
            ),
            SliverToBoxAdapter(
              child: TodayPlayMovieWidget([
                'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p792776858.webp',
                'https://img1.doubanio.com/view/photo/s_ratio_poster/public/p1374786017.webp',
                'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p917846733.webp',
              ]),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return SubjectMarkImageWidget(
                      hotMovieBeans[index].images.large);
                }, childCount: hotMovieBeans.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: childAspectRatio))
          ],
        )),
      ),
    );
  }
}
