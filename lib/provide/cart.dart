import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

/**
 * 购物车
 */
class CartProvide with ChangeNotifier {
  String cartString = "[]";
  List<CartInfoModel> cartList = []; // 购物车商品列表

  double allPrice   = 0;    // 总价格
  int allGoodsCount = 0;    // 商品总数量
  bool  isAllCheck  = true; // 是否全选


  save(goodsId, goodsName, count, price, images) async {
    // 初始化 SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo'); // 获取持久化存储的值

    // 判断 cartString 是否为空，为空说明是第一次添加，或者 key 被清除了
    // 如果有值进行 decode 操作
    var temp = cartString==null ? []
        : json.decode(cartString.toString());

    // 把获得值转变成 List
    List<Map> tempList = (temp as List).cast();

    // 声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false;       // 默认为 没有
    int ival   = 0;           // 用于进行循环的索引使用
    allPrice   = 0;
    allGoodsCount = 0;

    tempList.forEach((item){  // 进行循环，找出是否已经存在该商品
      // 如果存在，数量进行 +1 操作
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }

      if (item['isCheck']) {
        allPrice += (cartList[ival].price * cartList[ival].count);
        allGoodsCount += cartList[ival].count;
      }
      ival++;
    });

    // 如果没有，进行增加
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true,  // 是否已经选中
      };
      tempList.add(newGoods);
      cartList.add(new CartInfoModel.fromJson(newGoods));

      allPrice += (count * price);
      allGoodsCount += count;
    }

    // 把字符串进行 encode 操作
    cartString = json.encode(tempList).toString();

    print(cartList.toString());
    prefs.setString('cartInfo', cartString);  // 进行持久化

    notifyListeners();
  }

  // 获取购物车中的商品
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 获取购物车中的商品，这时是一个字符串
    cartString = prefs.getString('cartInfo');
    // 把 cartlist 进行初始化，防止数据混乱
    cartList = [];
    // 判断得到的字符串是否有值
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice      = 0;
      allGoodsCount = 0;
      isAllCheck    = true;

      tempList.forEach((item){
        if (item['isCheck']) {
          allPrice += (item['count'] * item['price']);
          allGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(new CartInfoModel.fromJson(item));
      });
    }

    print(json.encode(cartList).toString());
    print(allPrice);
    print(allGoodsCount);

    notifyListeners();
  }

  // 清空购物车
  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    print('清空完成 ---------------');
    notifyListeners();
  }

  // 删除单个购物车
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex= 0;
    int delIndex = 0;
    tempList.forEach((item){
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    // 重新获取一次数据
    await getCartInfo();
  }

  // 单选按钮交互效果
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex= 0;
    int changeIndex = 0;

    tempList.forEach((item){
      if (item['goodsId'] == cartItem.goodsId) {
        // 找到索引进行复制
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList[changeIndex] = cartItem.toJson();      // 把对象变成Map值
    cartString = json.encode(tempList).toString();  // 变成字符串
    prefs.setString('cartInfo', cartString);        // 持久化数据
    await getCartInfo();                            // 重新读取列表
  }

  // 点击全选按钮
  changeAllCheckState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    List<Map> newList = []; // 新建一个List，用于组成新的持久化数据

    for(var item in tempList) {
      var newItem = item;           // 复制新的变量，因为Dart不让循环时修改原值
      newItem['isCheck'] = isCheck; // 改变选中状态
      newList.add(newItem);         // 添加数据到新的List
    }

    cartString = json.encode(tempList).toString();  // 变成字符串
    prefs.setString('cartInfo', cartString);        // 持久化数据
    await getCartInfo();                            // 重新读取列表
  }

  // 商品数量加减操作
  addOrReduceAction(var cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex   = 0;
    int changeIndex = 0;

    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    if (todo == 'add') {
      cartItem.count++;
    } else if(cartItem.count > 1) {
      cartItem.count--;
    }

    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();  // 变成字符串
    prefs.setString('cartInfo', cartString);        // 持久化数据
    await getCartInfo();                            // 重新读取列表
  }
}