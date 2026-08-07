import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_sizes.dart';

class DefaultText extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;

  const DefaultText(this.title, {super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(color: Color.fromARGB(255, 59, 58, 58)),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.padding.smallest),
        child: Center(child: Text(title)),
      ),
    );
  }
}
