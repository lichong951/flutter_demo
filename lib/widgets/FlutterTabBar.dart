import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/FlutterTabBarView.dart';

var titleList = ['电影'
, '电视'
, '综艺'
, '读书'
, '音乐'
, '同城'
];

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
    _tabController = TabController(vsync: this, length: tabList.length);
  }

  List<Widget> getTabList() {
    return titleList
        .map((item) =>
        Text(
          '$item',
          style: TextStyle(fontSize: 18),
        ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          child: DefaultTabController(
              length: titleList.length,
              child: Column(
                children: <Widget>[
                  tabBar,
                  Expanded(
                    child: Container(
                      color: Colors.white70,
                      width: double.infinity,
                      alignment: Alignment.center,
//                          child: Text('$selectType', style: TextStyle(fontSize: 26),),
                      child: FlutterTabBarView(
                        tabController: _tabController,
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}

class FlutterTabBar extends StatefulWidget {
  FlutterTabBar({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FlutterTabBarState();
  }
}

class _FlutterTabBarState extends State<FlutterTabBar> {
  Color selectColor, unselectedColor;
  TextStyle selectStyle, unselectedStyle;

  @override
  void initState() {
    super.initState();
    selectColor = Color.fromARGB(255, 45, 45, 45);
    unselectedColor = Color.fromARGB(255,177,177,177);
    selectStyle = TextStyle(fontSize: 18, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return TabBar(
      tabs: tabList,
      isScrollable: true,
      controller: _tabController,
      indicatorColor: selectColor,
      labelColor: selectColor,
      labelStyle: selectStyle,
      unselectedLabelColor: unselectedColor,
      unselectedLabelStyle: unselectedStyle,
      indicatorSize: TabBarIndicatorSize.label,
    );
  }
}