import 'package:example/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jack_api/jack_api.dart';

void main() {
  late DioAdapter adapter;
  late TestApi service;

  setUp(() async {
    service = TestApi("https://fakestoreapi.com");
    adapter = DioAdapter(
      dio: service.rest.dio,
      matcher: const FullHttpRequestMatcher(),
    );
  });

  test("Api failed", () async {
    // arrange
    adapter
      ..onGet(
        "/products",
        (server) => server.throws(
          401,
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(
              path: "/products",
            ),
          ),
          // Adds one-sec delay to reply method.
          // Basically, I'd wait for one second before returning reply data.
          // See -> issue:[106] & pr:[126]
          delay: const Duration(seconds: 1),
        ),
      )
      ..onGet("/test", (server) => server.reply(200, {"test": "true"}));

    expect(
        () async => await service.getProduct(), throwsA(isA<DioException>()));

    final tested = await service.getTest();

    expect(tested, 200);
  });
}
