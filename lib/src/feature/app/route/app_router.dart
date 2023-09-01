import 'package:auto_route/auto_route.dart';
import 'package:fitb_pantry_app/src/feature/home_page/presentation/screens/home_page.dart';
import 'package:fitb_pantry_app/src/feature/order/data/model/product_model.dart';
import 'package:fitb_pantry_app/src/feature/order_summary/presentation/screens/order_summary_page.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: OrderSummaryRoute.page,
        ),
      ];
}
