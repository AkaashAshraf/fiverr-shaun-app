import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPopup extends StatefulWidget {
  final String url;
  const VideoPopup({super.key, required this.url});

  @override
  State<VideoPopup> createState() => _VideoPopupState();
}

class _VideoPopupState extends State<VideoPopup> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.url.startsWith("http")
        ? VideoPlayerController.network(widget.url)
        : VideoPlayerController.file(File(widget.url));

    controller.initialize().then((_) {
      setState(() {});
      controller.play();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: AspectRatio(
        aspectRatio: controller.value.isInitialized
            ? controller.value.aspectRatio
            : 16 / 9,
        child: controller.value.isInitialized
            ? VideoPlayer(controller)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
