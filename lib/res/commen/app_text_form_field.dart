import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final bool? obscureText;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const AppTextFormField({
    Key? key,
    this.controller,
    this.labelText,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      controller: controller,
      autofocus: true,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
        suffixIcon: suffixIcon ?? const SizedBox(),
        hintText: hintText!,
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        labelText: labelText ?? "Email",
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xffE1E3E6)),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.blue),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
