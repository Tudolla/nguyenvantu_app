import 'package:monstar/data/repository/api/book_repository/book_tracking_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

class BookTrackingViewModel extends BaseViewModel<void> {
  final ReadingRepository readingRepository;

  BookTrackingViewModel(this.readingRepository) : super(null);

  Future<void> startRading(int storyId) async {
    setLoading();
    try {
      await readingRepository.startReadingRepository(storyId);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }

  Future<void> endReading(int storyId) async {
    setLoading();
    try {
      await readingRepository.endReadingRepository(storyId);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }
}
