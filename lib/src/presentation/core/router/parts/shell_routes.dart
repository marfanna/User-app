part of '../router.dart';

StatefulShellRoute _shellRoutes(Ref ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return BottomNavBar(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.home,
            name: Routes.home,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: ExploreScreen());
            },
          ),
          GoRoute(
            path: Routes.restaurants,
            name: Routes.restaurants,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: RestaurantsHomeScreen());
            },
          ),
          GoRoute(
            path: Routes.medicine,
            name: Routes.medicine,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: MedicineHomeScreen());
            },
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.orders,
            name: Routes.orders,
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: OrderTabScreen());
            },
            routes: [
              GoRoute(
                path: ':id',
                name: Routes.orderDetails,
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  final orderId = state.pathParameters['id']!;
                  return MaterialPage(child: OrderDetailsScreen(orderId: orderId));
                },
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.leaderboard,
            name: Routes.leaderboard,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LeaderboardTabScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.profile,
            name: Routes.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileTabScreen()),
          ),
        ],
      ),
    ],
  );
}
