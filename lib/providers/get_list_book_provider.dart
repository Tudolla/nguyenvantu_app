import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/repository/api/book_repository/book_repository.dart';
import 'package:monstar/data/services/book_service/book_service.dart';
import 'package:monstar/providers/http_client_provider.dart';
import 'package:monstar/views/book_store/viewmodel/book_view_model.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final service = BookService(httpClient);
  return BookRepositoryIml(service);
});

final bookListViewModelProvider =
    StateNotifierProvider<BookViewmodel, AsyncValue<List<BookModel>>>((ref) {
  final repository = ref.read(bookRepositoryProvider);
  return BookViewmodel(bookRepository: repository);
});
