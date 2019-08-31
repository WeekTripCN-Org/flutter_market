import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_market/routers/application.dart';

/**
 * 商品推荐
 */
class HomeRecommend extends StatelessWidget {
	final List recommendList;
	HomeRecommend({Key key, this.recommendList}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
			height: ScreenUtil().setHeight(390),
			margin: const EdgeInsets.only(top: 10.0),
			child: Column(
				children: <Widget>[
					_title(),
					_recommendList()
				],
			),
		);
  }

  Widget _title() {
		return Container(
			alignment: Alignment.centerLeft,
			padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
			decoration: BoxDecoration(
					color: Colors.white,
					border: Border(
						bottom: BorderSide(width: 0.5, color: Colors.black12),
					)
			),
			child: Text(
				'商品推荐',
				style: TextStyle(color: Colors.pink),
			),
		);
	}

	Widget _item(index, context) {
		return InkWell(
			onTap: (){
				Application.router.navigateTo(context, '/detail?id=${recommendList[index]['goodsId']}');
			},
			child: Container(
				height: ScreenUtil().setHeight(330),
				width: ScreenUtil().setWidth(250),
				padding: EdgeInsets.all(8.0),
				decoration: BoxDecoration(
					color: Colors.white,
					border: Border(
						left: BorderSide(width: 0.5, color: Colors.black12),
					),
				),
				child: Column(
					children: <Widget>[
						Image.network(recommendList[index]['image']),
						Text('￥${recommendList[index]['mallPrice']}'),
						Text(
							'￥${recommendList[index]['price']}',
							style: TextStyle(
								decoration: TextDecoration.lineThrough,
								color: Colors.grey,
							),
						),
					],
				),
			),
		);
	}

	Widget _recommendList() {
		return Container(
			height: ScreenUtil().setHeight(330),
			child: ListView.builder(
				scrollDirection: Axis.horizontal,
				itemCount: recommendList.length,
				itemBuilder: (context, index) {
					return _item(index, context);
				},
			),
		);
	}

}
