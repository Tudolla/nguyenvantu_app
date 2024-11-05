import 'package:flutter/material.dart';

void bottomSnackbar(
  BuildContext context,
  String message,
  String? extraMessage,
) {
  // Tạo Animation Controller
  final animationController = AnimationController(
    duration: Duration(milliseconds: 500),
    vsync: Navigator.of(context),
  );

  // Tạo Tween cho SlideTransition để di chuyển từ dưới lên
  final offsetTween = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0));

  // OverlayEntry để hiển thị widget
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: offsetTween.animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOut,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Text(
                  extraMessage ?? "",
                  style:
                      TextStyle(color: const Color.fromARGB(255, 78, 123, 219)),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  // Thêm OverlayEntry vào Overlay và bắt đầu hiệu ứng
  Overlay.of(context).insert(overlayEntry);
  animationController.forward();

  // Đóng SnackBar sau một thời gian nhất định
  Future.delayed(Duration(seconds: 2), () {
    animationController.reverse().then((_) {
      overlayEntry.remove();
    });
  });
}
