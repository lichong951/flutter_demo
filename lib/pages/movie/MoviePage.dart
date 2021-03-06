import 'package:flutter/material.dart';
import 'package:flutter_demo/bean/ComingSoonBean.dart';
import 'package:flutter_demo/bean/MovieBean.dart';
import 'package:flutter_demo/bean/TopItemBean.dart';
import 'package:flutter_demo/bean/WeeklyBean.dart';
import 'package:flutter_demo/constant/ColorConstant.dart';
import 'package:flutter_demo/constant/Constant.dart';
import 'package:flutter_demo/http/API.dart';
import 'package:flutter_demo/manager/Router.dart';
import 'package:flutter_demo/pages/movie/ItemCountTitle.dart';
import 'package:flutter_demo/pages/movie/TitleWidget.dart';
import 'package:flutter_demo/pages/movie/TodayPlayMovieWidget.dart';
import 'package:flutter_demo/pages/movie/TopItemWidget.dart';
import 'package:flutter_demo/widgets/RatingBar.dart';
import 'package:flutter_demo/widgets/SubjectMarkImageWidget.dart';
import 'package:flutter_demo/widgets/image/CacheImgRadius.dart';

import 'HotSoonMovieWidget.dart';
import 'HotSoonTabBar.dart';
import 'dart:math' as math;

var _api = API();
var _router = Router();

///书影音-电影
class MoviePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoviePageState();
  }
}

class _MoviePageState extends State<MoviePage> {
  Widget titleWidget,
      todayPlayMovieWidget,
      hotSoonTabBarPadding,
      hotTitlePadding,
      topPadding;
  HotSoonTabBar hotSoonTabBar;
  ItemCountTitle hotTitle; //豆瓣热门
  ItemCountTitle topTitle; //豆瓣榜单
  TopItemWidget weeklyTop, weeklyHot, weeklyTop250; //周口碑榜单、周热门榜单、top250
  List<MovieBean> hotShowBeans = List(); //影院热映
  List<ComingSoonBean> comingSoonBeans = List(); //即将上映
  List<MovieBean> hotBeans = List(); //豆瓣热门
  List<WeeklyBean> weeklyBeans = List(); //一周口碑电影榜
  List<MovieBean> top250Beans = List(); //Top250
  var hotChildAspectRatio;
  var comingSoonChildAspectRatio;
  int selectIndex = 0; //选中的是热映、即将上映
  var itemW;
  var imgSize;

  @override
  void initState() {
    super.initState();
    titleWidget = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TitleWidget(),
    );

    todayPlayMovieWidget = Padding(
      child: TodayPlayMovieWidget([
        'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p792776858.webp',
        'https://img1.doubanio.com/view/photo/s_ratio_poster/public/p1374786017.webp',
        'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p917846733.webp',
      ]),
      padding: EdgeInsets.only(top: 22.0),
    );
    hotSoonTabBar = HotSoonTabBar(
      onTabCallBack: (index) {
        setState(() {
          selectIndex = index;
        });
      },
    );

    hotSoonTabBarPadding = Padding(
      padding: EdgeInsets.only(top: 35.0, bottom: 15.0),
      child: hotSoonTabBar,
    );

    hotTitle = ItemCountTitle('豆瓣热门');

