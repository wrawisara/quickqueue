import 'package:flutter/material.dart';
import 'package:quickqueue/utils/color.dart';

class CustomElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const CustomElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.borderRadius,
      this.width,
      this.height = 44.0,
      // this.gradient = const LinearGradient(colors: [cyanPrimary, Color.fromRGBO(126, 164, 235, 1)])
      this.gradient = const LinearGradient(colors: [cyanPrimary, Colors.cyan])})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent.withOpacity(0.1),
          // shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: Ink(
          decoration:
              BoxDecoration(gradient: gradient, borderRadius: borderRadius),
          child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: child),
        ),
      ),
    );
  }
}


 
