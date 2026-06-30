import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

class SensitiveWidget extends StatefulWidget {
  final Widget child;

  final double? blurSigma;

  final Color? overlayColor;

  final bool enabled;

  const SensitiveWidget({
    super.key,
    required this.child,
    this.blurSigma,
    this.overlayColor,
    this.enabled = true,
  });

  @override
  State<SensitiveWidget> createState() => _SensitiveWidgetState();
}

class _SensitiveWidgetState extends State<SensitiveWidget> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return GestureDetector(
      onTap: () => setState(() => _obscured = !_obscured),
      child: Stack(
        children: [
          widget.child,
          if (_obscured)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.overlayColor ?? const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.blurSigma ?? 10.0,
                      sigmaY: widget.blurSigma ?? 10.0,
                    ),
                    child: Container(
                      color: (widget.overlayColor ?? const Color(0xFF1A1A2E))
                          .withAlpha(153),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
