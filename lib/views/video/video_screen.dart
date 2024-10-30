import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../components/button/arrow_back_button.dart';

class VideoScreen extends ConsumerStatefulWidget {
  final String videoUrl;
  const VideoScreen({
    super.key,
    required this.videoUrl,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  late FlickManager flickManager;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
          widget.videoUrl,
        ),
      );
      await flickManager.flickVideoManager!.videoPlayerController!.initialize();
      setState(() {
        isInitialized = true;
      });
    } catch (e) {
      print("Loi video $e");
    }
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video"),
        leading: ArrowBackButton(
          showSnackbar: false,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: FlickVideoPlayer(
                    flickManager: flickManager,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
