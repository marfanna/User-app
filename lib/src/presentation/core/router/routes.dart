class Routes {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String otp = 'otp';

  // Bottom Nav Tabs
  static const String home = '/home';
  static const String orders = '/orders';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';

  // Onboarding setup
  static const String enterName = '/enter-name';
  static const String selectArea = '/select-area';

  // Other pages
  static const String restaurants = '/restaurants';
  static const String medicine = '/medicine';
  static const String medicineCategories = '/medicine/categories';
  static const String medicineProduct = '/medicine/product/:id';
  static String medicineProductPath(String id) => '/medicine/product/$id';
  static const String pharmacy = '/pharmacy/:id';
  static String pharmacyPath(String id) => '/pharmacy/$id';
  static const String medicineListing = '/medicine/listing';
  static const String restaurantDetail = '/restaurant/:id';
  static String restaurantDetailPath(String id) => '/restaurant/$id';
  static const String restaurantReviews = '/restaurant-reviews';
  static const String addFood = '/add-food';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String orderDetails = 'order/:id';
  static const String trackOrder = '/track-order';
  static const String notifications = '/notifications';
  static const String wallet = '/wallet';
  static const String addressBook = '/address-book';
  static const String addAddress = '/add-address';
  static const String editProfile = '/edit-profile';
  static const String support = '/support';
  static const String bkashPayment = '/bkash-payment';
  static const String search = '/search';
  static const String favourites = '/favourites';
  static const String dispute = '/dispute/:orderId';
  static String disputePath(String orderId) => '/dispute/$orderId';
  static const String disputes = '/disputes';
  static const String myRewards = '/my-rewards';
}
