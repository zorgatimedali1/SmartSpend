// lib/shared/widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;

  const CustomButton({super.key, required this.label, this.onPressed,
    this.isLoading = false, this.isOutlined = false, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    final child = isLoading
        ? SizedBox(height: 20, width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: isOutlined ? c : Colors.white))
        : icon != null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: 18), const SizedBox(width: 8), Text(label)])
            : Text(label);

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: c, side: BorderSide(color: c),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: child,
      );
    }
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: c, foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: child,
    );
  }
}
