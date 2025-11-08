import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

class ValidationTestField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String label;
  final List<ValidationConditions>? validations;
  final FilteringTextInputFormatter? inputFormatters;
  final double width;
  final int? maxLength;

  const ValidationTestField({
    required this.textEditingController,
    required this.label,
    this.validations,
    this.inputFormatters,
    this.width = 300,
    this.maxLength,
    super.key,
  });

  @override
  State<ValidationTestField> createState() => _ValidationTestFieldState();
}

class _ValidationTestFieldState extends State<ValidationTestField> {
  final Color _errorColor = Color.fromRGBO(211, 47, 47, 1);
  final Color _goodColor = Color.fromRGBO(56, 142, 60, 1);

  late final TextEditingController _controller;
  late final List<ValidationConditions> _validations;

  @override
  void initState() {
    super.initState();
    _validations = widget.validations ?? [];
    _controller = widget.textEditingController;
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLength: widget.maxLength,
              decoration: InputDecoration(label: Text(widget.label)),
            ),
            const SizedBox(height: 8),
            for (var validation in _validations)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  validation.condition(_controller.text)
                      ? Icon(
                          Icons.check_circle_outline_outlined,
                          color: _goodColor,
                          size: 15,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: _errorColor,
                          size: 15,
                        ),
                  const SizedBox(width: 7),
                  Text(
                    validation.name,
                    style: TextStyle(
                      color: validation.condition(_controller.text)
                          ? _goodColor
                          : _errorColor,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ValidationConditions {
  final String name;
  final bool Function(String value) condition;

  const ValidationConditions({required this.name, required this.condition});
}
