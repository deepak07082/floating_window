import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/pip_settings.dart';
import 'pip_controller.dart';

class PipPlayer extends StatefulWidget {
  const PipPlayer({
    required this.controller,
    required this.content,
    super.key,
    this.controls,
    this.onClose,
    this.onExpand,
    this.onTap,
    this.onTapDown,
    this.onTapCancel,
    this.onLongPress,
  });

  final PipController controller;
  final Widget content;
  final Widget? controls;
  final VoidCallback? onClose;
  final VoidCallback? onExpand;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final VoidCallback? onTapCancel;
  final VoidCallback? onLongPress;

  @override
  State<PipPlayer> createState() => _PipPlayerState();
}

class _PipPlayerState extends State<PipPlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    final settings = widget.controller.settings;
    _animationController = AnimationController(
      vsync: this,
      duration: settings.animationDuration,
    );
    final curved = CurvedAnimation(
      parent: _animationController,
      curve: settings.animationCurve,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(curved);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(curved);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDrag(
    PipController controller,
    PipSettings settings,
    DragUpdateDetails details,
  ) {
    if (settings.allowDrag) {
      final newPosition = controller.position.offset + details.delta;
      controller.updatePosition(newPosition);
    }
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Alignment alignment = Alignment.topRight,
  }) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: Consumer<PipController>(
        builder: (context, controller, child) {
          if (!controller.isVisible) return const SizedBox.shrink();

          controller.setScreenSize(MediaQuery.of(context).size);

          return Positioned(
            left: controller.position.offset.dx,
            top: controller.position.offset.dy,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) => Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              ),
              child: _buildPipPlayer(controller),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPipPlayer(PipController controller) {
    final settings = controller.settings;

    return AnimatedContainer(
      duration: settings.animationDuration,
      curve: settings.animationCurve,
      width: controller.width,
      height: controller.height,
      decoration: BoxDecoration(
        color: settings.backgroundColor,
        borderRadius: settings.borderRadius,
        boxShadow: [
          BoxShadow(
            color: settings.shadowColor,
            blurRadius: settings.elevation,
            offset: settings.offset,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: settings.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(child: widget.content),
            if (settings.showDragHandle && !controller.isExpanded)
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onPanStart: (_) => controller.setDragging(true),
                  onPanUpdate: (d) => _handleDrag(controller, settings, d),
                  onPanEnd: (_) {
                    controller.setDragging(false);
                    if (settings.snapToEdges) controller.snapToEdge();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: settings.dragHandleColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            if (widget.controls != null && controller.isExpanded)
              Align(alignment: Alignment.bottomCenter, child: widget.controls),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (_) => controller.setDragging(true),
                onPanUpdate: (d) => _handleDrag(controller, settings, d),
                onPanEnd: (_) {
                  controller.setDragging(false);
                  if (settings.snapToEdges) controller.snapToEdge();
                },
                onTap: () {
                  widget.onTap?.call();
                  if (settings.allowExpand) controller.toggleExpanded();
                },
                onTapDown: widget.onTapDown,
                onTapCancel: widget.onTapCancel,
                onLongPress: widget.onLongPress,
                child: const SizedBox.expand(),
              ),
            ),
            if (settings.showExpandButton && !controller.isExpanded)
              _buildButton(
                icon: Icons.fullscreen,
                color: settings.expandButtonColor,
                onTap: () {
                  widget.onExpand?.call();
                  controller.toggleExpanded();
                },
                alignment: Alignment.topLeft,
              ),
            if (settings.showCloseButton)
              _buildButton(
                icon: Icons.close,
                color: settings.closeButtonColor,
                onTap: () {
                  widget.onClose?.call();
                  controller.hide();
                },
              ),
          ],
        ),
      ),
    );
  }
}
