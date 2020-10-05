import 'package:flutter/material.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/size_extension.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key key,
    @required this.isRequired,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  final bool isRequired;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: Sizes.dimen_32.w, bottom: Sizes.dimen_18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRequired ? title + '*' : title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: Sizes.dimen_4.h,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
