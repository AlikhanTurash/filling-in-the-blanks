import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';
import 'package:fitb_pantry_app/src/feature/order/domain/repositories/get_product_repository.dart';

class GetProdictsRepositoryImpl implements GetProductsRepository {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  @override
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
