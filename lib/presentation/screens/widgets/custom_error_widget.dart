import 'package:flutter/material.dart';
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
          title: 'Erro de conexão!',
          subtitle: 'Confira sua conexão e tente novamente.',
        ),
        ErrorType.api => _buildError(
          title: 'Ocorreu um erro!',
          subtitle: 'Tente novamente.',
        ),
        _ => _buildError(title: 'Ocorreu um erro!'),
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
      SizedBox(height: 8),
      Text(title, style: TextStyle(fontSize: 24)),
      if (subtitle != null) Text(subtitle, style: TextStyle(fontSize: 20)),
    ],
  );
}
