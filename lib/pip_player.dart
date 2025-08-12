import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pip_controller.dart';

/// A widget that displays content in a Picture-in-Picture view
class PipPlayer extends StatefulWidget {
  /// The controller for the PiP player
  final PipController controller;

  /// The content to display in the PiP player
  final Widget content;

  /// The controls to display when expanded
  final Widget? controls;

  /// Callback when the close button is pressed
  final VoidCallback? onClose;

  /// Callback when the expand button is pressed
  final VoidCallback? onExpand;

  /// Callback when the PiP player is tapped
  final VoidCallback? onTap;

  /// Creates a new PipView
  const PipPlayer({
    super.key,
    required this.controller,
    required this.content,
    this.controls,
    this.onClose,
    this.onExpand,
    this.onTap,
  });

  @override
  State<PipPlayer> createState() => _PipPlayerState();
}

class _PipPlayerState extends State<PipPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.controller.settings.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.controller.settings.animationCurve,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.controller.settings.animationCurve,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: Consumer<PipController>(
        builder: (context, controller, child) {
          if (!controller.isVisible) {
            return const SizedBox.shrink();
          }

          // Get the screen size
          final mediaQuery = MediaQuery.of(context);
          final screenSize = mediaQuery.size;
          controller.setScreenSize(screenSize);

          // Calculate the position
          final position = controller.position.offset;

          // Build the PiP player
          return Positioned(
            left: position.dx,
            top: position.dy,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
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
            // Content
            Positioned.fill(child: widget.content),

            // Drag handle
            if (settings.showDragHandle && !controller.isExpanded)
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onPanStart: (details) {
                      controller.setDragging(true);
                    },
                    onPanUpdate: (details) {
                      debugPrint('settings.allowDrag: ${settings.allowDrag}');
                      debugPrint(' details.delta: ${details.delta}');
                      if (settings.allowDrag) {
                        final newPosition =
                            controller.position.offset + details.delta;
                        controller.updatePosition(newPosition);
                      }
                    },
                    onPanEnd: (details) {
                      controller.setDragging(false);
                      if (settings.snapToEdges) {
                        controller.snapToEdge();
                      }
                    },
                    child: Container(
                      width: 40.0,
                      height: 4,
                      decoration: BoxDecoration(
                        color: settings.dragHandleColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Controls
            if (widget.controls != null && controller.isExpanded)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: widget.controls ?? const SizedBox.shrink(),
              ),

            // Tap detector
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  controller.setDragging(true);
                },
                onPanUpdate: (details) {
                  if (settings.allowDrag) {
                    final newPosition =
                        controller.position.offset + details.delta;
                    controller.updatePosition(newPosition);
                  }
                },
                onPanEnd: (details) {
                  controller.setDragging(false);
                  if (settings.snapToEdges) {
                    controller.snapToEdge();
                  }
                },
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  } else if (settings.allowExpand) {
                    controller.toggleExpanded();
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),

            // Expand button
            if (settings.showExpandButton && !controller.isExpanded)
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () {
                    debugPrint(' widget.onExpand111: ${widget.onExpand}');
                    widget.onExpand?.call();
                    controller.toggleExpanded();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fullscreen,
                      color: settings.expandButtonColor,
                      size: 16,
                    ),
                  ),
                ),
              ),

            // Close button
            if (settings.showCloseButton)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    widget.onClose?.call();
                    controller.hide();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: settings.closeButtonColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
