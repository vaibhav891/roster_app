import 'package:flutter/material.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/size_extension.dart';
import 'package:roster_app/common/themes/theme_color.dart';

class MyRaisedButton extends StatelessWidget {
  final String buttonTitle;
  final Color buttonColor;
  final VoidCallback onPressed;
  final bool isTrailingPresent;
  final EdgeInsetsGeometry padding;

  const MyRaisedButton({
    Key key,
    @required this.buttonTitle,
    @required this.onPressed,
    @required this.buttonColor,
    @required this.isTrailingPresent,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
      color: buttonColor,
      onPressed: onPressed,
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonTitle,
              style: Theme.of(context).textTheme.subtitle1.copyWith(color: AppColor.white),
            ),
            if (isTrailingPresent)
              SizedBox(
                width: Sizes.dimen_8.w,
              ),
            if (isTrailingPresent)
              Container(
                padding: EdgeInsets.all(Sizes.dimen_4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.darkGreen.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
