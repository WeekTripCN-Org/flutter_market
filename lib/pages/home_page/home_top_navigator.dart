import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/**
 * 首页单元素导航
 */
class HomeTopNavigator extends StatelessWidget {

	final List navigatorList;
	HomeTopNavigator({Key key, this.navigatorList}):super(key: key);

  @override
  Widget build(BuildContext context) {
		return Container(
			height: ScreenUtil().setHeight(320),
			padding: EdgeInsets.all(3.0),
			child: GridView.count(
				physics: NeverScrollableScrollPhysics(),
				crossAxisCount: 5,
				padding: EdgeInsets.all(4.0),
				children: navigatorList.map((item){
					return _gridViewItemUI(context, item);
				}).toList(),
			),
		);
  }

	Widget _gridViewItemUI(BuildContext context, item) {
		return InkWell(
			onTap: (){print('点击了导航单元素');},
			child: Column(
				children: <Widget>[
					Image.network(item['image'], width: ScreenUtil().setWidth(95),),
					Text(item['mallCategoryName'])
				],
			),
		);
	}
}
