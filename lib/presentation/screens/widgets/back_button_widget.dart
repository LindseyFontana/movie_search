import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final bool hasShadow;

  const BackButtonWidget({super.key, required this.hasShadow});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      customBorder: const CircleBorder(),
      child: hasShadow
          ? Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(125, 125, 125, 0.63),
                shape: BoxShape.circle,
              ),
              child: _icon,
            )
          : _icon,
    );
  }

  Widget get _icon => Padding(
    padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
  );
}
