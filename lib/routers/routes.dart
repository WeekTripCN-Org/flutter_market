import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

// 路由总体配置
class Routes {
  static String root = '/';
  static String detailsPage   = '/detail';
  static String categoryPage  = '/category';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR========> Route was not found!!!');
      }
    );
    router.define(detailsPage, handler: detailsHandler);
  }
}