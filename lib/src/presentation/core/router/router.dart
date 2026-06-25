import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/extensions/riverpod_extensions.dart';
import '../../../core/logger/log.dart';
import '../../features/authentication/login/view/login_page.dart';
import '../../features/authentication/otp/view/otp_verification_page.dart';
import '../../features/onboarding/view/onboarding_page.dart';
import '../../features/splash/view/splash_page.dart';

import '../../features/onboarding/enter_name/view/enter_name_screen.dart';
import '../../features/onboarding/select_area/view/select_area_screen.dart';
import '../../features/explore/view/explore_screen.dart';
import '../../features/home/view/restaurants_home_screen.dart';
import '../../features/medicine_home/view/medicine_home_screen.dart';
import '../../features/medicine_home/view/medicine_categories_screen.dart';
import '../../features/medicine_home/view/medicine_product_detail_screen.dart';
import '../../features/medicine_home/view/pharmacy_storefront_screen.dart';
import '../../features/medicine_home/view/medicine_listing_screen.dart';
import '../../features/medicine_home/models/medicine_product_args.dart';
import '../../features/medicine_home/models/medicine_listing_args.dart';
import '../../features/restaurant_detail/models/restaurant_api_models.dart';
import '../../features/restaurant_detail/view/restaurant_detail_screen.dart';
import '../../features/restaurant_detail/view/restaurant_reviews_screen.dart';
import '../../features/cart/view/cart_screen.dart';
import '../../features/checkout/view/bkash_payment_screen.dart';
import '../../features/checkout/view/checkout_screen.dart';
import '../../features/add_food/view/add_food_screen.dart';
import '../../features/orders/view/order_success_screen.dart';
import '../../features/orders/view/order_details_screen.dart';
import '../../features/orders/view/order_tab_screen.dart';
import '../../features/leaderboard/view/leaderboard_tab_screen.dart';
import '../../features/profile/view/profile_tab_screen.dart';
import '../../features/track_order/view/track_order_screen.dart';
import '../../features/notifications/view/notifications_screen.dart';
import '../../features/wallet/view/wallet_screen.dart';
import '../../features/address_book/view/address_book_screen.dart';
import '../../features/address_book/view/add_address_screen.dart';
import '../../features/profile/view/edit_profile_screen.dart';
import '../../features/support/view/support_screen.dart';
import '../../features/search/view/search_screen.dart';
import '../../features/favourites/view/favourites_screen.dart';
import '../../features/orders/view/dispute_screen.dart';
import '../../features/orders/view/dispute_list_screen.dart';
import '../../features/rewards/view/my_rewards_screen.dart';

import '../widgets/app_startup/startup_widget.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'router_state/router_state_provider.dart';
import 'routes.dart';

