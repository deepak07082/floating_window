import 'package:flutter/material.dart';
import 'models/pip_position.dart';
import 'models/pip_settings.dart';

class PipController extends ChangeNotifier {
  bool _isVisible = false;
  bool _isExpanded = false;
  bool _isDragging = false;
  PipPosition _position;
  PipSettings _settings;
  double _progress = 0.0;
  Size _screenSize = Size.zero;

  final double margin;
  final double bottomSafePadding;
  final bool isSnaping;

  PipController({
    PipSettings settings = const PipSettings(),
    PipPosition? initialPosition,
    this.bottomSafePadding = 80.0,
    this.isSnaping = true,
    this.margin = 10.0,
  }) : _settings = settings,
       _position =
           initialPosition ??
           const PipPosition(
             offset: Offset.zero,
             anchor: PipAnchor.bottomRight,
           );

  bool get isVisible => _isVisible;
  bool get isExpanded => _isExpanded;
  bool get isDragging => _isDragging;
  PipPosition get position => _position;
  PipSettings get settings => _settings;
  double get progress => _progress;
  Size get screenSize => _screenSize;

  double get width =>
      _isExpanded ? _settings.expandedWidth : _settings.collapsedWidth;

  double get height =>
      _isExpanded ? _settings.expandedHeight : _settings.collapsedHeight;

  void setScreenSize(Size size) {
    if (_screenSize == size) return;
    _screenSize = size;
    if (_position.offset == Offset.zero) {
      _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
    }
    notify();
  }

  Offset _getSafeOffset(Offset offset) {
    final dx = offset.dx.clamp(margin, _screenSize.width - width - margin);
    final dy = offset.dy.clamp(
      margin,
      _screenSize.height - height - margin - bottomSafePadding,
    );
    return Offset(dx, dy);
  }

  void show() {
    if (_isVisible) return;
    _isVisible = true;
    notify();
  }

  void hide() {
    if (!_isVisible) return;
    _isVisible = false;
    _isExpanded = false;
    notifyListeners();
  }

  void toggleVisibility() => _isVisible ? hide() : show();

  void expand() {
    if (_isExpanded || !_settings.allowExpand) return;
    _isExpanded = true;
    _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
    notify();
  }

  void collapse() {
    if (!_isExpanded) return;
    _isExpanded = false;
    _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
    notify();
  }

  void toggleExpanded() {
    if (!_settings.allowExpand) return;
    _isExpanded = !_isExpanded;
    _position = _position.copyWith(offset: _getSafeOffset(_position.offset));
    notify();
  }

  void setDragging(bool dragging) {
    if (_isDragging == dragging) return;
    _isDragging = dragging;
    notify();
  }

  void updatePosition(Offset offset) {
    _position = _position.copyWith(offset: _getSafeOffset(offset));
    notify();
  }

  void snapToEdge() {
    if (!isSnaping || _screenSize == Size.zero) return;

    final x = _position.offset.dx;
    final y = _position.offset.dy;

    final left = x;
    final right = _screenSize.width - (x + _settings.collapsedWidth);
    final top = y;
    final bottom =
        _screenSize.height -
        (y + _settings.collapsedHeight) -
        bottomSafePadding;

    final newX = left < right
        ? margin
        : _screenSize.width - _settings.collapsedWidth - margin;
    final newY = top < bottom
        ? margin
        : _screenSize.height -
              _settings.collapsedHeight -
              margin -
              bottomSafePadding;

    final newAnchor = top < bottom
        ? (left < right ? PipAnchor.topLeft : PipAnchor.topRight)
        : (left < right ? PipAnchor.bottomLeft : PipAnchor.bottomRight);

    _position = _position.copyWith(
      offset: Offset(newX, newY),
      anchor: newAnchor,
    );
    notify();
  }

  void updateProgress(double value) {
    final newValue = value.clamp(0.0, 1.0);
    if (_progress == newValue) return;
    _progress = newValue;
    notify();
  }

  void updateSettings(PipSettings settings) {
    _settings = settings;
    notify();
  }

  void notify() => notifyListeners();
}
