import 'package:flutter/material.dart';

class ValidationDropdownField<T> extends StatefulWidget {
  final T? selectedValue;
  final List<T> enumValues;
  final String label;
  final bool allowNull;
  final void Function(T?)? onChanged;
  final double width;
  final String Function(T) itemNameBuilder;

  const ValidationDropdownField({
    required this.selectedValue,
    required this.enumValues,
    required this.label,
    this.allowNull = false,
    this.onChanged,
    required this.itemNameBuilder,
    this.width = 300,
    Key? key,
  }) : super(key: key);

  @override
  State<ValidationDropdownField<T>> createState() => _ValidationDropdownFieldState<T>();
}

class _ValidationDropdownFieldState<T> extends State<ValidationDropdownField<T>> {
  late T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<T?>> items = [];
    if (widget.allowNull) {
      items.add(DropdownMenuItem<T?>(
        value: null,
        child: Text('Выберите ${widget.label.toLowerCase()}'),
      ));
    }
    items.addAll(widget.enumValues.map((e) => DropdownMenuItem<T?>(
      value: e,
      child: Text(widget.itemNameBuilder(e)),
    )));

    return Container(
      width: widget.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label),
          DropdownButton<T?>(
            value: selectedValue,
            items: items,
            onChanged: (T? newValue) {
              setState(() {
                selectedValue = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