    hotTitlePadding = Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
      child: hotTitle,
    );

    topTitle = ItemCountTitle('豆瓣榜单');
    topPadding = Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
      child: topTitle,
    );
    weeklyTop = TopItemWidget(
      '一周口碑电影榜',
    );
    weeklyHot = TopItemWidget(
      '一周热门电影榜',
    );
    weeklyTop250 = TopItemWidget(
      '豆瓣电影 Top250',
    );

    requestAPI();
  }

  @override
  Widget build(BuildContext context) {
    if (itemW == null) {
      imgSize = MediaQuery.of(context).size.width / 5 * 3;
      itemW = (MediaQuery.of(context).size.width - 30.0 - 20.0) / 3;
//      hotChildAspectRatio = itemW / 121.0 * (377.0 / 674.0);
      hotChildAspectRatio = (377.0 / 674.0);
//      comingSoonChildAspectRatio = itemW / 121.0 * (377.0 / 712.0);
      comingSoonChildAspectRatio = (377.0 / 742.0);
    }
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: titleWidget,
          ),
          SliverToBoxAdapter(
            child: todayPlayMovieWidget,
          ),
          SliverToBoxAdapter(
            child: hotSoonTabBarPadding,
          ),
          SliverGrid(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                var hotMovieBean;
                var comingSoonBean;
                if (hotShowBeans.length > 0) {
                  hotMovieBean = hotShowBeans[index];
                }
                if (comingSoonBeans.length > 0) {
                  comingSoonBean = comingSoonBeans[index];
                }
                return Stack(
                  children: <Widget>[
                    Offstage(
                      child: getComingSoonItem(comingSoonBean, itemW),
                      offstage: !(selectIndex == 1 &&
                          comingSoonBeans != null &&
                          comingSoonBeans.length > 0),
                    ),
                    Offstage(
                        child: getHotMovieItem(hotMovieBean, itemW),
                        offstage: !(selectIndex == 0 &&
                            hotShowBeans != null &&
                            hotShowBeans.length > 0))
                  ],
                );
              }, childCount: math.min(getChildCount(), 6)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: getRadio())),
          getCommonImg(Constant.IMG_TMP1, null),
          SliverToBoxAdapter(
            child: hotTitlePadding,
          ),
          getCommonSliverGrid(hotBeans),
          getCommonImg(Constant.IMG_TMP2, null),
          SliverToBoxAdapter(
            child: topPadding,
          ),
          topSliverList(),
        ],
      ),
    );
  }

  ///即将上映item
  Widget getComingSoonItem(ComingSoonBean comingSoonBean, var itemW) {
    if (comingSoonBean == null) {
      return Container();
    }

    ///将2019-02-14转成02月14日
    String mainland_pubdate = comingSoonBean.mainland_pubdate;
    mainland_pubdate = mainland_pubdate.substring(5, mainland_pubdate.length);
    mainland_pubdate = mainland_pubdate.replaceFirst(RegExp(r'-'), '月') + '日';
    return GestureDetector(
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SubjectMarkImageWidget(
              comingSoonBean.images.large,
              width: itemW,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  comingSoonBean.title,

                  ///文本只显示一行
                  softWrap: false,

                  ///多出的文本渐隐方式
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: ColorConstant.colorRed277),
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: Text(
                    mainland_pubdate,
                    style: TextStyle(
                        fontSize: 8.0, color: ColorConstant.colorRed277),
                  ),
                ))
          ],
        ),
      ),
      onTap: () {
        _router.push(context, Router.detailPage, comingSoonBean.id);
      },
    );
  }

  ///影院热映item
  Widget getHotMovieItem(MovieBean hotMovieBean, var itemW) {
    if (hotMovieBean == null) {
      return Container();
    }
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            SubjectMarkImageWidget(
              hotMovieBean.images.large,
              width: itemW,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  hotMovieBean.title,

                  ///文本只显示一行
                  softWrap: false,

                  ///多出的文本渐隐方式
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            RatingBar(
              hotMovieBean.rating.average,
              size: 12.0,
            )
          ],
        ),
      ),
      onTap: () {
        _router.push(context, Router.detailPage, hotMovieBean.id);
      },
    );
  }

  int getChildCount() {
    if (selectIndex == 0) {
      return hotShowBeans.length;
    } else {
      return comingSoonBeans.length;
    }
  }

  double getRadio() {
    if (selectIndex == 0) {
      return hotChildAspectRatio;
    } else {
      return comingSoonChildAspectRatio;
    }
  }

  ///图片+订阅+名称+星标
  SliverGrid getCommonSliverGrid(List<MovieBean> hotBeans) {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return getHotMovieItem(hotBeans[index], itemW);
        }, childCount: math.min(hotBeans.length, 6)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 0.0,
            childAspectRatio: hotChildAspectRatio));
  }

  ///R角图片
  getCommonImg(String url, OnTab onTab) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: CacheImgRadius(
          imgUrl: url,
          radius: 5.0,
          onTab: () {
            if (onTab != null) {
              onTab();
            }
          },
        ),
      ),
    );
  }

  void requestAPI() {
    _api.getIntheaters((movieBeanList) {
      hotSoonTabBar.setCount(movieBeanList);
      setState(() {
        hotShowBeans = movieBeanList;
      });
    });

    _api.commingSoon((comingSoonList) {
      hotSoonTabBar.setComingSoon(comingSoonList);
      setState(() {
        comingSoonBeans = comingSoonList;
      });
    });

    _api.getHot((hotBeanList) {
      hotBeans = hotBeanList;
      hotTitle.setCount(hotBeans.length);
      weeklyHot.setData(TopItemBean.convertHotBeans(hotBeans));
    });

    _api.getWeekly((weeklyBeanList) {
      weeklyBeans = weeklyBeanList;
      weeklyTop.setData(TopItemBean.convertWeeklyBeans(weeklyBeans));
      topTitle.setCount(weeklyBeans.length);
    });

    _api.top250((beanList) {
      top250Beans = beanList;
      weeklyTop250.setData(TopItemBean.convertTopBeans(top250Beans));
    }, count: 5);
  }

  ///豆瓣榜单
  SliverToBoxAdapter topSliverList() {
    return SliverToBoxAdapter(
      child: Container(
        height: imgSize,
        child: ListView(
          children: <Widget>[weeklyTop, weeklyHot, weeklyTop250],
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

typedef OnTab = void Function();
