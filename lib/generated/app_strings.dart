/// Centralized string constants used throughout the Medora application.
abstract final class AppStrings {
  // General & App Info
  static const String appName = 'Medora';
  static const String medora = 'Medora';
  static const String skip = 'Skip';
  static const String continueText = 'Continue';
  static const String back = 'Back';
  static const String or = 'OR';

  // Onboarding
  static const String onboardingTitle1 = 'Healthcare,\nmade simple';
  static const String onboardingSubtitle1 =
      'Find the care you need,\nright when you need it.';

  static const String onboardingTitle2 = 'Care that\ncomes to you';
  static const String onboardingSubtitle2 =
      'Connect with trusted doctors from\nwherever you are.';

  static const String onboardingTitle3 = 'Your health,\nall together';
  static const String onboardingSubtitle3 =
      'Keep your care, records, and\nprogress in one secure place.';

  // Authentication - Common & Form Fields
  static const String emailAddress = 'Email address';
  static const String emailHint = 'name@example.com';
  static const String password = 'Password';
  static const String passwordHint = 'Password';
  static const String enterPasswordHint = 'Enter your password';
  static const String fullName = 'Full name';
  static const String fullNameHint = 'Full name';
  static const String signIn = 'Sign in';
  static const String createAccount = 'Create account';
  static const String continueWithGoogle = 'Continue with Google';
  static const String showPassword = 'Show password';
  static const String hidePassword = 'Hide password';

  // Login Screen
  static const String welcomeBack = 'Welcome back';
  static const String loginSubtitle = 'Sign in to continue your care journey.';
  static const String forgotPassword = 'Forgot password?';
  static const String newToMedora = 'New to Medora?';
  static const String createAnAccount = 'Create an account';

  // Signup Screen
  static const String createYourAccount = 'Create your\naccount';
  static const String signupSubtitle =
      'Your care starts with a few\nsimple details.';
  static const String passwordLengthNotice = 'At least 8 characters';
  static const String agreeTermsPrefix = 'I agree to the ';
  static const String termsOfService = 'Terms of Service';
  static const String andText = ' and ';
  static const String privacyPolicy = 'Privacy Policy';
  static const String alreadyHaveAccount = 'Already have an account?';

  // OTP Verification Screen
  static const String verifyYourNumber = 'Verify your number';
  static const String otpSentTo = 'We sent a 4-digit code to ';
  static const String defaultPhoneNumber = '+20 10 1234 5678';
  static const String resendTimerDefault = '0:42';
  static const String resendCode = 'Resend code';

  // Reset Password Screen
  static const String resetYourPassword = 'Reset your password';
  static const String resetPasswordSubtitle =
      "Enter your email and we'll send you a\nsecure link to reset it.";
  static const String sendResetLink = 'Send reset link';
  static const String rememberedPassword = 'Remembered your password?';
  static const String passwordResetSuccess =
      'Password reset link sent to your email.';

  // Role Selection Screen
  static const String roleSelectionTitle = 'How will you use Medora?';
  static const String roleSelectionSubtitle =
      'Choose the option that best describes you.';
  static const String patientRoleTitle = "I'm a patient";
  static const String patientRoleDescription =
      'Manage your health,\nappointments, and\nrecords.';
  static const String providerRoleTitle = "I'm a care provider";
  static const String providerRoleDescription =
      'Support patients and\nmanage your practice.';

  // Validation & Error Messages
  static const String enterFullName = 'Enter your full name';
  static const String enterEmailAddress = 'Enter your email address';
  static const String enterValidEmailAddress = 'Enter a valid email address';
  static const String enterPassword = 'Enter your password';
  static const String useAtLeast8Characters = 'Use at least 8 characters';

  // Home Screen
  static const String homePage = 'Home Page';
}
