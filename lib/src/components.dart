import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/src/tokens.dart';

enum ZamButtonVariant { primary, secondary, outline, ghost, destructive }

enum ZamButtonSize { small, medium, large }

class ZamScreen extends StatelessWidget {
  const ZamScreen({
    required this.child,
    super.key,
    this.padding,
    this.scrollable = false,
    this.safeBottom = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    final content =
        padding == null ? child : Padding(padding: padding!, child: child);

    return SafeArea(
      bottom: safeBottom,
      child: scrollable ? SingleChildScrollView(child: content) : content,
    );
  }
}

class ZamScreenHeader extends StatelessWidget {
  const ZamScreenHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.padding,
    this.compact = false,
    this.backLabel = 'Back',
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final bool compact;
  final String backLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Padding(
      padding: padding ?? theme.insets.screenHeader,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onBack != null)
            Padding(
              padding: theme.insets.only(bottom: theme.spacing.eight),
              child: Semantics(
                button: true,
                label: backLabel,
                onTap: onBack,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack,
                  child: ConstrainedBox(
                    constraints: theme.sizes.minTapTargetConstraints,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          theme.icons.back,
                          size: theme.sizes.iconLg,
                          color: scheme.foreground,
                        ),
                        SizedBox(width: theme.spacing.four),
                        Text(
                          backLabel,
                          style: theme.typography.label(
                            context,
                            color: scheme.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: compact
                          ? theme.typography.emptyTitle(context)
                          : theme.typography.screenTitle(context),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: theme.spacing.two),
                      Text(
                        subtitle!,
                        style: theme.typography.bodySmall(context),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: theme.spacing.twelve),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ZamSectionHeader extends StatelessWidget {
  const ZamSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.typography.title(context)),
              if (subtitle != null) ...[
                SizedBox(height: theme.spacing.two),
                Text(subtitle!, style: theme.typography.bodySmall(context)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: theme.spacing.twelve),
          trailing!,
        ],
      ],
    );
  }
}

class ZamSurface extends StatelessWidget {
  const ZamSurface({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.radius,
    this.withShadow = false,
    this.onTap,
    this.semanticLabel,
  }) : assert(
          onTap == null || semanticLabel != null,
          'Interactive ZamSurface instances must provide semanticLabel.',
        );

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? radius;
  final bool withShadow;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final shad = ShadTheme.of(context);
    final scheme = shad.colorScheme;
    final surface = Container(
      margin: margin,
      padding: padding ?? theme.insets.card,
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.card,
        borderRadius: radius ?? theme.radius.xl,
        border: Border.fromBorderSide(
          theme.strokes.border(borderColor ?? scheme.border),
        ),
        boxShadow: withShadow ? theme.shadows.card(shad.brightness) : null,
      ),
      child: child,
    );

    if (onTap == null) return surface;

    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: onTap,
      child: GestureDetector(onTap: onTap, child: surface),
    );
  }
}

