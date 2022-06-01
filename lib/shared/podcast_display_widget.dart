import 'package:flutter/material.dart';

class PodcastDisplayWidget extends StatefulWidget {
  final String posterUrl;
  final String name;
  final BuildContext context;
  const PodcastDisplayWidget({
    Key? key,
    required this.name,
    required this.posterUrl,
    required this.context,
  }) : super(key: key);

  @override
  State<PodcastDisplayWidget> createState() => _PodcastDisplayWidgetState();
}

class _PodcastDisplayWidgetState extends State<PodcastDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    var networkImage = Image.network(
      widget.posterUrl,
      fit: BoxFit.cover,
    );

    var _imageOpacity = 0;

    //listener to get when the image is fully loaded to start the fade in animation
    networkImage.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, call) {
          setState(() {
            _imageOpacity = 1;
          });
        },
      ),
    );

    return Container(
      height: 160.0,
      width: 100.0,
      margin: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: Column(
        children: [
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _imageOpacity.toDouble(),
              child: networkImage,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
