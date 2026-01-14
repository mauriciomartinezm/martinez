import 'package:flutter/material.dart';

typedef VoidCallback = void Function();

class FloatingMessage {
  static Future<void> showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF4CAF50),
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  static Future<void> showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _show(
      context,
      message: message,
      backgroundColor: const Color(0xFFE53935),
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static Future<void> showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF2196F3),
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static VoidCallback? _loadingOverlay;

  static VoidCallback showLoading(
    BuildContext context, {
    required String message,
  }) {
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF2196F3),
      isLoading: true,
      duration: const Duration(minutes: 1),
      isLoadingOverlay: true,
    );
    return hideLoading;
  }

  static void hideLoading() {
    _loadingOverlay?.call();
    _loadingOverlay = null;
  }

  static Future<void> _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    bool isLoading = false,
    bool isLoadingOverlay = false,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else if (icon != null)
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  if (isLoading || icon != null) const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    if (isLoadingOverlay) {
      _loadingOverlay = () => overlayEntry.remove();
    } else if (!isLoading) {
      Future.delayed(duration, () {
        overlayEntry.remove();
      });
    }

    return Future.value();
  }
}
