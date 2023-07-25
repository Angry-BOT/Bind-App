// import '../../../../enums/status.dart';
// import '../providers/home_view_model_provider.dart';
// import '../../profile/providers/profile_provider.dart';
// import '../../../theme/app_colors.dart';
// import '../../../../utils/labels.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class StatusBanner extends ConsumerWidget {
//   // const StatusBanner({Key? key, required this.completed}) : super(key: key);
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final profile = ref.read(profileProvider).value!;
//     final model = ref.read(homeViewModelProvider);
//     final show =
//         profile.isEntrepreneur && profile.username == null && model.showBanner;
//     final completed = profile.status == Status.Active;
//     if (!show) {
//       return SizedBox();
//     }
//     return Container(
//       color: theme.cardColor,
//       child: Stack(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         Labels.documentsUploaded,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 10),
//                       ),
//                     ),
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             Spacer(),
//                             Expanded(
//                               child: Container(
//                                 height: 4,
//                                 color: theme.primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Icon(
//                           Icons.check_circle,
//                           size: 16,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         Labels.verificationPending,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 10),
//                       ),
//                     ),
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 height: 4,
//                                 color: theme.primaryColor,
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 height: 4,
//                                 color: completed
//                                     ? theme.primaryColor
//                                     : AppColors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Icon(
//                           Icons.check_circle,
//                           size: 16,
//                           color: AppColors.deepPurple,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         Labels.profileActivated,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 10),
//                       ),
//                     ),
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 height: 4,
//                                 color: completed
//                                     ? theme.primaryColor
//                                     : AppColors.grey,
//                               ),
//                             ),
//                             Spacer(),
//                           ],
//                         ),
//                         Icon(
//                           Icons.check_circle,
//                           size: 16,
//                           color:
//                               completed ? AppColors.deepPurple : AppColors.grey,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             right: 0,
//             child: IconButton(
//               iconSize: 16,
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 model.showBanner = false;
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
