import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/book_repository/book_tracking_repository.dart';

class BookTrackingViewModel extends StateNotifier<void> {
  final ReadingRepository readingRepository;

  BookTrackingViewModel(this.readingRepository) : super(null);

  Future<void> startRading(int storyId) async {
    try {
      await readingRepository.startReadingRepository(storyId);
    } catch (e) {
      print("Error start tracking : $e ");
    }
  }

  Future<void> endReading(int storyId) async {
    try {
      await readingRepository.endReadingRepository(storyId);
    } catch (e) {
      print("Error end tracking: $e");
    }
  }
}
