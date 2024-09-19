import 'package:monstar/data/services/book_service/book_tracking_service.dart';

abstract class ReadingRepository {
  Future<void> startReadingRepository(int storyId);
  Future<double> endReadingRepository(int storyId);
}

class ReadingRepositoryImpl implements ReadingRepository {
  final ReadingService service;
  ReadingRepositoryImpl(this.service);

  @override
  Future<void> startReadingRepository(int storyId) async {
    try {
      await service.startReading(storyId);
    } catch (e) {
      throw Exception("Error in starting read: $e");
    }
  }

  @override
  Future<double> endReadingRepository(int storyId) async {
    try {
      final duration = await service.endReading(storyId);
      return duration;
    } catch (e) {
      throw Exception('Error in ending read: $e');
    }
  }
}
