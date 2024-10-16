import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/api/contribution_repository/pollpost_repository.dart';

class VoteStateViewModel extends StateNotifier<Map<int, bool>> {
  final PollpostRepository _pollpostRepository;
  int? selectedChoiceId; // ID mà đã được chọn

  VoteStateViewModel(this._pollpostRepository) : super({});

  Future<void> vote(int choiceId) async {
    try {
      // Tìm lựa chọn hiện tại trong danh sách choices
      // final choice = choices.firstWhere((c) => c.id == choiceId);
      // cập nhật trạng thái trước
      // Riverpod tự động thông báo các widget liên quan và UI sẽ được cập nhật
      state = {...state, choiceId: true};
      selectedChoiceId = choiceId; // lưu ID được chọn

      // choice.count = (choice.count )
      // gửi lên server sau
      await _pollpostRepository.votePollPostRepository(choiceId);
    } catch (e) {
      print('Error: $e');
      // Rollback trạng thái nếu có lỗi
      state = {...state, choiceId: false};
    }
  }

  Future<void> removeVote() async {
    if (selectedChoiceId != null) {
      final idRemoved = selectedChoiceId;

      final previousState = state; // lưu trạn thái ban đầu
      final previousSelectedChoiceId =
          selectedChoiceId; // lưu giá trị trước đó của selectdChoiceId
      try {
        //Cập nhật trạng thái trong local trước khi gọi API
        // ..remove , tạo ra bản sao mới của State, sau đó gán lại giá trị mới = state
        state = {...state}..remove(selectedChoiceId);
        selectedChoiceId = null;

        // Gui request to server to remove
        await _pollpostRepository.unVote(idRemoved!);
      } catch (e) {
        // Rollback trạng thái nếu có lỗi

        state = previousState; // Khôi phục trạng thái ban đầu
        selectedChoiceId =
            previousSelectedChoiceId; // Khôi phục lại selectedChoiceId
      }
    }
  }

  bool hasVoted() {
    return selectedChoiceId != null; // Check xem người dùng đã vote chưa
  }
}
