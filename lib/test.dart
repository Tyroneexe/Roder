// import 'package:flutter/material.dart';

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/splash_screen.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 50,
//             ),
//             Center(
//               child: Text(
//                 'Roder',
//                 style: TextStyle(
//                   fontFamily: 'Audiowide',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 70,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       'Sign in with Google',
//                       style: TextStyle(
//                         fontFamily: 'OpenSans',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 style: ButtonStyle(
//                   // Customize the button's background color
//                   // Customize the button's foreground (text) color
//                   foregroundColor:
//                       MaterialStateProperty.all<Color>(Colors.white),
//                   // Customize the button's padding
//                   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                     EdgeInsets.symmetric(
//                       vertical: 16.0,
//                     ),
//                   ),
//                   // Customize the button's shape (e.g., rounded corners)
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   fixedSize: MaterialStateProperty.all<Size>(Size(300, 60)),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
