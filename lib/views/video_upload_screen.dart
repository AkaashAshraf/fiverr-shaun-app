import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaunking_app/core/constants/colors.dart';
import 'package:shaunking_app/controllers/video_upload_controller.dart';
import 'package:shaunking_app/core/widgets/appbar.dart';
import 'package:shaunking_app/core/widgets/video_player.dart';
import 'package:shaunking_app/views/screens/home_screen.dart';
import 'package:video_player/video_player.dart';

class VideoUploadScreen extends StatelessWidget {
  VideoUploadScreen({super.key});

  final controller = Get.put(VideoUploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const MyAppBar(
                end: Icon(
                  Icons.contacts,
                  color: Colors.white,
                  size: 20,
                ),
                title: "Work Profile",
              ),

              /// VIDEO BOX
              _videoBox(controller),

              const SizedBox(height: 16),

              /// SAVE CHANGES
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Save Changes"),
                    ),
                  )),

              const SizedBox(height: 20),

              /// STATIC BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color.fromARGB(255, 215, 212, 212),
                    width: 0.5,
                  ),
                ),
                child: const Text(
                  "Video to text conversion: Text displays here stored into Database",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),

              const Spacer(),

              /// NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.saveChanges();
                    Get.to(const HomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// VIDEO BOX WIDGET
  Widget _videoBox(VideoUploadController controller) {
    return Obx(() {
      String path = controller.localVideoPath.value.isNotEmpty
          ? controller.localVideoPath.value
          : controller.uploadedVideoUrl.value;

      bool hasVideo = path.isNotEmpty;

      return Stack(
        children: [
          GestureDetector(
            onTap: hasVideo ? null : controller.pickVideo,
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: hasVideo
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: VideoPlayerWidget(path: path),
                        ),
                        Icon(
                          Icons.play_circle_fill,
                          size: 60,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              Get.dialog(VideoPopup(url: path));
                            },
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "Tap to select video",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
            ),
          ),

          /// CROSS BUTTON
          if (hasVideo)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // Remove video
                  if (controller.localVideoPath.value.isNotEmpty) {
                    controller.localVideoPath.value = '';
                  } else if (controller.uploadedVideoUrl.value.isNotEmpty) {
                    controller.deleteVideoCompletely();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

/// INLINE VIDEO PLAYER WIDGET
class VideoPlayerWidget extends StatefulWidget {
  final String path;
  const VideoPlayerWidget({super.key, required this.path});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.path.startsWith("http")
        ? VideoPlayerController.network(widget.path)
        : VideoPlayerController.file(File(widget.path));

    controller.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? VideoPlayer(controller)
        : const Center(child: CircularProgressIndicator());
  }
}
