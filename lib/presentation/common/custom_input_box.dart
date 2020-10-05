import 'package:flutter/material.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/custom_form_field.dart';

class CustomInputBox extends StatelessWidget {
  final String title;
  final bool isRequired;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget suffixIcon;

  const CustomInputBox({
    Key key,
    @required this.title,
    @required this.onChanged,
    this.validator,
    this.isRequired = false,
    this.hintText = '',
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFormField(
      isRequired: isRequired,
      title: title,
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          isDense: true,
          filled: true,
          fillColor: AppColor.sandGrey.withOpacity(0.85),
          enabledBorder: InputBorder.none,
          // OutlineInputBorder(
          //   borderSide: const BorderSide(color: Color.fromRGBO(194, 198, 202, 0.2), width: 1),
          //   borderRadius: BorderRadius.circular(5),
          // ),
          focusedBorder: InputBorder.none,
          // OutlineInputBorder(
          //   borderSide: const BorderSide(color: Color.fromRGBO(194, 198, 202, 0.2), width: 1),
          //   borderRadius: BorderRadius.circular(5),
          // ),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
