import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_market/routers/application.dart';

/**
 * 楼层内容
 */
class HomeFloorContent extends StatelessWidget {

	final List floorContent;
	HomeFloorContent({Key key, this.floorContent}):super(key:key);

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
				_goodsItem(context, floorContent[0]),
				Column(
					children: <Widget>[
						_goodsItem(context, floorContent[1]),
						_goodsItem(context, floorContent[2]),
					],
				),

			],
		);
	}

	Widget _otherRow(context) {
		return Row(
			children: <Widget>[
				_goodsItem(context, floorContent[3]),
				_goodsItem(context, floorContent[4]),
			],
		);
	}
}
