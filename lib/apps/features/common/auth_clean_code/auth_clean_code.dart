// Domain Layer (Pure Dart Clean Architecture Additions)
export 'domain/entities/user_entity.dart';
export 'domain/repositories/auth_repository.dart';
export 'domain/usecases/check_admin_status_usecase.dart';
export 'domain/usecases/get_current_user_usecase.dart';
export 'domain/usecases/reset_password_usecase.dart';
export 'domain/usecases/sign_in_with_email_usecase.dart';
export 'domain/usecases/sign_in_with_google_usecase.dart';
export 'domain/usecases/sign_out_usecase.dart';
export 'domain/usecases/sign_up_with_email_usecase.dart';

// Data Layer (Clean Architecture Additions)
export 'data/datasources/auth_remote_data_source.dart';
export 'data/datasources/auth_remote_data_source_impl.dart';
export 'data/models/user_model.dart';
export 'data/repositories/auth_repository_impl.dart';

// Presentation Layer (100% Mirroring of Original Feature Files)
export 'presentation/cubit/auth_cubit.dart';
export 'presentation/cubit/auth_state.dart';
export 'presentation/screens/login_screen.dart';
export 'presentation/screens/otp_verification_screen.dart';
export 'presentation/screens/reset_password_screen.dart';
export 'presentation/screens/signup_screen.dart';
export 'presentation/widgets/auth_back_button.dart';
export 'presentation/widgets/auth_buttons.dart';
export 'presentation/widgets/auth_header.dart';
export 'presentation/widgets/forgot_password_bottom_sheet.dart';
export 'presentation/widgets/otp_verification_bottom_sheet.dart';
