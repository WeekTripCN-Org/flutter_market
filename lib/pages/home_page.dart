import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';

  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  bool get wantKeepAlive =>true;

  @override
  void initState() {
    super.initState();
  }

  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var formData = {'lon': '115.02932', 'lat': '35.76189'};

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
        future: request('homePageContent', formData: formData),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());

            List<Map> swiperDataList  = (data['data']['slides'] as List).cast();
            List<Map> navigatorList   = (data['data']['category'] as List).cast();
            String advertesPicture    = (data['data']['advertesPicture']['PICTURE_ADDRESS']);
            String leaderImage        = (data['data']['shopInfo']['leaderImage']);
            String leaderPhone        = (data['data']['shopInfo']['leaderPhone']);
            List<Map> recommendList   = (data['data']['recommend'] as List).cast();
            String floor1Title        = (data['data']['floor1Pic']['PICTURE_ADDRESS']);
            List<Map> floor1          = (data['data']['floor1'] as List).cast();
            String floor2Title        = (data['data']['floor2Pic']['PICTURE_ADDRESS']);
            List<Map> floor2          = (data['data']['floor2'] as List).cast();
            String floor3Title        = (data['data']['floor3Pic']['PICTURE_ADDRESS']);
            List<Map> floor3          = (data['data']['floor3'] as List).cast();

            if (navigatorList.length > 10) {
              // 超过第10个的单元素导航去除
              navigatorList.removeRange(10, navigatorList.length);
            }

            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: '',
                moreInfo: '加载中...',
                loadReadyText: '上拉加载...',
              ),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList),  // 页面顶部轮播组件
                  TopNavigator(navigatorList: navigatorList,),// 导航单元素组件
                  AdBanner(advertesPicture: advertesPicture,),// 广告条
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone,), // 拨打电话模块
                  Recommend(recommendList: recommendList,),   // 商品推荐
                  FloorTitle(picture_address: floor1Title,),  // 楼层1图片
                  FloorContent(floorGoodsList: floor1,),      // 楼层1商品
//                  FloorTitle(picture_address: floor2Title,),  // 楼层2图片
//                  FloorContent(floorGoodsList: floor2,),      // 楼层2商品
//                  FloorTitle(picture_address: floor3Title,),  // 楼层3图片
//                  FloorContent(floorGoodsList: floor3,),      // 楼层3商品
                  _hotGoods(),                                 // 火爆专区
                ],
              ),
              loadMore: () async {
                print('开始加载更多...');
                var formData = {'page': page};
                await request('homePageBelowConten', formData: formData).then((val) {
                  var data = json.decode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(newGoodsList);
                    page++;
                  });
                });
              },
            );

          } else {
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      )
    );
  }
  // 火爆商品接口
  void _getHotGoods() {
    var formData = {'page': page};
    request('homePageBelowConten', formData: formData).then((val){
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();

      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black12)
        )
    ),
    child: Text('火爆专区'),
  );

  // 火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372.0),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(375),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(28)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(color: Colors.black12, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  // 组合数据
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(context, '/detail?id=${swiperDataList[index]['goodsId']}');
            },
            child: Image.network('${swiperDataList[index]['image']}', fit: BoxFit.fill,),
          );
        },
      ),
    );
  }
}

// 导航单元素
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}):super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: (){print('点击了导航单元素');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告图片
class AdBanner extends StatelessWidget {
  final String advertesPicture;
  AdBanner({Key key, this.advertesPicture}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

// 拨打电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}):super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}):super(key: key);

  // 子类标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 子类内容
  Widget _item(index, context) {
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, '/detail?id=${recommendList[index]['goodsId']}');
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index, context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(390),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}

// 楼层标题组件
class FloorTitle extends StatelessWidget {
  final String picture_address;
  FloorTitle({Key key, this.picture_address}):super(key:key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品组件
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({Key key, this.floorGoodsList}):super(key: key);

  Widget _goodsItem(context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){
          Application.router.navigateTo(context, '/detail?id=${goods['goodsId']}');
        },
        child: Image.network(goods['image']),
      ),
    );  
  }
  
  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        ),

      ],
    );
  }
  
  Widget _otherRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherRow(context),
        ],
      ),
    );
  }
}

