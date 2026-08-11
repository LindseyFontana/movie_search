import 'package:flutter/material.dart';
import 'package:movie_search/core/constants/app_keys.dart';
import 'package:movie_search/core/constants/app_strings.dart';
import 'package:movie_search/core/constants/app_sizes.dart';
import 'package:movie_search/core/errors.dart';

class CustomErrorWidget extends StatelessWidget {
  final Failure error;
  final VoidCallback? onTryAgain;

  const CustomErrorWidget({super.key, required this.error, this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return switch (error.type) {
      ErrorType.connection => _buildError(
        icon: Icons.signal_wifi_off,
        title: AppStrings.errors.connectionTitle,
        subtitle: AppStrings.errors.connectionSubtitle,
        onPressedButton: onTryAgain,
        context: context,
      ),
      ErrorType.api => _buildError(
        title: AppStrings.errors.apiTitle,
        subtitle: AppStrings.errors.apiSubtitle,
        onPressedButton: onTryAgain,
        context: context,
      ),
      _ => _buildError(title: AppStrings.errors.genericTitle, context: context),
    };
  }

  Widget _buildError({
    IconData? icon,
    required String title,
    String? subtitle,
    VoidCallback? onPressedButton,
    required BuildContext context,
  }) {
    final textStyle = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon ?? Icons.error_outline, size: 80),
          SizedBox(height: AppSizes.spacing.small),
          Text(title, style: textStyle.titleLarge),
          if (subtitle != null) Text(subtitle, style: textStyle.bodyLarge),
          if (onPressedButton != null) ...[
            SizedBox(height: AppSizes.spacing.medium),
            ElevatedButton(
              key: AppKeys.errorRetryButton,
              onPressed: onPressedButton,
              child: Text(AppStrings.errors.retryButton),
            ),
          ],
        ],
      ),
    );
  }
}
