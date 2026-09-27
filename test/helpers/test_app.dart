import 'package:bloc_test/bloc_test.dart';
import 'package:doctor_hunt/apps/core/constants/app_route_paths.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_mocks.dart';

const _screenPath = '/screen-under-test';

Widget buildAuthTestApp({required AuthCubit cubit, required Widget screen}) {
  final router = GoRouter(
    initialLocation: _screenPath,
    routes: [
      GoRoute(
        path: _screenPath,
        builder: (_, _) =>
            BlocProvider<AuthCubit>.value(value: cubit, child: screen),
      ),
      for (final path in [
        AppRoutePaths.home,
        AppRoutePaths.adminDoctors,
        AppRoutePaths.login,
        AppRoutePaths.signup,
        AppRoutePaths.roleSelection,
      ])
        GoRoute(
          path: path,
          builder: (_, _) => Scaffold(body: Text(path)),
        ),
    ],
  );

  return TranslationProvider(child: MaterialApp.router(routerConfig: router));
}

void startWithState(MockAuthCubit cubit, AuthState state) {
  when(() => cubit.state).thenReturn(state);
}

void emitState(MockAuthCubit cubit, AuthState state) {
  whenListen(cubit, Stream.value(state), initialState: const AuthInitial());
}
