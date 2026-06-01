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

  @GET(Endpoints.myOrders)
  Future<HttpResponse> myOrders({
    @Query('page') required int page,
    @Query('limit') int limit = 10,
    @Query('status') String? status,
    @Query('sort') String sort = '-createdAt',
  });

  @GET(Endpoints.mySummary)
  Future<HttpResponse> mySummary();

  @GET(Endpoints.order)
  Future<HttpResponse> order(@Path('orderId') String orderId);

  @PATCH(Endpoints.orderStatus)
  Future<HttpResponse> orderStatus(
    @Path('orderId') String orderId,
    @Path('status') String status, {
    @Body() Map<String, dynamic>? body,
  });

  @PATCH(Endpoints.order)
  Future<HttpResponse> updateOrder(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );

  @GET(Endpoints.franchiseRiders)
  Future<HttpResponse> franchiseRiders(@Path('franchiseId') String franchiseId);

  @PATCH(Endpoints.transferOrder)
  Future<HttpResponse> transferOrder(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );

  @POST(Endpoints.initiateBkashPayment)
  Future<HttpResponse> initiateBkashPayment(@Body() Map<String, dynamic> request);

  @GET(Endpoints.verifyBkashPayment)
  Future<HttpResponse> verifyBkashPayment(@Path('paymentID') String paymentId);

  @GET(Endpoints.queryBkashPayment)
  Future<HttpResponse> queryBkashPayment(@Path('paymentID') String paymentId);
}
