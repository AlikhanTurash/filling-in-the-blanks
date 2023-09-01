import 'package:bloc/bloc.dart';
import 'package:fitb_pantry_app/src/feature/order/data/model/product_model.dart';
import 'package:fitb_pantry_app/src/feature/order/data/repositories/get_products_repositroy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_bloc.freezed.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required this.repository,
  }) : super(const _Initial()) {
    on<_GetProductsEvent>(
      (event, emit) async {
        emit(
          const _Loading(),
        );
        try {
          final List<ProductModel> listOfProducts =
              await repository.getProducts();
          emit(
            _Success(listOfProducts: listOfProducts),
          );
        } catch (e) {
          emit(
            _Error(
              errorText: e.toString(),
            ),
          );
        }
      },
    );
  }
  final GetProductsRepositoryImpl repository;
}
