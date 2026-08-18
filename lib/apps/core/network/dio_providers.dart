// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// import '../data/lang_pref.dart';
// import 'dio_client.dart';
// import 'endpoints.dart';
// import 'dio_interceptor.dart';

// // final alice = Alice(
// //   navigatorKey: appRouter.navigatorKey,
// //   showNotification: false,
// //   showInspectorOnShake: true,
// // );

// final dioProvider = Provider<Dio>((ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: Endpoints.baseUrl,
//       followRedirects: false,
//       headers: {'Accept': 'application/json'},
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       sendTimeout: const Duration(seconds: 30),
//     ),
//   );
//   dio.interceptors.addAll([
//     PrettyDioLogger(
//       requestHeader: true,
//       requestBody: true,
//       logPrint: (error) => log(
//         error.toString(),
//         name: 'API',
//         //stackTrace: StackTrace.current,
//       ),
//     ),
//     // if (appFlavor.isAliceEnabled) alice.getDioInterceptor(),
//     DioInterceptor(dio, langPrefs: ref.read(langPrefsProvider)),
//   ]);
//   return dio;
// });

// final dioClientProvider = Provider<DioClient>(
//   (ref) => DioClient(
//     dio: ref.read(dioProvider),
//     langPrefs: ref.read(langPrefsProvider),
//   ),
// );
