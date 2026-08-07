import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/core/errors.dart';

class CustomErrorWidget extends StatelessWidget {
  final Failure error;
  const CustomErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: switch (error.type) {
        ErrorType.connection => _buildError(
          icon: Icons.signal_wifi_off,
          title: AppStrings.errors.connectionTitle,
          subtitle: AppStrings.errors.connectionSubtitle,
        ),
        ErrorType.api => _buildError(
          title: AppStrings.errors.apiTitle,
          subtitle: AppStrings.errors.apiSubtitle,
        ),
        _ => _buildError(title: AppStrings.errors.genericTitle),
      },
    );
  }

  Widget _buildError({
    IconData? icon,
    required String title,
    String? subtitle,
  }) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        icon ?? Icons.error_outline,
        size: 80,
        color: const Color.fromRGBO(161, 45, 36, 1),
      ),
      SizedBox(height: AppSizes.spacing.small),
      Text(title, style: TextStyle(fontSize: AppSizes.font.title)),
      if (subtitle != null)
        Text(subtitle, style: TextStyle(fontSize: AppSizes.font.subtitle)),
    ],
  );
}
