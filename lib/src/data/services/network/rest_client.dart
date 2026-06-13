import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'endpoints.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl, ParseErrorLogger errorLogger}) =
      _RestClient;

  @POST(Endpoints.sendOtp)
  Future<HttpResponse> sendOtp(@Body() Map<String, dynamic> request);

  @POST(Endpoints.verifyOtp)
  Future<HttpResponse> verifyOtp(@Body() Map<String, dynamic> request);

  @GET(Endpoints.myProfile)
  Future<HttpResponse> riderProfile();

  @GET(Endpoints.addresses)
  Future<HttpResponse> getAddresses();

  @POST(Endpoints.logout)
  Future<HttpResponse> logout();

  @POST(Endpoints.registerFCMToken)
  Future<HttpResponse> registerFCMToken(@Body() Map<String, dynamic> request);

  @GET(Endpoints.order)
  Future<HttpResponse> order(@Path('orderId') String orderId);

  @POST(Endpoints.initiateBkashPayment)
  Future<HttpResponse> initiateBkashPayment(@Body() Map<String, dynamic> request);

  @GET(Endpoints.verifyBkashPayment)
  Future<HttpResponse> verifyBkashPayment(@Path('paymentID') String paymentId);

  @GET(Endpoints.queryBkashPayment)
  Future<HttpResponse> queryBkashPayment(@Path('paymentID') String paymentId);

  @GET(Endpoints.notificationsList)
  Future<HttpResponse> getNotifications(
      @Query('limit') int limit,
  );

  @PUT(Endpoints.notificationMarkRead)
  Future<HttpResponse> markNotificationRead(@Path('id') String id);

  @PUT(Endpoints.notificationMarkAllRead)
  Future<HttpResponse> markAllNotificationsRead();
}
