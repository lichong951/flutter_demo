import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/pages/VideoPlayPage.dart';
import 'package:flutter_demo/pages/detail/DetailPage.dart';
import 'package:flutter_demo/widgets/ContainerPageWidget.dart';


///https://www.jianshu.com/p/b9d6ec92926f

class Router {
  static const homePage = 'app/';
  static const detailPage = 'app/DetailPage';
  static const playListPage = 'app/VideosPlayPage';

//  Widget _router(String url, dynamic params) {
//    String pageId = _pageIdMap[url];
//    return _getPage(pageId, params);
//  }
//
//  Map<String, dynamic> _pageIdMap = <String, dynamic>{
//    'app/': 'ContainerPageWidget',
//    detailPage: 'DetailPage',
//  };

  Widget _getPage(String url, dynamic params) {
    switch (url) {
      case detailPage:
        return DetailPage(params);
      case homePage:
        return ContainerPageWidget();
      case playListPage:
        return VideoPlayPage(params);
    }
    return null;
  }

  void push(BuildContext context, String url, dynamic params) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    }));
  }
}
