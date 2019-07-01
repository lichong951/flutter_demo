import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/bean/MovieDetailBean.dart';
import 'package:flutter_demo/constant/Constant.dart';
import 'package:flutter_demo/http/API.dart';
import 'package:flutter_demo/pages/detail/DetailTitleWidget.dart';
import 'package:flutter_demo/pages/detail/ScoreStartWidget.dart';
import 'package:flutter_demo/util/PickImgMainColor.dart';

///影片、电视详情页面
class DetailPage extends StatefulWidget {
  final subjectId;

  DetailPage(this.subjectId, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState(subjectId);
  }
}

class _DetailPageState extends State<DetailPage> {
  final subjectId;
  Color pickColor = Color(0xffffffff); //默认主题色

  _DetailPageState(this.subjectId);

  API _api = API();
  MovieDetailBean _movieDetailBean;

  @override
  void initState() {
    super.initState();
    _api.getMovieDetail(subjectId, (movieDetailBean) {
      _movieDetailBean = movieDetailBean;
      setState(() {});
      //提取海报主题色 https://img1.doubanio.com/view/photo/s_ratio_poster/public/p2541901817.jpg
      PickImgMainColor.pick(NetworkImage(_movieDetailBean.images.large),
          (color) {
        if (color != null) {
          setState(() {
            pickColor = color;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_movieDetailBean == null) {
      return Scaffold(
        body: CupertinoActivityIndicator(),
      );
    }
    var allCount = _movieDetailBean.rating.details.d1 +
        _movieDetailBean.rating.details.d2 +
        _movieDetailBean.rating.details.d3 +
        _movieDetailBean.rating.details.d4 +
        _movieDetailBean.rating.details.d5;

    return Scaffold(
      backgroundColor: pickColor,
      body: Container(
        margin: EdgeInsets.only(
            left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT),
        child: SafeArea(
            child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: DetailTitleWidget(_movieDetailBean, pickColor),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
                child: ScoreStartWidget(
                  score: _movieDetailBean.rating.average,
                  p1: _movieDetailBean.rating.details.d1 / allCount,
                  p2: _movieDetailBean.rating.details.d2 / allCount,
                  p3: _movieDetailBean.rating.details.d3 / allCount,
                  p4: _movieDetailBean.rating.details.d4 / allCount,
                  p5: _movieDetailBean.rating.details.d5 / allCount,
                ),
              ),
            ),
            sliverTags(),
            sliverSummary(),
          ],
        )),
      ),
    );
  }

  ///所属频道
  SliverToBoxAdapter sliverTags() {
    return SliverToBoxAdapter(
      child: Container(
        height: 30.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _movieDetailBean.tags.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      '所属频道',
                      style: TextStyle(color: Colors.white70, fontSize: 13.0),
                    ),
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                      color: Color(0x23000000),
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  child: Text(
                    '${_movieDetailBean.tags[index - 1]}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            }),
      ),
    );
  }

  ///剧情简介
  SliverToBoxAdapter sliverSummary() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
            child: Text(
              '剧情简介',
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            _movieDetailBean.summary,
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
