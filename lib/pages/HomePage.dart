import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:flutter_demo/widgets/FlutterTabBarView.dart';
import 'package:flutter_demo/widgets/SearchTextFieldWidget.dart';

var titleList = ['电影', '电视', '综艺', '读书', '音乐', '同城'];

List<Widget> tabList;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

TabController _tabController;

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var tabBar;

  @override
  void initState() {
    super.initState();
    tabBar = FlutterTabBar();
    tabList = getTabList();
    _tabController = TabController(length: tabList.length, vsync: this);
  }

  List<Widget> getTabList() {
    return titleList
        .map((item) => Text(
              '$item',
              style: TextStyle(fontSize: 18),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: SafeArea(
        child: DefaultTabController(
          length: titleList.length,child: _getNestedScrollView(tabBar))),
    );
  }
}

Widget _getNestedScrollView(Widget tabBar){
  return NestedScrollView(
    headerSliverBuilder:(BuildContext context,bool innerBoxIsScrolled) {
      return <Widget>[
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10.0),
            child: SearchTextFieldWidget(
              hintText:'用一部电影来形容你的2018',
            ),
          ),
        ),
        SliverPersistentHeader(
          floating: true,
          pinned: true,
          delegate: _SliverAppBarDelegate(
            maxHeight:49.0,
            minHeight:49.0,
            child:Container(
              color: Colors.white,
              child: tabBar,
            )))
      ];
    },
    body: FlutterTabBarView(
      tabController:_tabController,
    ));
}

class FlutterTabBar extends StatefulWidget{
  FlutterTabBar ({Key key}):super (key:key);

  @override
  State<StatefulWidget> createState(){
    return _FlutterTabBarState();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(minHeight ?? kToolbarHeight, minExtent);

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _FlutterTabBarState extends State<FlutterTabBar>{
  Color selectColor,unselectedColor;
  TextStyle selectStyle,unselectedStyle;

  @override
  void initState(){
    super.initState();
    selectColor = Color.fromARGB(255, 45, 45, 45);
    unselectedColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18,color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18,color: selectColor);
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: TabBar(
          tabs:tabList,
        isScrollable: true,
        controller: _tabController,
        indicatorColor: selectColor,
        labelColor: selectColor,
        labelStyle: selectStyle,
        unselectedLabelColor: unselectedColor,
        unselectedLabelStyle: unselectedStyle,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}
