import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Const/app_colors.dart';

class CustomInputTextField extends StatefulWidget {
  const CustomInputTextField({
    super.key,
    required this.hintText,
    this.hasSuffixIcon = false,
    this.numberKeyboard = false,
    this.decimal = false,
    this.prefixIcon = false,
    this.customPrefixIcon,
    this.prefixIconColor,
    this.labelText,
    this.labelColor,
    required this.textEditingController,
    this.emptyValueErrorText = "Please fill this field",
    this.isValidator = true,
    this.isObscure = false,
    this.haveLabelText = false,
    this.maxLines = 1,
    this.autoFocus = false,
    this.onChange,
    this.borderRadius = 12,
    this.haveBorders = true,
    this.haveWhiteText = false,
    this.inputFormatters,
    this.hintColor = Colors.white54,
    this.maxLength = 0,
    this.validator,
  });

  final String hintText;
  final bool haveBorders;
  final bool autoFocus;
  final List<TextInputFormatter>? inputFormatters;
  final bool haveWhiteText;
  final bool hasSuffixIcon;
  final bool numberKeyboard;
  final bool decimal;
  final bool prefixIcon;
  final IconData? customPrefixIcon;
  final Color? prefixIconColor;
  final String? labelText;
  final Color? labelColor;
  final int maxLines;
  final int? maxLength;
  final TextEditingController textEditingController;
  final String emptyValueErrorText;
  final bool isValidator;
  final bool isObscure;
  final Color hintColor;
  final bool haveLabelText;
  final double borderRadius;
  final void Function(String)? onChange;
  final String? Function(String?)? validator;

  @override
  State<CustomInputTextField> createState() => _CustomInputTextFieldState();
}

class _CustomInputTextFieldState extends State<CustomInputTextField> {
  bool isObscured = false;

  @override
  void initState() {
    isObscured = widget.isObscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      autofocus: false,
      onChanged: widget.onChange,
      inputFormatters: widget.inputFormatters,
      controller: widget.textEditingController,
      maxLength: widget.maxLength == 0 ? null : widget.maxLength,
      maxLines: widget.maxLines,
      keyboardType: widget.numberKeyboard
          ? widget.decimal
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.number
          : TextInputType.text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        fontSize: widget.haveBorders ? 14 : 17,
        color: !widget.haveWhiteText ? AppColors.black : AppColors.white,
      ),
      obscureText: isObscured,
      cursorColor: widget.haveBorders ? AppColors.black : AppColors.white,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: widget.maxLines > 1 ? 6 : 2,
          horizontal: widget.maxLines > 1 ? 12 : 18,
        ),
        labelText: widget.haveLabelText ? widget.hintText : null,
        labelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: AppColors.brownish,
        ),
        prefixIcon: widget.customPrefixIcon != null
            ? Icon(
                widget.customPrefixIcon,
                color: widget.prefixIconColor ?? AppColors.blue,
              )
            : widget.prefixIcon
            ? Icon(Icons.search, color: AppColors.black)
            : null,
        hintText: widget.hintText,
        suffixIcon: widget.hasSuffixIcon
            ? IconButton(
                icon: Icon(
                  isObscured ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                  color: AppColors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
        hintStyle: TextStyle(
          fontSize: widget.haveBorders ? 14 : 17,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: widget.hintColor,
        ),
        border: widget.haveBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: AppColors.grey, width: 1),
              )
            : InputBorder.none,
        enabledBorder: widget.haveBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: AppColors.grey, width: 1),
              )
            : InputBorder.none,
        focusedBorder: widget.haveBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: AppColors.blue, width: 1),
              )
            : InputBorder.none,
        errorBorder: widget.haveBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: AppColors.red, width: 1),
              )
            : InputBorder.none,
        focusedErrorBorder: widget.haveBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: AppColors.red, width: 1),
              )
            : InputBorder.none,
      ),
      validator:
          widget.validator ??
          (widget.isValidator
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return widget.emptyValueErrorText;
                  } else {
                    return null;
                  }
                }
              : null),
    );

    if (widget.labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText!,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: widget.labelColor ?? AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          textField,
        ],
      );
    }
    return textField;
  }
}
