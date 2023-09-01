import 'package:bloc/bloc.dart';
import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';
import 'package:fitb_pantry_app/src/feature/order/domain/repositories/get_product_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

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
  final GetProductsRepository repository;
}
