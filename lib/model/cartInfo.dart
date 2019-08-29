/**
 *  购物车数据模型文件
 *
 * {"goodsId":"d0a2f888f9df48609aab3ed3721d8d88","goodsName":"红花郎15年53°500ml","count":1,"price":558.0,"images":"http://images.baixingliangfan.cn/shopGoodsImg/20181121/20181121172615_4947.jpg"}
 */

class CartInfoModel {
  String goodsId;
  String goodsName;
  int count;
  double price;
  String images;
  bool isCheck; // 选中字段

  CartInfoModel(
      {this.goodsId, this.goodsName, this.count, this.price, this.images, this.isCheck});

  CartInfoModel.fromJson(Map<String, dynamic> json) {
    goodsId   = json['goodsId'];
    goodsName = json['goodsName'];
    count     = json['count'];
    price     = json['price'];
    images    = json['images'];
    isCheck   = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsId']   = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['count']     = this.count;
    data['price']     = this.price;
    data['images']    = this.images;
    data['isCheck']   = this.isCheck;
    return data;
  }
}