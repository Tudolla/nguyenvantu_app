import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';

// This is dialog that use for show snall dialog from top of Screen
class FloatingTopDialog extends StatefulWidget {
  final String message;
  final Duration duration;

  FloatingTopDialog({
    required this.message,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _FloatingTopDialogState createState() => _FloatingTopDialogState();
}

class _FloatingTopDialogState extends State<FloatingTopDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();
    _autoHide();
  }

  void _autoHide() {
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 90, 16, 15),
        child: Align(
          alignment: Alignment.topCenter,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(_animation),
            child: FadeTransition(
              opacity: _animation,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(8),
                color: Colors.blueGrey.withOpacity(.7),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        child: LottieBuilder.asset(Assets.bell),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
