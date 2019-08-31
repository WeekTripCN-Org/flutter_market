import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:flutter_market/pages/details_page.dart';    // 商品详情页面

// 商品详情页路由
Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>>params) {
    String goodsId = params['id'].first;
    print('index>details goodsID is ${goodsId}');
    return DetailsPage(goodsId);
  }
);