part 'parts/authentication_routes.dart';
part 'parts/on_boarding_routes.dart';
part 'parts/shell_routes.dart';
part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root');

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    refreshListenable: ref.asListenable(routerStateProvider),
    initialLocation: Routes.initial,
    redirect: (context, state) {
      Log.info('Router fired for: ${state.uri}');
      final routerValue = ref.asListenable(routerStateProvider).value;
      if ([
        Routes.initial,
        Routes.onboarding,
        Routes.splash,
      ].contains(state.uri.path)) {
        return routerValue;
      }
      // Background franchise validation can flip state to selectArea
      // while user is already on home — redirect them out.
      if (routerValue == Routes.selectArea) {
        return Routes.selectArea;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.initial,
        name: Routes.initial,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: AppStartupWidget(
              loading: SplashPage(),
              loaded: SplashPage(),
            ),
          );
        },
      ),
      ..._onboardingRoutes(ref),
      ..._authenticationRoutes(ref),
      GoRoute(
        path: Routes.enterName,
        name: Routes.enterName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: EnterNameScreen()),
      ),
      GoRoute(
        path: Routes.selectArea,
        name: Routes.selectArea,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SelectAreaScreen()),
      ),
      GoRoute(
        path: '${Routes.orderSuccess}/:id',
        name: Routes.orderSuccess,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return MaterialPage(child: OrderSuccessScreen(orderId: id));
        },
      ),

      GoRoute(
        path: '${Routes.trackOrder}/:id',
        name: Routes.trackOrder,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return NoTransitionPage(child: TrackOrderScreen(orderId: id));
        },
      ),
      // Medicine home itself lives inside the bottom-nav shell (see
      // shell_routes.dart). These are the full-screen detail pages, mirroring
      // how restaurant detail / add-food sit outside the shell.
      GoRoute(
        path: Routes.medicineCategories,
        name: Routes.medicineCategories,
        pageBuilder: (context, state) =>
            const MaterialPage(child: MedicineCategoriesScreen()),
      ),
      GoRoute(
        path: Routes.medicineProduct,
        name: Routes.medicineProduct,
        pageBuilder: (context, state) {
          final args = state.extra as MedicineProductArgs;
          return MaterialPage(child: MedicineProductDetailScreen(args: args));
        },
      ),
      GoRoute(
        path: Routes.medicineListing,
        name: Routes.medicineListing,
        pageBuilder: (context, state) {
          final args = state.extra as MedicineListingArgs;
          return MaterialPage(child: MedicineListingScreen(args: args));
        },
      ),
      GoRoute(
        path: Routes.pharmacy,
        name: Routes.pharmacy,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return NoTransitionPage(
            child: PharmacyStorefrontScreen(shopId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.restaurantDetail,
        name: Routes.restaurantDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return NoTransitionPage(
            child: RestaurantDetailScreen(restaurantId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.restaurantReviews,
        name: Routes.restaurantReviews,
        pageBuilder: (context, state) {
          final restaurant = state.extra as RestaurantData?;
          return NoTransitionPage(
            child: RestaurantReviewsScreen(restaurant: restaurant),
          );
        },
      ),
      GoRoute(
        path: Routes.cart,
        name: Routes.cart,
        pageBuilder: (context, state) =>
            const MaterialPage(child: CartScreen()),
      ),
      GoRoute(
        path: Routes.checkout,
        name: Routes.checkout,
        pageBuilder: (context, state) =>
            const MaterialPage(child: CheckoutScreen()),
      ),
      GoRoute(
        path: Routes.addFood,
        name: Routes.addFood,
        pageBuilder: (context, state) {
          final args = state.extra as AddFoodArgs;
          return MaterialPage(child: AddFoodScreen(args: args));
        },
      ),
      GoRoute(
        path: Routes.notifications,
        name: Routes.notifications,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: NotificationsScreen()),
      ),
      GoRoute(
        path: Routes.wallet,
        name: Routes.wallet,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: WalletScreen()),
      ),
      GoRoute(
        path: Routes.addressBook,
        name: Routes.addressBook,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AddressBookScreen()),
      ),
      GoRoute(
        path: Routes.addAddress,
        name: Routes.addAddress,
        pageBuilder: (context, state) =>
            const MaterialPage(child: AddAddressScreen()),
      ),
      GoRoute(
        path: Routes.editProfile,
        name: Routes.editProfile,
        pageBuilder: (context, state) =>
            const MaterialPage(child: EditProfileScreen()),
      ),
      GoRoute(
        path: Routes.support,
        name: Routes.support,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SupportScreen()),
      ),
      GoRoute(
        path: Routes.search,
        name: Routes.search,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SearchScreen()),
      ),
      GoRoute(
        path: Routes.favourites,
        name: Routes.favourites,
        pageBuilder: (context, state) =>
            const MaterialPage(child: FavouritesScreen()),
      ),
      GoRoute(
        path: Routes.dispute,
        name: Routes.dispute,
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return MaterialPage(child: DisputeScreen(orderId: orderId));
        },
      ),
      GoRoute(
        path: Routes.disputes,
        name: Routes.disputes,
        pageBuilder: (context, state) =>
            const MaterialPage(child: DisputeListScreen()),
      ),
      GoRoute(
        path: Routes.myRewards,
        name: Routes.myRewards,
        pageBuilder: (context, state) =>
            const MaterialPage(child: MyRewardsScreen()),
      ),
      GoRoute(
        path: Routes.bkashPayment,
        name: Routes.bkashPayment,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return MaterialPage(
            child: BkashPaymentScreen(
              checkoutUrl: args['checkoutUrl'] as String,
              paymentId: args['paymentId'] as String,
              orderId: args['orderId'] as String,
            ),
          );
        },
      ),
      _shellRoutes(ref),
    ],
  );
}