class ZamEmptyState extends StatelessWidget {
  const ZamEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: theme.insets.symmetric(
          horizontal: theme.spacing.sixteen,
          vertical: theme.spacing.twenty,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: theme.sizes.emptyIconContainer,
              height: theme.sizes.emptyIconContainer,
              decoration: BoxDecoration(
                color:
                    theme.opacities.apply(scheme.primary, theme.opacities.tint),
                borderRadius: theme.radius.dialog,
              ),
              child: Icon(
                icon,
                size: theme.sizes.iconHero,
                color: theme.opacities.apply(
                  scheme.primary,
                  theme.opacities.iconEmphasis,
                ),
              ),
            ),
            SizedBox(height: theme.spacing.sixteen),
            Text(
              title,
              style: theme.typography.emptyTitle(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: theme.spacing.six),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: theme.sizes.emptyMessageWidth),
              child: Text(
                message,
                style: theme.typography
                    .bodySmall(context, color: scheme.mutedForeground)
                    .copyWith(height: theme.typography.bodyLineHeight),
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null) ...[
              SizedBox(height: theme.spacing.eighteen),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class ZamStatTile extends StatelessWidget {
  const ZamStatTile({
    required this.label,
    required this.value,
    super.key,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return ZamSurface(
      padding: theme.insets.smallTile,
      radius: theme.radius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.typography.monoCaps(context)),
          SizedBox(height: theme.spacing.four),
          Text(
            value,
            style: theme.typography.title(
              context,
              color: valueColor ?? scheme.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class ZamFilterPill extends StatelessWidget {
  const ZamFilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: theme.sizes.minTapTargetConstraints,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? scheme.secondary : theme.colors.transparent,
              borderRadius: theme.radius.pill,
              border:
                  Border.fromBorderSide(theme.strokes.border(scheme.border)),
            ),
            child: Padding(
              padding: theme.insets.symmetric(
                horizontal: theme.spacing.twelve,
                vertical: theme.spacing.six,
              ),
              child: Text(
                label,
                style:
                    theme.typography.label(context, color: scheme.foreground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ZamButton extends StatelessWidget {
  const ZamButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = ZamButtonVariant.primary,
    this.size = ZamButtonSize.medium,
    this.leading,
    this.isExpanded = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ZamButtonVariant variant;
  final ZamButtonSize size;
  final Widget? leading;
  final bool isExpanded;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final enabled = onPressed != null && !isLoading;
    final shadVariant = switch (variant) {
      ZamButtonVariant.primary => ShadButtonVariant.primary,
      ZamButtonVariant.secondary => ShadButtonVariant.secondary,
      ZamButtonVariant.outline => ShadButtonVariant.outline,
      ZamButtonVariant.ghost => ShadButtonVariant.ghost,
      ZamButtonVariant.destructive => ShadButtonVariant.destructive,
    };
    final shadSize = switch (size) {
      ZamButtonSize.small => ShadButtonSize.sm,
      ZamButtonSize.medium => ShadButtonSize.regular,
      ZamButtonSize.large => ShadButtonSize.lg,
    };

    return Semantics(
      button: true,
      label: label,
      onTap: enabled ? onPressed : null,
      child: ShadButton.raw(
        variant: shadVariant,
        size: shadSize,
        enabled: enabled,
        onPressed: enabled ? onPressed : null,
        leading: isLoading ? const _ZamLoadingDot() : leading,
        width: isExpanded ? double.infinity : null,
        height: theme.sizes.buttonLargeHeight,
        gap: theme.spacing.eight,
        child: Text(label),
      ),
    );
  }
}

class ZamIconButton extends StatelessWidget {
  const ZamIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.variant = ZamButtonVariant.ghost,
    this.size,
    this.semanticLabel,
  }) : assert(
          onPressed == null || semanticLabel != null,
          'Interactive ZamIconButton instances must provide semanticLabel.',
        );

  final Widget icon;
  final VoidCallback? onPressed;
  final ZamButtonVariant variant;
  final double? size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final dimension = size ?? theme.sizes.minTapTarget;
    final shadVariant = switch (variant) {
      ZamButtonVariant.primary => ShadButtonVariant.primary,
      ZamButtonVariant.secondary => ShadButtonVariant.secondary,
      ZamButtonVariant.outline => ShadButtonVariant.outline,
      ZamButtonVariant.ghost => ShadButtonVariant.ghost,
      ZamButtonVariant.destructive => ShadButtonVariant.destructive,
    };

    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: onPressed,
      child: ShadButton.raw(
        variant: shadVariant,
        enabled: onPressed != null,
        onPressed: onPressed,
        width: dimension,
        height: dimension,
        padding: theme.insets.zero,
        child: icon,
      ),
    );
  }
}

class ZamDialog extends StatelessWidget {
  const ZamDialog({
    required this.title,
    required this.message,
    super.key,
    this.icon,
    this.destructive = false,
    this.actions = const [],
  });

  final String title;
  final String message;
  final IconData? icon;
  final bool destructive;
  final List<Widget> actions;

  static Future<void> showMessage({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
  }) {
    return showShadDialog<void>(
      context: context,
      barrierColor: context.zam.colors.black.withValues(
        alpha: context.zam.opacities.strong,
      ),
      builder: (dialogContext) => ZamDialog(
        title: title,
        message: message,
        actions: [
          ZamButton(
            label: confirmText,
            isExpanded: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    bool destructive = false,
  }) async {
    final result = await showShadDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: context.zam.colors.black.withValues(
        alpha: context.zam.opacities.strong,
      ),
      builder: (dialogContext) => ZamDialog(
        title: title,
        message: message,
        icon: icon,
        destructive: destructive,
        actions: [
          ZamButton(
            label: cancelText,
            variant: ZamButtonVariant.outline,
            isExpanded: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          ZamButton(
            label: confirmText,
            variant: destructive
                ? ZamButtonVariant.destructive
                : ZamButtonVariant.primary,
            isExpanded: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Semantics(
      namesRoute: true,
      label: title,
      child: ShadDialog(
        constraints: theme.sizes.dialogConstraints,
        backgroundColor: scheme.card,
        radius: theme.radius.dialog,
        border: Border.all(color: scheme.border),
        padding: theme.insets.dialog,
        title: icon == null
            ? Text(title, style: theme.typography.title(context))
            : Row(
                children: [
                  Container(
                    width: theme.spacing.thirtyTwo,
                    height: theme.spacing.thirtyTwo,
                    decoration: BoxDecoration(
                      color: theme.opacities.apply(
                        destructive ? scheme.destructive : scheme.primary,
                        theme.opacities.subtleTint,
                      ),
                      borderRadius: theme.radius.circular(theme.radius.ten),
                    ),
                    child: Icon(
                      icon,
                      size: theme.sizes.iconSm,
                      color: destructive ? scheme.destructive : scheme.primary,
                    ),
                  ),
                  SizedBox(width: theme.spacing.twelve),
                  Expanded(child: Text(title)),
                ],
              ),
        description: Text(
          message,
          style: theme.typography.body(context, color: scheme.mutedForeground),
        ),
        actions: actions,
      ),
    );
  }
}

class ZamToastContent extends StatelessWidget {
  const ZamToastContent({
    required this.style,
    required this.title,
    super.key,
    this.description,
    this.action,
  });

  final ZamToastStyle style;
  final String title;
  final Widget? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: theme.radius.toast,
        border: Border.fromBorderSide(theme.strokes.border(style.border)),
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            blurRadius: theme.spacing.thirtyTwo,
            offset: Offset(theme.spacing.zero, theme.spacing.twelve),
            spreadRadius: -theme.spacing.eight,
          ),
        ],
      ),
      child: Padding(
        padding: theme.insets.toast,
        child: Row(
          children: [
            Icon(
              style.icon,
              size: theme.sizes.iconSm,
              color: style.iconForeground,
            ),
            SizedBox(width: theme.spacing.twelve),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.typography.title(
                      context,
                      color: style.foreground,
                    ),
                  ),
                  if (description != null) ...[
                    SizedBox(height: theme.spacing.four),
                    DefaultTextStyle(
                      style: theme.typography.bodySmall(
                        context,
                        color: style.subtleForeground,
                      ),
                      child: description!,
                    ),
                  ],
                  if (action != null) ...[
                    SizedBox(height: theme.spacing.twelve),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class ZamToast {
  static void show(
    BuildContext context, {
    required String title,
    ZamToastVariant variant = ZamToastVariant.info,
    Widget? description,
    Widget? action,
    Duration? duration,
    Alignment alignment = Alignment.bottomCenter,
  }) {
    final theme = context.zam;
    final style = theme.toastStyle(ShadTheme.of(context).brightness, variant);
    ShadToaster.of(context).show(
      ShadToast(
        title: ZamToastContent(
          style: style,
          title: title,
          description: description,
          action: action,
        ),
        duration: duration ?? theme.motion.toastDefault,
        alignment: alignment,
        closeIcon: const SizedBox.shrink(),
        padding: theme.insets.zero,
        border: ShadBorder.none,
        radius: theme.radius.zero,
        shadows: const [],
        backgroundColor: theme.colors.transparent,
      ),
    );
  }
}

class ZamSkeleton extends StatefulWidget {
  const ZamSkeleton({
    required this.child,
    super.key,
    this.isLoading = true,
  });

  final Widget child;
  final bool isLoading;

  @override
  State<ZamSkeleton> createState() => _ZamSkeletonState();
}

class _ZamSkeletonState extends State<ZamSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _controller = AnimationController(
      vsync: this,
      duration: context.zam.motion.shimmer,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _initialized = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;
    final scheme = ShadTheme.of(context).colorScheme;
    final theme = context.zam;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                scheme.muted,
                scheme.muted.withValues(alpha: theme.opacities.disabled),
                scheme.muted,
              ],
              stops: const [0, 0.5, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: _ZamSlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }
}

class _ZamSlidingGradientTransform extends GradientTransform {
  const _ZamSlidingGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}

class _ZamLoadingDot extends StatelessWidget {
  const _ZamLoadingDot();

  @override
  Widget build(BuildContext context) {
    final scheme = ShadTheme.of(context).colorScheme;
    final theme = context.zam;
    return SizedBox(
      width: theme.spacing.twelve,
      height: theme.spacing.twelve,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primaryForeground.withValues(
            alpha: theme.opacities.secondary,
          ),
          borderRadius: theme.radius.pill,
        ),
      ),
    );
  }
}
