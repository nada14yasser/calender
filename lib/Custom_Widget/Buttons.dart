import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ButtonAsText extends StatelessWidget {
  const ButtonAsText({
    required this.text,
    required this.onPressed,
    Key? key})
      : super(key: key);

  final dynamic onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)),
        fixedSize: Size(100.sp, 30.sp),
      ),
      child: FittedBox(child: Text(text,style: TextStyle(fontSize: 17.sp,color: Theme.of(context).backgroundColor,),)),
    );
  }
}
class ButtonAsIcon extends StatelessWidget {
  ButtonAsIcon({
    required this.icon,
    required this.onPressed,
    Key? key})
      : super(key: key);

  VoidCallback onPressed;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)),
        fixedSize: Size(70.sp, 30.sp),
      ),
      child: Icon(icon,color:Theme.of(context).backgroundColor,size: 30,),
    );
  }
}