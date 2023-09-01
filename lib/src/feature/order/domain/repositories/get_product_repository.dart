import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';

abstract class GetProductsRepository {
  Future<List<ProductModel>> getProducts() {
    throw UnimplementedError();
  }
}
