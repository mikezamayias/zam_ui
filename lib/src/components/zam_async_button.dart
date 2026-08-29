part of '../components.dart';

/// Signature for asynchronous button press callbacks.
typedef ZamAsyncCallback = Future<void> Function();

/// Button whose enabled state is tied to an asynchronous [onPressed] callback.
///
/// While the returned [Future] is in flight the button disables itself and
/// shows the standard [ZamButton] loading indicator, preventing double-taps
/// and overlapping invocations. It re-enables when the future completes or
/// fails. Errors are never swallowed; they propagate to the caller's zone
/// after the button re-enables.
///
/// Visual configuration is composed through [variant] and [size] rather than
/// named constructors, matching the library's variant-enum model.
class ZamAsyncButton extends StatefulWidget {
  /// Creates a [ZamAsyncButton].
  const ZamAsyncButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = ZamButtonVariant.primary,
    this.size = ZamButtonSize.medium,
    this.leading,
    this.trailing,
    this.isExpanded = false,
    this.enabled,
    this.width,
    this.height,
    this.padding,
  }) : assert(
          label != null || child != null,
          'ZamAsyncButton requires either label or child.',
        );

  /// Button text label.
  final String? label;

  /// Custom child widget.
  final Widget? child;

  /// Asynchronous callback executed when the button is pressed.
  final ZamAsyncCallback? onPressed;

  /// Visual variant style.
  final ZamButtonVariant variant;

  /// Size configuration.
  final ZamButtonSize size;

  /// Optional leading widget (icon/avatar).
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Whether the button should expand to fill horizontal width.
  final bool isExpanded;

  /// Explicit enable/disable state override.
  final bool? enabled;

  /// Custom width.
  final double? width;

  /// Custom height.
  final double? height;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  @override
  State<ZamAsyncButton> createState() => _ZamAsyncButtonState();
}

class _ZamAsyncButtonState extends State<ZamAsyncButton> {
  bool _isInFlight = false;

  Future<void> _handlePressed() async {
    if (_isInFlight) {
      return;
    }
    setState(() => _isInFlight = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _isInFlight = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZamButton(
      label: widget.label,
      onPressed: widget.onPressed == null ? null : _handlePressed,
      variant: widget.variant,
      size: widget.size,
      leading: widget.leading,
      trailing: widget.trailing,
      isExpanded: widget.isExpanded,
      isLoading: _isInFlight,
      enabled: widget.enabled,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      child: widget.child,
    );
  }
}
