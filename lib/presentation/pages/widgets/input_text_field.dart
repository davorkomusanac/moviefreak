import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String? hintText;
  final bool autofocus;
  final bool isDense;
  final bool expands;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final EdgeInsets margin;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color? fillColor;
  final bool? filled;
  final Color? cursorColor;
  final TextStyle? style;
  final Function(String val)? onChanged;
  final bool obscureText;

  const InputTextField({
    this.controller,
    this.autofocus = false,
    this.isDense = true,
    this.expands = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.hintText,
    this.focusNode,
    this.contentPadding,
    this.margin = EdgeInsets.zero,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.focusedBorderColor = Colors.blue,
    this.enabledBorderColor = Colors.grey,
    this.fillColor,
    this.filled,
    this.cursorColor,
    this.style,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: TextField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          autofocus: autofocus,
          expands: expands,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          textAlignVertical: TextAlignVertical.top,
          style: style,
          cursorColor: cursorColor,
          obscureText: obscureText,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: hintText,
            isDense: isDense,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            fillColor: fillColor,
            filled: filled,
            contentPadding: contentPadding,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: focusedBorderColor,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: enabledBorderColor,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
        ),
      );
}
