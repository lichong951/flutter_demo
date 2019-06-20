import 'package:flutter/material.dart';
import 'package:flutter_demo/bean/ComingSoonBean.dart';
import 'package:flutter_demo/bean/MovieBean.dart';
import 'package:flutter_demo/constant/ColorConstant.dart';
import 'package:flutter_demo/http/API.dart';
import 'package:flutter_demo/pages/movie/TitleWidget.dart';
import 'package:flutter_demo/pages/movie/TodayPlayMovieWidget.dart';
import 'package:flutter_demo/widgets/RatingBar.dart';
import 'package:flutter_demo/widgets/SubjectMarkImageWidget.dart';

import 'HotSoonMovieWidget.dart';
import 'HotSoonTabBar.dart';
import 'dart:math' as math;

var _api = API();

///书影音-电影
class MoviePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoviePageState();
  }
}

class _MoviePageState extends State<MoviePage> {
  Widget titleWidget, todayPlayMovieWidget, hotSoonTabBarPadding;
  HotSoonTabBar hotSoonTabBar;
  List<MovieBean> hotMovieBeans = List();
  List<ComingSoonBean> comingSoonBeans = List();
  var hotChildAspectRatio;
  var comingSoonChildAspectRatio;
  int selectIndex = 0; //选中的是热映、即将上映
  var itemW;

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

    _api.getIntheaters((movieBeanList) {
      hotSoonTabBar.setCount(movieBeanList);
      setState(() {
        hotMovieBeans = movieBeanList;
      });
    });

    _api.commingSoon((comingSoonList) {
      hotSoonTabBar.setComingSoon(comingSoonList);
      setState(() {
        comingSoonBeans = comingSoonList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (itemW == null) {
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
                if (hotMovieBeans.length > 0) {
                  hotMovieBean = hotMovieBeans[index];
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
                            hotMovieBeans != null &&
                            hotMovieBeans.length > 0))
                  ],
                );
              }, childCount: math.min(getChildCount(), 6)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: getRadio()))
        ],
      ),
    );
  }

  ///即将上映item
  Widget getComingSoonItem(ComingSoonBean comingSoonBean, var itemW) {
    if(comingSoonBean == null){
      return Container();
    }
    ///将2019-02-14转成02月14日
    String mainland_pubdate = comingSoonBean.mainland_pubdate;
    mainland_pubdate = mainland_pubdate.substring(5, mainland_pubdate.length);
    mainland_pubdate = mainland_pubdate.replaceFirst(RegExp(r'-'), '月') +'日';
    return Container(
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
                    left: 5.0, right: 5.0, ),
                child: Text(
                  mainland_pubdate,
                  style: TextStyle(
                      fontSize: 8.0, color: ColorConstant.colorRed277),
                ),
              ))
        ],
      ),
    );
  }

  ///影院热映item
  Widget getHotMovieItem(MovieBean hotMovieBean, var itemW) {
    if(hotMovieBean == null){
      return Container();
    }
    return Container(
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
    );
  }

  int getChildCount() {
    if (selectIndex == 0) {
      return hotMovieBeans.length;
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
}
