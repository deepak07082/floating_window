import 'package:flutter/material.dart';

/// Settings for the PiP player
class PipSettings {
  /// The width of the PiP player when collapsed
  final double collapsedWidth;

  /// The height of the PiP player when collapsed
  final double collapsedHeight;

  /// The width of the PiP player when expanded
  final double expandedWidth;

  /// The height of the PiP player when expanded
  final double expandedHeight;

  /// The border radius of the PiP player
  final BorderRadius borderRadius;

  /// The padding from the edge of the screen
  final EdgeInsets screenPadding;

  /// The duration of the animations
  final Duration animationDuration;

  /// The curve of the animations
  final Curve animationCurve;

  /// The background color of the PiP player
  final Color backgroundColor;

  /// The shadow color of the PiP player
  final Color shadowColor;

  /// The elevation of the PiP player
  final double elevation;

  /// The offset of the PiP player
  final Offset offset;

  /// Whether to show the drag handle
  final bool showDragHandle;

  /// The color of the drag handle
  final Color dragHandleColor;

  /// Whether to show the close button
  final bool showCloseButton;

  /// The color of the close button
  final Color closeButtonColor;

  /// Whether to show the expand button
  final bool showExpandButton;

  /// The color of the expand button
  final Color expandButtonColor;

  /// Whether to snap to the edges of the screen
  final bool snapToEdges;

  /// The threshold for snapping to the edges
  final double snapThreshold;

  /// Whether to allow dragging the PiP player
  final bool allowDrag;

  /// Whether to allow expanding the PiP player
  final bool allowExpand;

  /// Whether to show a backdrop when expanded
  final bool showBackdropWhenExpanded;

  /// The color of the backdrop when expanded
  final Color backdropColor;

  /// The background color of the controls section
  final Color controlsBackgroundColor;

  /// Creates a new PipSettings
  const PipSettings({
    this.collapsedWidth = 160.0,
    this.collapsedHeight = 90.0,
    this.expandedWidth = 320.0,
    this.expandedHeight = 240.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.screenPadding = const EdgeInsets.all(16.0),
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOutCubic,
    this.backgroundColor = Colors.black,
    this.shadowColor = const Color.fromARGB(255, 196, 196, 196),
    this.elevation = 8.0,
    this.offset = const Offset(0, 0),
    this.showDragHandle = true,
    this.dragHandleColor = Colors.white60,
    this.showCloseButton = true,
    this.closeButtonColor = Colors.white,
    this.showExpandButton = true,
    this.expandButtonColor = Colors.white,
    this.snapToEdges = true,
    this.snapThreshold = 64.0,
    this.allowDrag = true,
    this.allowExpand = true,
    this.showBackdropWhenExpanded = false,
    this.backdropColor = Colors.black54,
    this.controlsBackgroundColor = Colors.black87,
  });

  /// Creates a copy of this settings with the given fields replaced
  PipSettings copyWith({
    double? collapsedWidth,
    double? collapsedHeight,
    double? expandedWidth,
    double? expandedHeight,
    BorderRadius? borderRadius,
    EdgeInsets? screenPadding,
    Duration? animationDuration,
    Curve? animationCurve,
    Color? backgroundColor,
    Color? shadowColor,
    double? elevation,
    bool? showDragHandle,
    Color? dragHandleColor,
    bool? showCloseButton,
    Color? closeButtonColor,
    bool? showExpandButton,
    Color? expandButtonColor,
    bool? showProgressBar,
    Color? progressBarColor,
    Color? progressBarBackgroundColor,
    double? progressBarHeight,
    bool? snapToEdges,
    double? snapThreshold,
    bool? allowDrag,
    bool? allowExpand,
    bool? showBackdropWhenExpanded,
    Color? backdropColor,
    bool? showTitle,
    TextStyle? titleStyle,
    bool? showControls,
    double? controlsHeight,
    Color? controlsBackgroundColor,
    Offset? offset,
  }) {
    return PipSettings(
      collapsedWidth: collapsedWidth ?? this.collapsedWidth,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
      expandedWidth: expandedWidth ?? this.expandedWidth,
      expandedHeight: expandedHeight ?? this.expandedHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      screenPadding: screenPadding ?? this.screenPadding,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      showExpandButton: showExpandButton ?? this.showExpandButton,
      expandButtonColor: expandButtonColor ?? this.expandButtonColor,
      snapToEdges: snapToEdges ?? this.snapToEdges,
      snapThreshold: snapThreshold ?? this.snapThreshold,
      allowDrag: allowDrag ?? this.allowDrag,
      allowExpand: allowExpand ?? this.allowExpand,
      showBackdropWhenExpanded:
          showBackdropWhenExpanded ?? this.showBackdropWhenExpanded,
      backdropColor: backdropColor ?? this.backdropColor,
      controlsBackgroundColor:
          controlsBackgroundColor ?? this.controlsBackgroundColor,
      offset: offset ?? this.offset,
    );
  }

  /// Default settings for a video player
  static PipSettings get video => const PipSettings();

  /// Settings for a mini map
  static PipSettings get map => const PipSettings(
    collapsedWidth: 180.0,
    collapsedHeight: 180.0,
    expandedWidth: 320.0,
    expandedHeight: 320.0,
  );

  /// Settings for a chat bubble
  static PipSettings get chat => const PipSettings(
    collapsedWidth: 200.0,
    collapsedHeight: 120.0,
    expandedWidth: 300.0,
    expandedHeight: 400.0,
    backgroundColor: Colors.blue,
  );
}
