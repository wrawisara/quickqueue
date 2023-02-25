//ไม่ได้ใช้
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class CustomAppBar extends StatelessWidget {
  
//   final IconData leftIcon;
//   final IconData rightIcon;
//   final Function? leftCallback;
//   CustomAppBar(this.leftCallback,this.rightIcon,this.leftIcon);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top,
//         left: 25,
//         right: 25,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: leftCallback != null ? () => leftCallback!() : null,
//           child : Container(
//             padding: EdgeInsets.fromLTRB(16,8,8,8),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//             ),
//             child: Icon(leftIcon),
//           ),
//         ),
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//             ),
//             child: Icon(rightIcon),
//           ),
//         ]),
//     );
//   }
// }