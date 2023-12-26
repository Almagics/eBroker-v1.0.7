import '../../../utils/Extensions/extensions.dart';
import '../../../utils/ui_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GalleryViewWidget extends StatefulWidget {
  final List images;
  final int initalIndex;
  const GalleryViewWidget(
      {super.key, required this.images, required this.initalIndex});

  @override
  State<GalleryViewWidget> createState() => _GalleryViewWidgetState();
}

class _GalleryViewWidgetState extends State<GalleryViewWidget> {
  late PageController controller =
      PageController(initialPage: widget.initalIndex);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.color.teritoryColor),
      ),
      backgroundColor: const Color.fromARGB(17, 0, 0, 0),
      body: ScrollConfiguration(
        behavior: RemoveGlow(),
        child: PageView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return CachedNetworkImage(imageUrl: widget.images[index]);
          },
          itemCount: widget.images.length,
        ),
      ),
    );
  }
}
