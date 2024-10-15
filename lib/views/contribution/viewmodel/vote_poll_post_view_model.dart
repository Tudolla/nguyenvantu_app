import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/api/contribution_repository/pollpost_repository.dart';

class VoteStateViewModel extends StateNotifier<Map<int, bool>> {
  final PollpostRepository _pollpostRepository;
  int? selectedChoiceId; // ID mà đã được chọn

  VoteStateViewModel(this._pollpostRepository) : super({});

  Future<void> vote(int choiceId) async {
    try {
      // cập nhật trạng thái trước
      // Riverpod tự động thông báo các widget liên quan và UI sẽ được cập nhật
      state = {...state, choiceId: true};
      selectedChoiceId = choiceId; // lưu ID được chọn

      // gửi lên server sau
      await _pollpostRepository.votePollPostRepository(choiceId);
    } catch (e) {
      print('Error: $e');
      // Rollback trạng thái nếu có lỗi
      state = {...state, choiceId: false};
    }
  }

  bool hasVoted() {
    return selectedChoiceId != null; // Check xem người dùng đã vote chưa
  }
}
