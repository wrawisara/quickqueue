import 'package:flutter/material.dart';
import 'package:quickqueue/utils/color.dart';



class CustomElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    // this.gradient = const LinearGradient(colors: [cyanPrimary, Color.fromRGBO(126, 164, 235, 1)])
    this.gradient = const LinearGradient(colors: [cyanPrimary, Colors.cyan])
  }) : super(key: key);

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
          backgroundColor: Colors.transparent,
          // shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
       child: Ink(
            decoration: BoxDecoration(
                gradient:gradient,
                borderRadius: borderRadius
                ),
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: child
            ),
          ),
        ),
      );
  }
}



//button เหมือนกันแต่คนละสไตล์
// class CustomElevatedButton extends StatelessWidget {
//   final String buttonText;
//   final double width;
//   final Function onpressed;

//   CustomElevatedButton({
//     required this.buttonText,
//     required this.width,
//     required this.onpressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
//           ],
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: [0.0, 1.0],
//             colors: [
//               Colors.cyanAccent.shade400,
//               Colors.cyanAccent.shade200,
//             ],
//           ),
//           color: Colors.cyan.shade300,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: ElevatedButton(
//           style: ButtonStyle(
//               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//               minimumSize: MaterialStateProperty.all(Size(width, 50)),
//               backgroundColor:
//                   MaterialStateProperty.all(Colors.transparent),
//               // elevation: MaterialStateProperty.all(3),
//               shadowColor:
//                   MaterialStateProperty.all(Colors.transparent),
//                   ),
//           onPressed: () {
//             onpressed();
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(
//               top: 10,
//               bottom: 10,
//             ),
//             child: Text(
//               buttonText,
//               style: TextStyle(
//                 fontSize: 18,
//                 // fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
 
