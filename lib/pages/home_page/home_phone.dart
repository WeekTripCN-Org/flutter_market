import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * 拨打店长电话
 */
class HomePhone extends StatelessWidget {
	final String phoneImage;
	final String phoneNumber;

	HomePhone({Key key, this.phoneImage, this.phoneNumber}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
			child: InkWell(
				onTap: _callPhone,
				child: Image.network(phoneImage),
			),
		);
  }

  void _callPhone() async {
		String url = 'tel:' + phoneNumber;
		if (await canLaunch(url)) {
			await launch(url);
		} else {
			throw 'Could not launch $url';
		}
	}
}
