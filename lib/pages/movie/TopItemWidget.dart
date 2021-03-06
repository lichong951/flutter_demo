import 'package:flutter/material.dart';
import 'package:flutter_demo/bean/TopItemBean.dart';
import 'package:flutter_demo/bean/WeeklyBean.dart';
import 'package:flutter_demo/constant/ColorConstant.dart';
import 'package:flutter_demo/util/PickImgMainColor.dart';
import 'package:flutter_demo/widgets/image/CachedNetworkImage.dart';

TopItemBean _bean;

///豆瓣榜单Item
///
@immutable
class TopItemWidget extends StatefulWidget {
  _TopItemWidgetState state;
  final title;

  TopItemWidget(this.title, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    state = _TopItemWidgetState(title);
    return state;
  }

  setData(TopItemBean bean) {
    state.setData(bean);
  }
}

var _imgSize;

class _TopItemWidgetState extends State<TopItemWidget> {
  var title;
  TopItemBean _bean;
  Color partColor = Colors.brown;

  _TopItemWidgetState(this.title);

  @override
  Widget build(BuildContext context) {
    if (_bean == null) {
      return Container();
    }
    if (_imgSize == null) {
      _imgSize = MediaQuery.of(context).size.width / 5 * 3;
    }

    return Container(
      width: _imgSize,
      height: _imgSize,
      padding: EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              width: _imgSize,
              height: _imgSize,
              fit: BoxFit.cover,
              imageUrl: _bean.imgUrl,
            ),
            Positioned(
                top: 8.0,
                right: 15.0,
                child: Text(
                  _bean.count,
                  style: TextStyle(fontSize: 12.0, color: Colors.white),
                )),
            Positioned(
              top: _imgSize / 2 - 40.0,
              left: 30.0,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 21.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: _imgSize / 2,
              child: Container(
                height: _imgSize / 2,
                width: _imgSize,
                color: partColor,
              ),
            ),
            Positioned(
                top: _imgSize / 2,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getChildren(_bean.items),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void setData(TopItemBean bean) {
    PickImgMainColor.pick(NetworkImage(bean.imgUrl), (Color color) {
      setState(() {
        partColor = color;
      });
    });
    setState(() {
      _bean = bean;
    });
  }

  ///电影列表
  Widget getItem(Item item, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 5.0, bottom: 5.0),
          child: Text(
            '$i. ${item.title}',
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          ),
        ),
        Text(
          '${item.average}',
          style: TextStyle(fontSize: 11.0, color: ColorConstant.colorOrigin),
        ),
      ],
    );
  }

  List<Widget> getChildren(List<Item> items) {
    List<Widget> list = [];
    for (int i = 0; i < items.length; i++) {
      list.add(getItem(items[i], i + 1));
    }
    return list;
  }
}
