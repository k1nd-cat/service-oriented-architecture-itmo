import 'package:flutter/material.dart';

class DropdownEnumMenu<T extends Enum> extends StatefulWidget {
  final T? selected;
  final List<T> enumValues;
  final ValueChanged<T?>? onChanged;
  final String? emptyLabel;
  final String Function(T)? labelBuilder;
  final String? label;

  static String _defaultLabelBuilder<V extends Enum>(V value) => value.name;

  const DropdownEnumMenu({
    required this.selected,
    required this.enumValues,
    required this.onChanged,
    required this.emptyLabel,
    String Function(T)? labelBuilder,
    this.label,
    super.key,
  }) : labelBuilder = labelBuilder ?? _defaultLabelBuilder<T>;

  @override
  State<DropdownEnumMenu<T>> createState() => _DropdownEnumMenuState<T>();
}

class _DropdownEnumMenuState<T extends Enum> extends State<DropdownEnumMenu<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T?>(
      initialValue: widget.selected,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem<T?>(
          value: null,
          child: Text(widget.emptyLabel ?? 'Не выбрано'),
        ),
        ...widget.enumValues.map((e) => DropdownMenuItem<T?>(
          value: e,
          child: Text(widget.labelBuilder!(e)),
        )),
      ],
    );
  }
}
