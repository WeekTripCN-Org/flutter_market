import 'package:flutter/material.dart';

/**
 * 楼层标题
 */
class HomeFloorTitle extends StatelessWidget {
	final String floorImage;
	HomeFloorTitle({Key key, this.floorImage}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
			padding: EdgeInsets.all(8.0),
			child: Image.network(floorImage),
		);
  }
}
