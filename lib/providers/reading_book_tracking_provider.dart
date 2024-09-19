import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/book_repository/book_tracking_repository.dart';
import 'package:monstar/data/services/book_service/book_tracking_service.dart';
import 'package:monstar/views/book_store/viewmodel/book_tracking_viewmodel.dart';

final readingServiceProvider = Provider<ReadingService>((ref) {
  return ReadingService();
});

final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  final readingService = ref.watch(readingServiceProvider);
  return ReadingRepositoryImpl(readingService);
});

final readingTrackingViewModelProvider =
    StateNotifierProvider<BookTrackingViewModel, void>((ref) {
  final readingRepository = ref.watch(readingRepositoryProvider);
  return BookTrackingViewModel(readingRepository);
});
