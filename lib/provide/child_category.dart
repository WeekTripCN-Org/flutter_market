import 'package:flutter/material.dart';
import '../model/category.dart';

// ChangeNotifier 的混入是不用管理听众
class ChildCategory with ChangeNotifier
{
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;       // 大类对应小类索引
  String categoryId = '4';  // 大类索引ID
  String subId = '';        // 小类ID

  int page = 1;             // 列表页数，当改变大类或子类时也进行改变
  String noMoreText = '';   // 显示更多的标识
  bool isNewCategory = true;// 是否新的类

  // 点击大类时更换
  getChildCategory(List<BxMallSubDto> list, String id) {
    isNewCategory = true;
    categoryId = id;
    childIndex = 0;

    // 重新初始化参数
    page = 1;
    noMoreText = '';
    subId = ''; // 点击大类时，把子类ID清空

    BxMallSubDto all = BxMallSubDto();
    // 增加全部子类
    all.mallSubId='';
    all.mallSubName = '全部';
    all.mallCategoryId = '00';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(int index, String id) {
    isNewCategory = true; // 新的大类/子类

    childIndex = index;
    subId = id;

    // 重新初始化参数
    page = 1;
    noMoreText = '';

    notifyListeners();
  }

  // 增加页数
  addPage() {
    page++;
  }

  // 改变 noMoreText 数据
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

  // 改变为 false
  changeFalse(){
    isNewCategory = false;
  }
}