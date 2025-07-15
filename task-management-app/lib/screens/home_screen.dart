// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:task_management_app/cubits/auth/auth_cubit.dart';
// import 'package:task_management_app/cubits/auth/auth_state.dart';
//
// import '../config/app_constants.dart';
// import '../config/route_constants.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(appName),
//         elevation: 5,
//         centerTitle: false,
//         actions: [
//           // IconButton(
//           //   onPressed: () => Navigator.pushNamed(context, profileRoute),
//           //   icon: Icon(Icons.badge),
//           // ),
//           BlocConsumer<AuthCubit, AuthState>(
//             listener: (context, state) {
//               if (state is AuthLoggedOutState) {
//                 // Navigate to login page or show message
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, loginRoute, (route) => false);
//               }
//             },
//             builder: (BuildContext cåontext, AuthState state) {
//               if (state is AuthLoadingState) {
//                 return CircularProgressIndicator();
//               }
//               return IconButton(
//                 icon: const Icon(Icons.logout),
//                 onPressed: () {
//                   context.read<AuthCubit>().logout(); // Call logout function
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           padding: const EdgeInsets.all(8.0),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 15.0,
//               crossAxisSpacing: 15.0,
//               childAspectRatio: 1.0),
//           itemCount: options.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 Navigator.pushNamed(context, options[index].route);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withAlpha((255 * 0.5).toInt()),
//                       spreadRadius: 1,
//                       blurRadius: 2,
//                       offset: const Offset(0, 2), // changes position of shadow
//                     ),
//                   ],
//                 ),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         options[index].iconData,
//                         size: 60.0,
//                         color: kPrimaryColor,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         options[index].title,
//                         style: Theme.of(context).textTheme.titleLarge,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
