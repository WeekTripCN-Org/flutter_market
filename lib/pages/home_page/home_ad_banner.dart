import 'package:flutter/material.dart';

/**
 * 首页广告 Banner
 */
class HomeAdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
			child: Image.asset("assets/images/home/ad_banner.png") // 读取本地图片
		);
  }
}
