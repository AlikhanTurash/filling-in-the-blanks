import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitb_pantry_app/src/feature/order/data/model/product_model.dart';

class GetProductsRepositoryImpl {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  Future<List<ProductModel>> getProducts() async {
    final collection = await store.collection('Items').get();
    final products = collection.docs.map((doc) {
      return ProductModel.fromJson(
        doc.data(),
      );
    }).toList();
    return products;
  }
}
