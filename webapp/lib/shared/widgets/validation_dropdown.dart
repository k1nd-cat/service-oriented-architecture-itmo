import 'package:flutter/material.dart';

class ValidationDropdownField<T> extends StatefulWidget {
  final T? selectedValue;
  final List<T> enumValues;
  final String label;
  final bool allowNull;
  final void Function(T?)? onChanged;
  final double? width;
  final String Function(T) itemNameBuilder;
  final IconData? prefixIcon;
  final String? helperText;

  const ValidationDropdownField({
    required this.selectedValue,
    required this.enumValues,
    required this.label,
    this.allowNull = false,
    this.onChanged,
    required this.itemNameBuilder,
    this.width,
    this.prefixIcon,
    this.helperText,
    Key? key,
  }) : super(key: key);

  @override
  State<ValidationDropdownField<T>> createState() => _ValidationDropdownFieldState<T>();
}

class _ValidationDropdownFieldState<T> extends State<ValidationDropdownField<T>>
    with SingleTickerProviderStateMixin {
  late T? selectedValue;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ValidationDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        selectedValue = widget.selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<DropdownMenuItem<T?>> items = [];
    if (widget.allowNull) {
      items.add(DropdownMenuItem<T?>(
        value: null,
        child: Text(
          'Не выбрано',
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ));
    }
    items.addAll(widget.enumValues.map((e) => DropdownMenuItem<T?>(
      value: e,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            widget.itemNameBuilder(e),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    )));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _focusAnimation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _isHovered
                    ? colorScheme.surfaceVariant.withOpacity(0.3)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused
                      ? colorScheme.primary
                      : _isHovered
                      ? colorScheme.outline.withOpacity(0.5)
                      : colorScheme.outline.withOpacity(0.2),
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: [
                  if (_isFocused)
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Label с иконкой
                        Row(
                          children: [
                            if (widget.prefixIcon != null) ...[
                              Icon(
                                widget.prefixIcon,
                                size: 18,
                                color: _isFocused
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _isFocused
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Dropdown
                        Theme(
                          data: Theme.of(context).copyWith(
                            focusColor: Colors.transparent,
                            hoverColor: colorScheme.surfaceVariant.withOpacity(0.1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<T?>(
                              value: selectedValue,
                              items: items,
                              isExpanded: true,
                              isDense: false,
                              icon: AnimatedRotation(
                                turns: _isFocused ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: _isFocused
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return items.map((item) {
                                  if (item.value == null) {
                                    return Text(
                                      'Не выбрано',
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    );
                                  }
                                  return Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 16,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              colorScheme.primary,
                                              colorScheme.secondary,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      Text(
                                        widget.itemNameBuilder(item.value as T),
                                        style: TextStyle(
                                          color: colorScheme.onSurface,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList();
                              },
                              onTap: () {
                                setState(() => _isFocused = true);
                                _animationController.forward();
                              },
                              onChanged: (T? newValue) {
                                setState(() {
                                  selectedValue = newValue;
                                  _isFocused = false;
                                });
                                _animationController.reverse();
                                if (widget.onChanged != null) {
                                  widget.onChanged!(newValue);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              dropdownColor: colorScheme.surface,
                              elevation: 8,
                              menuMaxHeight: 300,
                            ),
                          ),
                        ),

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
            ),
          );
        },
      ),
    );
  }
}