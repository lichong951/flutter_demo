import 'package:flutter_demo/bean/ComingSoonBean.dart';
import 'package:flutter_demo/bean/CommentBean.dart';
import 'package:flutter_demo/bean/MovieBean.dart';
import 'package:flutter_demo/bean/MovieDetailBean.dart';
import 'package:flutter_demo/bean/WeeklyBean.dart';
import 'package:flutter_demo/http/HttpRequest.dart';
import 'dart:math' as math;

typedef RequestCallBack<T> = void Function(T value);

class API {
  static String BASE_URL = 'https://api.douban.com';

  ///TOP250
  String TOP_250 = '/v2/movie/top250';

  ///正在热映
  String IN_THEATERS = '/v2/movie/in_theaters';

  ///即将上映
  String COMING_SOON = '/v2/movie/coming_soon';

  ///一周口碑榜
  String WEEKLY = '/v2/movie/weekly?apikey=0b2bdeda43b5688921839c8ecb20399b';

  var _request = HttpRequest(API.BASE_URL);

  void getTop250(RequestCallBack requestCallBack) async {
    final Map result = await _request.get(TOP_250);
    requestCallBack(result);
  }

  void top250(RequestCallBack requestCallBack, {count = 250}) async {
    final Map result = await _request.get(TOP_250 + '?start=0&count=$count');
    var resultList = result['subjects'];
    List<MovieBean> list =
        resultList.map<MovieBean>((item) => MovieBean.fromMap(item)).toList();
    requestCallBack(list);
  }

  ///https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b
  void getIntheaters(RequestCallBack requestCallBack) async {
    final Map result = await _request.get(IN_THEATERS);
    var resultList = result['subjects'];
    List<MovieBean> list =
        resultList.map<MovieBean>((item) => MovieBean.fromMap(item)).toList();
    requestCallBack(list);
  }

  ///https://api.douban.com/v2/movie/coming_soon?apikey=0b2bdeda43b5688921839c8ecb20399b
  ///即将上映
  void commingSoon(RequestCallBack requestCallBack) async {
    final Map result = await _request
        .get(COMING_SOON + '?apikey=0b2bdeda43b5688921839c8ecb20399b');
    var resultList = result['subjects'];
    List<ComingSoonBean> list = resultList
        .map<ComingSoonBean>((item) => ComingSoonBean.fromMap(item))
        .toList();
    requestCallBack(list);
  }

  ///豆瓣热门
  void getHot(RequestCallBack requestCallBack) async {
    ///随机生成热门
    int start = math.Random().nextInt(220);
    final Map result = await _request.get(TOP_250 + '?start=$start&count=7');
    var resultList = result['subjects'];
    List<MovieBean> list =
        resultList.map<MovieBean>((item) => MovieBean.fromMap(item)).toList();
    requestCallBack(list);
  }

  void getWeekly(RequestCallBack requestCallBack) async {
    final Map result = await _request.get(WEEKLY);
    var resultList = result['subjects'];
    List<WeeklyBean> list =
        resultList.map<WeeklyBean>((item) => WeeklyBean.fromMap(item)).toList();
    requestCallBack(list);
  }

  ///26266893 电影条目信息
  ///https://api.douban.com/v2/movie/subject/26266893?apikey=0b2bdeda43b5688921839c8ecb20399b
  void getMovieDetail(subjectId, RequestCallBack requestCallBack) async {
    final result = await _request.get(
        '/v2/movie/subject/$subjectId?apikey=0b2bdeda43b5688921839c8ecb20399b');
    MovieDetailBean bean = MovieDetailBean.fromJson(result);
    requestCallBack(bean);
  }

  ///电影短评
  ///https://api.douban.com/v2/movie/subject/26266893/comments?apikey=0b2bdeda43b5688921839c8ecb20399b
  void getComments(subjectId, RequestCallBack requestCallBack) async {
    final result = await _request.get(
        '/v2/movie/subject/$subjectId/comments?apikey=0b2bdeda43b5688921839c8ecb20399b');
    CommentsEntity bean = CommentsEntity.fromJson(result);
    requestCallBack(bean);
  }
}
