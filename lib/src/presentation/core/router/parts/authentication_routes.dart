part of '../router.dart';

List<GoRoute> _authenticationRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginPage());
      },
      routes: [
        GoRoute(
          path: Routes.otp,
          name: Routes.otp,
          pageBuilder: (context, state) {
            final phone = state.extra as String;

            return MaterialPage(child: OTPVerificationPage(phone: phone));
          },
        ),
      ],
    ),
  ];
}
