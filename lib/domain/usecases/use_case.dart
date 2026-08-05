import 'package:either_dart/either.dart';
import 'package:movie_search/core/errors.dart';

class UseCase<T, Params> {
  final Future<T?> Function(Params params) request;

  const UseCase({required this.request});

  Future<Either<Exception, T>> call(Params params) => _onRequest(params);

  Future<Either<Exception, T>> _onRequest(Params param) async {
    try {
      final response = await request.call(param);

      if (response != null) {
        return Right(response);
      }

      throw MissingResponseError(message: 'Response is a null value');
    } on HttpError catch (error) {
      return Left(error);
    } catch (error, stackTrace) {
      return Left(
        GenericError(message: "Erro desconhecido", stackTrace: stackTrace),
      );
    }
  }
}
