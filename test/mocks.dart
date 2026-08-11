import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_search/data/data_source/remote/http_service.dart';
import 'package:movie_search/data/data_source/remote/movie_data_source.dart';

class MockMovieDataSource extends Mock implements MovieDataSource {}

class MockHttpService extends Mock implements HttpService {}

class MockDio extends Mock implements Dio {}
