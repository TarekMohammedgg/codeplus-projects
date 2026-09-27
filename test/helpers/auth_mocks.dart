import 'package:bloc_test/bloc_test.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

const testName = 'Tarek';
const testEmail = 'user@mail.com';
const testPassword = 'password123';
