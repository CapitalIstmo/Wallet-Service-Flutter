import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.tooltipp
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  final String tooltipp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.orange.shade500,
      elevation: 4.0,
      child: IconButton(
        tooltip: tooltipp,
        onPressed: onPressed,
        icon: icon,
        color: Colors.white,
      ),
    );
  }
}
