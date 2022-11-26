// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:manager/ui/login.dart';

// class IntroPage extends StatelessWidget {
//   const IntroPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey[200],
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "MANAGER",
//               style: TextStyle(fontSize: 22),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               child: Image.asset(
//                 'assets/onboarding.jpeg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 3 / 4,
//               height: MediaQuery.of(context).size.height * 1 / 9,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const Login()));
//                     },
//                     child: const Text("SIGN IN")),
//               ),
//             )
//           ],
//         ));
//   }
// }
