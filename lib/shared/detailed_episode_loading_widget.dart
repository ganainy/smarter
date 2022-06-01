import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarter/shared/shimmer_widget.dart';

class DetailedEpsiodeViewLoadingWidget extends StatefulWidget {
  @override
  State<DetailedEpsiodeViewLoadingWidget> createState() =>
      _DetailedEpsiodeViewLoadingWidgetState();
}

class _DetailedEpsiodeViewLoadingWidgetState
    extends State<DetailedEpsiodeViewLoadingWidget> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ShimmerWidget(width: 900.w),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ShimmerWidget(width: 700.w),
          ),
          const SizedBox(height: 8.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white38,
            ),
            alignment: Alignment.center,
            child: ShimmerWidget(width: 400.w),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ShimmerWidget(width: 600.w),
          ),
        ],
      ),
    );
  }
}
