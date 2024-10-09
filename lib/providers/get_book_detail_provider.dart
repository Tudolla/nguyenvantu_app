import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/book_repository/book_repository.dart';
import 'package:monstar/data/services/book_service/book_service.dart';
import 'package:monstar/providers/http_client_provider.dart';
import 'package:monstar/views/book_store/viewmodel/book_detail_view_model.dart';

import '../data/models/api/request/book_model/book_model.dart';

final bookDetailRepositoryProvider = Provider<BookRepository>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final service = BookService(httpClient);
  return BookRepositoryIml(service);
});

final bookDetailViewModelProvider =
    StateNotifierProvider<BookDetailViewmodel, AsyncValue<BookModel?>>((ref) {
  final repository = ref.read(bookDetailRepositoryProvider);
  return BookDetailViewmodel(bookRepository: repository);
});
