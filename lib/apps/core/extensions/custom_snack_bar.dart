// import 'package:flutter/material.dart';
// import 'package:hrzz/app/core/extensions/context_extensions.dart';
// import 'package:hrzz/generated/my_icons.dart';

// import '../../../generated/translations.g.dart';
// import '../enums/internet_status.dart';
// import '../enums/snack_bar.dart';
// import '../services/internet_connection_service.dart';
// import '../themes/app_colors.dart';
// import '../utils/show_message.dart';
// import '../widgets/animated_snackbar.dart';
// enum SnackBarStatus { success, error, warning }

// extension CustomSnackBar on BuildContext {
//   Color getSnackBarColor(SnackBarStatus snackBarStatus) {
//     late Color bgColor;
//     if (snackBarStatus == SnackBarStatus.success) {
//       bgColor = AppColors.success;
//     } else if (snackBarStatus == SnackBarStatus.error) {
//       bgColor = AppColors.danger;
//     } else {
//       bgColor = AppColors.warning;
//     }
//     return bgColor;
//   }

//   Color getSnackBarLightColor(SnackBarStatus snackBarStatus) {
//     late Color lightBgColor;
//     if (snackBarStatus == SnackBarStatus.success) {
//       lightBgColor = AppColors.successLight;
//     } else if (snackBarStatus == SnackBarStatus.error) {
//       lightBgColor = AppColors.danger;
//     } else {
//       lightBgColor = AppColors.warningLight;
//     }
//     return lightBgColor;
//   }

//   IconData getIcons(SnackBarStatus status) {
//     late IconData icon;
//     if (status == SnackBarStatus.success) {
//       icon = MyIcons.tickCircleBold;
//     } else if (status == SnackBarStatus.error) {
//       icon = MyIcons.dangerBold;
//     } else {
//       icon = MyIcons.warning2Bold;
//     }
//     return icon;
//   }

//   Future<void> showCustomSnackBar({
//     required String message,
//     String desc = '',
//     SnackBarStatus snackBarStatus = SnackBarStatus.error,
//   }) {
//     final Color bgColor = getSnackBarColor(snackBarStatus);
//     ScaffoldMessenger.of(this).clearSnackBars();
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         width: currContext.width,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         content: AnimatedSnackBar(
//           borderColor: bgColor,
//           iconData: getIcons(snackBarStatus),
//           iconColor: bgColor,
//           message: message,
//           desc: desc,
//           messageColor: AppColors.textMain,
//           animatedColor: bgColor,
//           lightAnimatedColor: getSnackBarLightColor(snackBarStatus),
//           verticalColor: bgColor,
//         ),
//       ),
//     );
//     return Future.value();
//   }
// }

// extension InternetSnackBar on BuildContext {
//   void initInternetListeners() {
//     InternetConnectionService.event.on<ConnectionStatus>().listen((event) {
//       if (event == ConnectionStatus.connected) {
//         showInternetOnlineSnackBar();
//       } else if (event == ConnectionStatus.disconnected) {
//         showInternetOfflineSnackBar();
//       } else if (event == ConnectionStatus.weak) {
//         showWeakInternetSnackBar();
//       }
//     });
//   }

//   Color getSnackBarColor(SnackBarStatus snackBarStatus) {
//     late Color bgColor;
//     if (snackBarStatus == SnackBarStatus.success) {
//       bgColor = AppColors.success;
//     } else if (snackBarStatus == SnackBarStatus.error) {
//       bgColor = AppColors.danger;
//     } else {
//       bgColor = AppColors.warning;
//     }
//     return bgColor;
//   }

//   void showInternetOfflineSnackBar() {
//     final Color bgColor = getSnackBarColor(SnackBarStatus.error);
//     final snackBar = SnackBar(
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: bgColor,
//       duration: const Duration(days: 1),
//       showCloseIcon: true,
//       closeIconColor: AppColors.white,
//       content: Text(
//         tr.disconnected,
//         style: const TextStyle(
//           fontSize: 14.0,
//           color: AppColors.white,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//     ScaffoldMessenger.of(this).clearSnackBars();
//     ScaffoldMessenger.of(this).showSnackBar(snackBar);
//   }

//   void showInternetOnlineSnackBar() {
//     final Color bgColor = getSnackBarColor(SnackBarStatus.success);
//     ScaffoldMessenger.of(this).clearSnackBars();
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: bgColor,
//         content: Text(
//           tr.connected,
//           style: const TextStyle(
//             fontSize: 14.0,
//             color: AppColors.white,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//     );
//   }

//   void showWeakInternetSnackBar() {
//     final Color bgColor = getSnackBarColor(SnackBarStatus.warning);
//     ScaffoldMessenger.of(this).clearSnackBars();
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: bgColor,
//         content: Text(
//           tr.internetWeak,
//           style: const TextStyle(
//             fontSize: 14.0,
//             color: AppColors.white,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//     );
//   }
// }
