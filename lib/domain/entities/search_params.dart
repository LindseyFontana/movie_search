import 'package:equatable/equatable.dart';

class SearchParams extends Equatable {
  final String query;
  final int pageToSearch;

  const SearchParams({required this.query, required this.pageToSearch});

  @override
  List<Object?> get props => [query, pageToSearch];
}
