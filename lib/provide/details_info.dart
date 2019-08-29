import 'package:flutter/material.dart';
import 'dart:convert';
import '../model/details.dart';
import '../service/service_method.dart';

/**
 * 商品详细相关业务逻辑
 */
class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo = null;
  bool isLeft = true;
  bool isRight = false;

  // 从后台获取商品信息
  getGoodsInfo(String id) async {
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());

      goodsInfo = DetailsModel.fromJson(responseData);

      notifyListeners();
    });
  }

  // 改变tabBar 的状态
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft  = true;
      isRight = false;
    } else {
      isLeft  = false;
      isRight = true;
    }
    notifyListeners();
  }
}