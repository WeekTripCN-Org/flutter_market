import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_market/service/service_method.dart';

import 'package:flutter_market/routers/application.dart';
import 'package:flutter_market/pages/home_page/home_swiper.dart';
import 'package:flutter_market/pages/home_page/home_top_navigator.dart';
import 'package:flutter_market/pages/home_page/home_ad_banner.dart';
import 'package:flutter_market/pages/home_page/home_phone.dart';
import 'package:flutter_market/pages/home_page/home_recommend.dart';
import 'package:flutter_market/pages/home_page/home_floor_title.dart';
import 'package:flutter_market/pages/home_page/home_floor_content.dart';

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

//  @override
//  void initState() {
//    super.initState();
//  }

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
                  HomeSwiper(swiperDataList: swiperDataList),                   // 页面顶部轮播组件
                  HomeTopNavigator(navigatorList: navigatorList),               // 导航单元素组件
                  HomeAdBanner(),               // 广告条
                  HomePhone(phoneImage: leaderImage, phoneNumber: leaderPhone), // 店长电话
                  HomeRecommend(recommendList: recommendList),                  // 商品推荐
                  HomeFloorTitle(floorImage: floor1Title),                      // 楼层1标题图片
                  HomeFloorContent(floorContent: floor1),                       // 楼层1商品内
                  _hotGoods(),                                                  // 火爆专区
                ],
              ),
              loadMore: () async {
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

