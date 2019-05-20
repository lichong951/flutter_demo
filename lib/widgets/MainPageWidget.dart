import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/FlutterTabBar.dart';
import 'package:flutter_demo/pages/MoviePage.dart';

class MainPageWidget extends StatefulWidget {
  MainPageWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageWidgetState();
  }
}

class _MainPageWidgetState extends State<MainPageWidget> {
  final List<Widget> pages = [
    HomePage(),
//    MoviePage(),
//    GroupPage(),
//    ShopPage(),
//    PersonPage()
  ];

  int _selectIndex = 0;

//Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget getWidget(int index) {
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: [
          getWidget(0),
//          getWidget(1),
//          getWidget(2),
//          getWidget(3),
//          getWidget(4),
        ],
      ),
//        List<BottomNavigationBarItem>
//        @required this.icon,
//    this.title,
//    Widget activeIcon,
//    this.backgroundColor,
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      bottomNavigationBar: BottomNavigationBar(
        items: [


          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              title: Text('首页'),
              activeIcon: Icon(
                Icons.home,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.movie,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              title: Text('书影音'),
              activeIcon: Icon(
                Icons.movie,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              title: Text('小组'),
              activeIcon: Icon(
                Icons.group,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              title: Text('市集'),
              activeIcon: Icon(
                Icons.receipt,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
              title: Text('我的'),
              activeIcon: Icon(
                Icons.person,
              )),
        ],
        onTap: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        //图标大小
        iconSize: 24,
        //当前选中的索引
        currentIndex: _selectIndex,
        //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
        fixedColor: Color.fromARGB(255, 0, 188, 96),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page1'),
    );
  }
}