class ProductModel {
  String? image;
  String? id;
  String? group;

  ProductModel({this.image, this.id, this.group});

  ProductModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['id'] = id;
    data['group'] = group;
    return data;
  }
}
