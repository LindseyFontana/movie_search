import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/errors.dart';
import 'package:movie_search/domain/usecases/use_case.dart';

void main() {
  late UseCase<String, int> useCase;

  const params = 1;

  test('returns Right with response when request returns a value', () async {
    useCase = UseCase(request: (_) async => 'result');

    final result = await useCase.call(params);

    expect(result, isA<Right<Failure, String>>());
    expect(result.right, 'result');
  });

  test('returns Left with MissingResponseError when request is null', () async {
    useCase = UseCase(request: (_) async => null);

    final result = await useCase.call(params);

    expect(result, isA<Left<Failure, String>>());
    expect(result.left, isA<MissingResponseError>());
  });

  test('returns Left with the failure thrown by the request', () async {
    const failure = HttpError(message: 'api error', statusCode: 500);
    useCase = UseCase<String, int>(request: (_) async => throw failure);

    final result = await useCase.call(params);

    expect(result, isA<Left<Failure, String>>());
    expect(result.left, failure);
  });

  test('returns Left with GenericError for unknown errors', () async {
    useCase = UseCase<String, int>(
      request: (_) async => throw Exception('exception'),
    );

    final result = await useCase.call(params);

    expect(result, isA<Left<Failure, String>>());
    expect(result.left, isA<GenericError>());
    expect(result.left.type, ErrorType.unknown);
  });
}
