import 'package:either_dart/either.dart';
import 'package:movie_search/core/errors.dart';

class UseCase<T, Params> {
  final Future<T?> Function(Params params) request;

  const UseCase({required this.request});

  Future<Either<Failure, T>> call(Params params) => _onRequest(params);

  Future<Either<Failure, T>> _onRequest(Params param) async {
    try {
      final response = await request.call(param);

      if (response != null) {
        return Right(response);
      }

      return Left(
        MissingResponseError(
          message: 'Response is a null value',
          type: ErrorType.unknown,
        ),
      );
    } on Failure catch (error) {
      return Left(error);
    } catch (error, stackTrace) {
      return Left(
        GenericError(
          message: error.toString(),
          stackTrace: stackTrace,
          type: ErrorType.unknown,
        ),
      );
    }
  }
}
