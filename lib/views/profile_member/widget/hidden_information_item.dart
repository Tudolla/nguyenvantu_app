import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/views/profile_member/widget/pin_code_dialog.dart';

import '../../../providers/profile_state_provider.dart';

class PinInputItem extends ConsumerStatefulWidget {
  const PinInputItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinInputItemState();
}

class _PinInputItemState extends ConsumerState<PinInputItem> {
  TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  // Nếu isHidden = false ngay từ đầu thì không nói, vì mặc định ProfileState = false rồi.
  // Nếu isHidden = true thì nó sẽ load dữ liệu sau khi khởi tạo, và cập nhật trạng thái tương ứng.
  Future<void> _toggleHidden(bool value) async {
    final profileNotifier = ref.read(profileStateProvider.notifier);

    if (value) {
      // value ở chuyển sang true, thì là đang bật chế độ ẩn
      // Bật sang chế độ ẩn thông tin cá nhân, tạo mã PIN mới
      // showDialog không phải là widget, nó là 1 hàm, xử lý thao tác đóng mở hộp thoại
      // showDialog trả về 1 future để nhận giá trị trả về khi dialog đóng.
      final pinCode = await showDialog<String>(
        context: context,
        // ở đây, sau khi nhập mã PIN xong, chuyển isSettingPin = true, trả về cả mã PIN đã nhập.
        // bỏ isSettingPin cũng được thì phải
        builder: (context) => PinCodeDialog(isSettingPin: true),
      );

      if (pinCode != null) {
        await profileNotifier.setPinCode(pinCode);
        await profileNotifier.toggleHidden(value); // true
      }
    } else {
      // Tắt chế độ ẩn thông tin cá nhân, xác minh mã PIN
      final enteredPinCode = await showDialog<String>(
        context: context,
        builder: (context) => PinCodeDialog(isSettingPin: false),
      );

      if (enteredPinCode != null &&
          profileNotifier.verifyPinCode(enteredPinCode)) {
        await profileNotifier.toggleHidden(value);
      } else if (enteredPinCode != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text('Incorrect PIN. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileStateProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hidden information",
            style: TextStyle(
              fontSize: 20,
              fontFamily: AppTextStyle.secureFontStyle,
              color: Colors.blueGrey,
            ),
          ),
          Switch(value: profileState.isHidden, onChanged: _toggleHidden),
        ],
      ),
    );
  }
}
