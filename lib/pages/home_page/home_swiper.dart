import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_market/routers/application.dart';

/**
 * 首页轮播图片
 */
class HomeSwiper extends StatelessWidget {
	final List swiperDataList;
	HomeSwiper({Key key, this.swiperDataList}):super(key:key);

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