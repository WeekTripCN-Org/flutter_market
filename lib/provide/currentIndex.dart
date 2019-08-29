import 'package:flutter/material.dart';

/**
 * 控制底部导航和页面跳转
 */
class CurrentIndexProvide with ChangeNotifier{
  int currentIndex = 0;

  changeIndex(int newIndex) {
    currentIndex = newIndex;

    notifyListeners();
  }
}