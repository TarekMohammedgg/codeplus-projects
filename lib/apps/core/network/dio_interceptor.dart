// import 'dart:developer';

// import 'package:bookly_x/app/core/data/agent_pref.dart';
// import 'package:bookly_x/app/core/data/lang_pref.dart';
// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// import '../data/user_pref.dart';
// import '../services/unauthorized_service.dart';
// import 'endpoints.dart';

// class DioInterceptor extends Interceptor {
//   final Dio dio;
//   final LangPrefs langPrefs;
//   static Future<bool>? _refreshFuture;

//   DioInterceptor(this.dio, {required this.langPrefs});

//   @override
//   Future<void> onError(
//     DioException err,
//     ErrorInterceptorHandler handler,
//   ) async {
//     if (err.response == null) {
//       log("Network error or no response", name: 'DioInterceptor');
//       return handler.next(err);
//     }
//     final response = err.response!;
//     final isUnauthorized = response.statusCode == 401;
//     final isForbidden = response.statusCode == 403;

//     // Protection against infinite loops
//     final isRetry = err.requestOptions.extra['is_retry'] == true;
//     final isRefreshPath =
//         response.requestOptions.path.contains(Endpoints.refreshToken);

//     if (isUnauthorized) {
//       // If it's the refresh token itself failing, or already a retry, logout immediately
//       if (isRefreshPath || isRetry) {
//         await _handleLogout();
//         return handler.next(err);
//       }

//       // If we are logged in, try to refresh the token
//       if (UserPrefs.isUserLoggedIn) {
//         final success = await _refreshToken();
//         if (success) {
//           try {
//             final retryResponse = await _retry(response.requestOptions);
//             return handler.resolve(retryResponse);
//           } catch (e) {
//             await _handleLogout();
//             return handler.next(err);
//           }
//         }
//       }

//       // If not logged in but got 401, or refresh failed, force logout/restart
//       await _handleLogout();
//       return handler.next(err);
//     } else if (isForbidden) {
//       // Always logout on forbidden for now, as it usually means a permanent issue
//       await _handleLogout();
//       return handler.next(err);
//     }

//     handler.next(err);
//   }

//   Future<bool> _refreshToken() async {
//     if (_refreshFuture != null) {
//       return _refreshFuture!;
//     }

//     _refreshFuture = _doRefresh();
//     try {
//       final result = await _refreshFuture!;
//       return result;
//     } finally {
//       _refreshFuture = null;
//     }
//   }

//   Future<bool> _doRefresh() async {
//     try {
//       final refreshToken = UserPrefs.getRefreshToken();
//       if (refreshToken.isEmpty) return false;

//       // Use a separate Dio instance to avoid interceptors
//       final refreshDio = Dio(BaseOptions(
//         headers: {
//           'Accept-Language': langPrefs.locale.toString(),
//           'platform': "APP",
//           'User-Agent': UserAgentPrefs.getUserAgent,
//         },
//         baseUrl: Endpoints.baseUrl,
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//       ));

//       refreshDio.interceptors.add(
//         PrettyDioLogger(
//           requestHeader: true,
//           requestBody: true,
//           logPrint: (object) => log(object.toString(), name: 'Refresh Token'),
//         ),
//       );

//       final response = await refreshDio.post(
//         Endpoints.refreshToken,
//         data: {'refreshToken': refreshToken},
//       );
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final resData = response.data;
//         final newToken = resData['data']['token'];
//         final newRefreshToken = resData['data']['refreshToken'];

//         if (newToken != null) {
//           await UserPrefs.setUserToken(newToken);
//           if (newRefreshToken != null) {
//             await UserPrefs.setRefreshToken(newRefreshToken);
//           }
//           return true;
//         }
//       }
//     } catch (e) {
//       log(
//         'Token refresh failed: $e',
//         name: 'DioInterceptor._doRefresh',
//         error: e,
//         stackTrace: StackTrace.current,
//       );
//     }
//     return false;
//   }

//   Future<Response> _retry(RequestOptions requestOptions) async {
//     return dio.fetch(
//       requestOptions.copyWith(
//         headers: {
//           ...requestOptions.headers,
//           'Authorization': UserPrefs.getUserToken(),
//         },
//         extra: {
//           ...requestOptions.extra,
//           'is_retry': true,
//         },
//       ),
//     );
//   }

//   Future<void> _handleLogout() async {
//     log("Logging out user due to unauthorized access", name: 'DioInterceptor');
//     UnAuthorizedService.event.fire(401);
//   }
// }
