import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ValidationTestField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String label;
  final List<ValidationConditions>? validations;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final int? maxLength;
  final IconData? prefixIcon;
  final String? helperText;
  final String? hintText;
  final TextInputType? keyboardType;

  const ValidationTestField({
    required this.textEditingController,
    required this.label,
    this.validations,
    this.inputFormatters,
    this.width,
    this.maxLength,
    this.prefixIcon,
    this.helperText,
    this.hintText,
    this.keyboardType,
    super.key,
  });

  @override
  State<ValidationTestField> createState() => _ValidationTestFieldState();
}

class _ValidationTestFieldState extends State<ValidationTestField>
    with TickerProviderStateMixin {
  late final TextEditingController _controller;
  late final List<ValidationConditions> _validations;
  late final FocusNode _focusNode;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _isFocused = false;
  bool _hasInteracted = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _validations = widget.validations ?? [];
    _controller = widget.textEditingController;
    _focusNode = FocusNode();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    setState(() {
      if (!_hasInteracted && _controller.text.isNotEmpty) {
        _hasInteracted = true;
      }
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_focusNode.hasFocus) {
        _hasInteracted = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  bool get _isValid {
    if (_validations.isEmpty) return true;
    return _validations.every((v) => v.condition(_controller.text));
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    if (!_hasInteracted) {
      return colorScheme.outline.withOpacity(0.2);
    }
    if (_isFocused) {
      return _isValid ? colorScheme.primary : colorScheme.error;
    }
    if (_isHovered) {
      return colorScheme.outline.withOpacity(0.5);
    }
    return _isValid
        ? colorScheme.outline.withOpacity(0.3)
        : colorScheme.error.withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: Container(
              width: widget.width,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? colorScheme.surfaceVariant.withValues(alpha: 0.3)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getBorderColor(colorScheme),
                    width: _isFocused ? 2 : 1,
                  ),
                  boxShadow: [
                    if (_isFocused)
                      BoxShadow(
                        color: (_isValid ? colorScheme.primary : colorScheme.error)
                            .withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLength: widget.maxLength,
                        keyboardType: widget.keyboardType,
                        inputFormatters: widget.inputFormatters,
                        style: TextStyle(
                          fontSize: 15,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: widget.label,
                          hintText: widget.hintText,
                          labelStyle: TextStyle(
                            color: _isFocused
                                ? (_isValid ? colorScheme.primary : colorScheme.error)
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: _isFocused ? 14 : 16,
                          ),
                          hintStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: widget.prefixIcon != null
                              ? Icon(
                            widget.prefixIcon,
                            size: 20,
                            color: _isFocused
                                ? (_isValid ? colorScheme.primary : colorScheme.error)
                                : colorScheme.onSurfaceVariant,
                          )
                              : null,
                          suffixIcon: _hasInteracted
                              ? AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _isValid
                                ? Icon(
                              Icons.check_circle,
                              key: const ValueKey('check'),
                              color: Colors.green.shade600,
                              size: 20,
                            )
                                : Icon(
                              Icons.error_outline,
                              key: const ValueKey('error'),
                              color: colorScheme.error,
                              size: 20,
                            ),
                          )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          counterText: widget.maxLength != null
                              ? '${_controller.text.length}/${widget.maxLength}'
                              : '',
                          counterStyle: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                        ),
                      ),

                      // Validations с анимацией
                      if (_validations.isNotEmpty && _hasInteracted) ...[
                        const SizedBox(height: 12),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          child: Column(
                            children: [
                              for (var validation in _validations)
                                _buildValidationItem(validation, colorScheme),
                            ],
                          ),
                        ),
                      ],

                      // Helper text
                      if (widget.helperText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.helperText!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildValidationItem(ValidationConditions validation, ColorScheme colorScheme) {
    final isValid = validation.condition(_controller.text);
    final color = isValid ? Colors.green.shade600 : colorScheme.error;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isValid ? 1 : 0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                  border: Border.all(
                    color: color.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isValid
                        ? Icon(
                      Icons.check,
                      key: ValueKey('${validation.name}_check'),
                      size: 12,
                      color: color,
                    )
                        : Icon(
                      Icons.close,
                      key: ValueKey('${validation.name}_close'),
                      size: 12,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 13,
                    color: color,
                    fontWeight: isValid ? FontWeight.w500 : FontWeight.w400,
                    decoration: isValid ? TextDecoration.none : TextDecoration.none,
                  ),
                  child: Text(validation.name),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ValidationConditions {
  final String name;
  final bool Function(String value) condition;

  const ValidationConditions({required this.name, required this.condition});
}
