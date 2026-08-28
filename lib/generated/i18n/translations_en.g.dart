///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final tr = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Doctor Hunt'
	String get appName => 'Doctor Hunt';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Continue'
	String get continueText => 'Continue';

	/// en: 'Get Started'
	String get getStarted => 'Get Started';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'OR'
	String get or => 'OR';

	/// en: 'العربية'
	String get arabicLanguage => 'العربية';

	/// en: 'English'
	String get englishLanguage => 'English';

	/// en: 'Find Trusted Doctors'
	String get onboardingTitle1 => 'Find Trusted Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get onboardingSubtitle1 => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Choose Best Doctors'
	String get onboardingTitle2 => 'Choose Best Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get onboardingSubtitle2 => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Easy Appointments'
	String get onboardingTitle3 => 'Easy Appointments';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get onboardingSubtitle3 => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Email'
	String get emailAddress => 'Email';

	/// en: 'wpos/36@gmail.com'
	String get emailHint => 'wpos/36@gmail.com';

	/// en: 'Password'
	String get password => 'Password';

	/// en: '••••••••••••'
	String get passwordHint => '••••••••••••';

	/// en: '••••••••••••'
	String get enterPasswordHint => '••••••••••••';

	/// en: 'Name'
	String get fullName => 'Name';

	/// en: 'Name'
	String get fullNameHint => 'Name';

	/// en: 'Sign in'
	String get signIn => 'Sign in';

	/// en: 'Log In'
	String get logIn => 'Log In';

	/// en: 'Create account'
	String get createAccount => 'Create account';

	/// en: 'Google'
	String get google => 'Google';

	/// en: 'Facebook'
	String get facebook => 'Facebook';

	/// en: 'Show password'
	String get showPassword => 'Show password';

	/// en: 'Hide password'
	String get hidePassword => 'Hide password';

	/// en: 'Welcome Back'
	String get welcomeBack => 'Welcome Back';

	/// en: 'Appoint the best doctor for your health and live your life with full of happiness'
	String get loginSubtitle => 'Appoint the best doctor for your health and\nlive your life with full of happiness';

	/// en: 'Forgot password'
	String get forgotPassword => 'Forgot password';

	/// en: 'Enter your email and we will send you a link to reset your password.'
	String get forgotPasswordSubtitle => 'Enter your email and we will send you a link to reset your password.';

	/// en: 'Don’t have an account? '
	String get dontHaveAccount => 'Don’t have an account? ';

	/// en: 'Join us'
	String get joinUs => 'Join us';

	/// en: 'Join us to start your search'
	String get createYourAccount => 'Join us to start your search';

	/// en: 'Find trusted doctors, book appointments, and manage your healthcare.'
	String get signupSubtitle => 'Find trusted doctors, book appointments, and manage your healthcare.';

	/// en: 'At least 8 characters'
	String get passwordLengthNotice => 'At least 8 characters';

	/// en: 'I agree to the '
	String get agreeTermsPrefix => 'I agree to the ';

	/// en: 'Terms of Service'
	String get termsOfService => 'Terms of Service';

	/// en: ' and '
	String get andText => ' and ';

	/// en: 'Privacy Policy'
	String get privacyPolicy => 'Privacy Policy';

	/// en: 'Already have an account?'
	String get alreadyHaveAccount => 'Already have an account?';

	/// en: 'Verify your number'
	String get verifyYourNumber => 'Verify your number';

	/// en: 'We sent a 6-digit code to '
	String get otpSentTo => 'We sent a 6-digit code to ';

	/// en: '+20 10 1234 5678'
	String get defaultPhoneNumber => '+20 10 1234 5678';

	/// en: '0:60'
	String get resendTimerDefault => '0:60';

	/// en: 'Resend code'
	String get resendCode => 'Resend code';

	/// en: 'A new code was sent.'
	String get codeSentAgain => 'A new code was sent.';

	/// en: 'Enter 6 Digits Code'
	String get otpCodeTitle => 'Enter 6 Digits Code';

	/// en: 'Enter the 6 digits code that you received on your phone.'
	String get otpCodeDescription => 'Enter the 6 digits code that you received on your phone.';

	/// en: 'Reset your password'
	String get resetYourPassword => 'Reset your password';

	/// en: 'Enter your email and we'll send you a secure link to reset it.'
	String get resetPasswordSubtitle => 'Enter your email and we\'ll send you a\nsecure link to reset it.';

	/// en: 'Send reset link'
	String get sendResetLink => 'Send reset link';

	/// en: 'Remembered your password?'
	String get rememberedPassword => 'Remembered your password?';

	/// en: 'Password reset link sent to your email.'
	String get passwordResetSuccess => 'Password reset link sent to your email.';

	/// en: 'Choose your role'
	String get roleSelectionTitle => 'Choose your role';

	/// en: 'The selected role determines the experience and available features.'
	String get roleSelectionSubtitle => 'The selected role determines the experience and\navailable features.';

	/// en: 'Patient'
	String get patientRoleTitle => 'Patient';

	/// en: 'Find doctors, book appointments, and manage your medical records.'
	String get patientRoleDescription => 'Find doctors, book appointments, and manage your medical records.';

	/// en: 'Admin'
	String get adminRoleTitle => 'Admin';

	/// en: 'Manage doctors, appointments, users, and the platform.'
	String get adminRoleDescription => 'Manage doctors, appointments, users, and the platform.';

	/// en: 'Enter your full name'
	String get enterFullName => 'Enter your full name';

	/// en: 'Enter your email address'
	String get enterEmailAddress => 'Enter your email address';

	/// en: 'Enter a valid email address'
	String get enterValidEmailAddress => 'Enter a valid email address';

	/// en: 'Enter your password'
	String get enterPassword => 'Enter your password';

	/// en: 'Use at least 8 characters'
	String get useAtLeast8Characters => 'Use at least 8 characters';

	/// en: 'Hi Sama 👋'
	String get hiSteven => 'Hi Sama 👋';

	/// en: 'Find Your Doctor'
	String get findYourDoctor => 'Find Your Doctor';

	/// en: 'Search.... '
	String get searchDoctorHint => 'Search.... ';

	/// en: 'LIVE'
	String get live => 'LIVE';

	/// en: 'Live Doctor'
	String get liveDoctor => 'Live Doctor';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'Popular Doctor'
	String get popularDoctor => 'Popular Doctor';

	/// en: 'Featured Doctor'
	String get featuredDoctor => 'Featured Doctor';

	/// en: 'Dental'
	String get dental => 'Dental';

	/// en: 'Cardiology'
	String get cardiology => 'Cardiology';

	/// en: 'Eye Care'
	String get eyeCare => 'Eye Care';

	/// en: 'Nutrition'
	String get nutrition => 'Nutrition';

	/// en: 'Pediatric'
	String get pediatric => 'Pediatric';

	/// en: 'Neurology'
	String get neurology => 'Neurology';

	/// en: 'Medicine Specialist'
	String get medicineSpecialist => 'Medicine Specialist';

	/// en: 'Dental Specialist'
	String get dentalSpecialist => 'Dental Specialist';

	/// en: 'Heart Specialist'
	String get heartSpecialist => 'Heart Specialist';

	/// en: 'Eye Specialist'
	String get eyeSpecialist => 'Eye Specialist';

	/// en: 'General Surgeon'
	String get generalSurgeon => 'General Surgeon';

	/// en: '/hour'
	String get perHour => '/hour';

	/// en: 'Reviews'
	String get reviews => 'Reviews';

	/// en: 'Find Doctors'
	String get findDoctors => 'Find Doctors';

	/// en: 'Dentist'
	String get searchDentistHint => 'Dentist';

	/// en: 'Dentist'
	String get dentist => 'Dentist';

	/// en: 'Years experience'
	String get yearsExperienceSuffix => 'Years experience';

	/// en: 'Patient Stories'
	String get patientStories => 'Patient Stories';

	/// en: 'Next Available'
	String get nextAvailable => 'Next Available';

	/// en: 'Book Now'
	String get bookNow => 'Book Now';

	/// en: 'No doctors found'
	String get noDoctorsFound => 'No doctors found';

	/// en: 'Booking is not available yet.'
	String get bookingComingSoon => 'Booking is not available yet.';

	/// en: 'Booking appointment with $name...'
	String bookingMessage({required Object name}) => 'Booking appointment with ${name}...';

	/// en: 'tomorrow'
	String get tomorrow => 'tomorrow';

	/// en: 'Cardiologist'
	String get liveCardiologist => 'Cardiologist';

	/// en: 'Dentist'
	String get liveDentist => 'Dentist';

	/// en: 'Pediatrician'
	String get livePediatrician => 'Pediatrician';

	/// en: 'Neurologist'
	String get liveNeurologist => 'Neurologist';

	/// en: 'Patient care should be the number one priority.'
	String get serviceOne => 'Patient care should be the number one priority.';

	/// en: 'If you run your practice you know how frustrating.'
	String get serviceTwo => 'If you run your practice you know how frustrating.';

	/// en: 'That's why some of appointment reminder system.'
	String get serviceThree => 'That\'s why some of appointment reminder system.';

	/// en: 'Doctor Details'
	String get doctorDetails => 'Doctor Details';

	/// en: 'Services'
	String get services => 'Services';

	/// en: 'Running'
	String get statRunning => 'Running';

	/// en: 'Ongoing'
	String get statOngoing => 'Ongoing';

	/// en: 'Patient'
	String get statPatient => 'Patient';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Set up your profile'
	String get setUpYourProfile => 'Set up your profile';

	/// en: 'Update your profile to connect your doctor with better impression.'
	String get profileHeaderSubtitle => 'Update your profile to connect your doctor with\nbetter impression.';

	/// en: 'Personal information'
	String get personalInformation => 'Personal information';

	/// en: 'Contact Number'
	String get contactNumber => 'Contact Number';

	/// en: 'Date of birth'
	String get dateOfBirth => 'Date of birth';

	/// en: 'DD MM YYYY'
	String get dateOfBirthPlaceholder => 'DD MM YYYY';

	/// en: 'Location'
	String get location => 'Location';

	/// en: 'Add Details'
	String get addDetails => 'Add Details';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Profile updated successfully'
	String get profileUpdatedSuccess => 'Profile updated successfully';

	/// en: 'Log Out'
	String get logOut => 'Log Out';

	/// en: 'Favourite Doctors'
	String get favouriteDoctors => 'Favourite Doctors';

	/// en: 'Your saved and trusted medical specialists'
	String get favouriteDoctorsSubtitle => 'Your saved and trusted medical specialists';

	/// en: 'Feature Doctor'
	String get featureDoctor => 'Feature Doctor';

	/// en: 'Select Time'
	String get selectTime => 'Select Time';

	/// en: 'Select Date'
	String get selectDate => 'Select Date';

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Today, 23 Feb'
	String get dateOptionToday => 'Today, 23 Feb';

	/// en: 'Tomorrow, 24 Feb'
	String get dateOptionTomorrow => 'Tomorrow, 24 Feb';

	/// en: 'Thu, 25 Feb'
	String get dateOptionThu => 'Thu, 25 Feb';

	/// en: 'Fri, 26 Feb'
	String get dateOptionFri => 'Fri, 26 Feb';

	/// en: 'Sat, 27 Feb'
	String get dateOptionSat => 'Sat, 27 Feb';

	/// en: 'Sun, 28 Feb'
	String get dateOptionSun => 'Sun, 28 Feb';

	/// en: 'No slots available'
	String get noSlotsAvailable => 'No slots available';

	/// en: 'Next availability on $date'
	String nextAvailabilityOn({required Object date}) => 'Next availability on ${date}';

	/// en: 'Contact Clinic'
	String get contactClinic => 'Contact Clinic';

	/// en: 'Contacting clinic...'
	String get contactingClinic => 'Contacting clinic...';

	/// en: '$count slots available'
	String slotsAvailable({required Object count}) => '${count} slots available';

	/// en: '$count slots'
	String slotsCount({required Object count}) => '${count} slots';

	/// en: 'Afternoon'
	String get afternoonSlots => 'Afternoon';

	/// en: 'Evening'
	String get eveningSlots => 'Evening';

	/// en: 'Morning'
	String get morningSlots => 'Morning';

	/// en: 'Reminder'
	String get reminder => 'Reminder';

	/// en: 'Remind me 15 minutes before the appointment'
	String get reminderDescription => 'Remind me 15 minutes before the appointment';

	/// en: 'Book Appointment'
	String get bookAppointment => 'Book Appointment';

	/// en: 'Appointment booked successfully with $name on $date at $time'
	String appointmentBookedSuccess({required Object name, required Object date, required Object time}) => 'Appointment booked successfully with ${name} on ${date} at ${time}';

	/// en: 'View Details'
	String get viewDetails => 'View Details';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Thank You !'
	String get thankYou => 'Thank You !';

	/// en: 'Your Appointment Successful'
	String get appointmentSuccessful => 'Your Appointment Successful';

	/// en: 'You booked an appointment with $name on $date, at $time'
	String appointmentBookedWith({required Object name, required Object date, required Object time}) => 'You booked an appointment with ${name} on ${date}, at ${time}';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Edit your appointment'
	String get editYourAppointment => 'Edit your appointment';

	/// en: 'No user found with this email. Please check the email or create a new account.'
	String get userNotFoundError => 'No user found with this email. Please check the email or create a new account.';

	/// en: 'Invalid login credentials. Please try again.'
	String get wrongPasswordError => 'Invalid login credentials. Please try again.';

	/// en: 'This email is already in use by another account.'
	String get emailAlreadyInUseError => 'This email is already in use by another account.';

	/// en: 'Invalid email address.'
	String get invalidEmailError => 'Invalid email address.';

	/// en: 'The password is too weak. Please choose a stronger password.'
	String get weakPasswordError => 'The password is too weak. Please choose a stronger password.';

	/// en: 'This user account has been disabled. Please contact support.'
	String get userDisabledError => 'This user account has been disabled. Please contact support.';

	/// en: 'Too many attempts. Access temporarily disabled. Please try again later.'
	String get tooManyRequestsError => 'Too many attempts. Access temporarily disabled. Please try again later.';

	/// en: 'Network connection failed. Please check your internet connection.'
	String get networkRequestFailedError => 'Network connection failed. Please check your internet connection.';

	/// en: 'An account already exists with the same email but different sign-in credentials.'
	String get accountExistsWithDifferentCredentialError => 'An account already exists with the same email but different sign-in credentials.';

	/// en: 'This sign-in method is not enabled.'
	String get operationNotAllowedError => 'This sign-in method is not enabled.';

	/// en: 'Invalid verification code (OTP). Please try again.'
	String get invalidVerificationCodeError => 'Invalid verification code (OTP). Please try again.';

	/// en: 'Invalid verification ID. Please resend the code.'
	String get invalidVerificationIdError => 'Invalid verification ID. Please resend the code.';

	/// en: 'The verification code has expired. Please request a new code.'
	String get sessionExpiredError => 'The verification code has expired. Please request a new code.';

	/// en: 'Invalid phone number. Please include the country code (e.g., +20...).'
	String get invalidPhoneNumberError => 'Invalid phone number. Please include the country code (e.g., +20...).';

	/// en: 'SMS quota exceeded. Please try again later.'
	String get quotaExceededError => 'SMS quota exceeded. Please try again later.';

	/// en: 'reCAPTCHA security check failed. Please try again.'
	String get captchaCheckFailedError => 'reCAPTCHA security check failed. Please try again.';

	/// en: 'A service error occurred. Please try again later.'
	String get serviceError => 'A service error occurred. Please try again later.';

	/// en: 'An unexpected error occurred. Please try again.'
	String get unexpectedError => 'An unexpected error occurred. Please try again.';

	/// en: 'Google Sign-In configuration error. Please check SHA-1 and serverClientId.'
	String get googleSignInConfigError => 'Google Sign-In configuration error. Please check SHA-1 and serverClientId.';

	/// en: 'Sign-in was interrupted. Please try again.'
	String get googleSignInInterruptedError => 'Sign-in was interrupted. Please try again.';

	/// en: 'Google sign-in failed.'
	String get googleSignInFailedError => 'Google sign-in failed.';

	/// en: 'Please enter the 6-digit verification code.'
	String get enterSixDigitOtp => 'Please enter the 6-digit verification code.';

	/// en: 'Phone number verified successfully!'
	String get phoneVerifiedSuccess => 'Phone number verified successfully!';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Doctor Hunt',
			'skip' => 'Skip',
			'continueText' => 'Continue',
			'getStarted' => 'Get Started',
			'next' => 'Next',
			'back' => 'Back',
			'or' => 'OR',
			'arabicLanguage' => 'العربية',
			'englishLanguage' => 'English',
			'onboardingTitle1' => 'Find Trusted Doctors',
			'onboardingSubtitle1' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'onboardingTitle2' => 'Choose Best Doctors',
			'onboardingSubtitle2' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'onboardingTitle3' => 'Easy Appointments',
			'onboardingSubtitle3' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'emailAddress' => 'Email',
			'emailHint' => 'wpos/36@gmail.com',
			'password' => 'Password',
			'passwordHint' => '••••••••••••',
			'enterPasswordHint' => '••••••••••••',
			'fullName' => 'Name',
			'fullNameHint' => 'Name',
			'signIn' => 'Sign in',
			'logIn' => 'Log In',
			'createAccount' => 'Create account',
			'google' => 'Google',
			'facebook' => 'Facebook',
			'showPassword' => 'Show password',
			'hidePassword' => 'Hide password',
			'welcomeBack' => 'Welcome Back',
			'loginSubtitle' => 'Appoint the best doctor for your health and\nlive your life with full of happiness',
			'forgotPassword' => 'Forgot password',
			'forgotPasswordSubtitle' => 'Enter your email and we will send you a link to reset your password.',
			'dontHaveAccount' => 'Don’t have an account? ',
			'joinUs' => 'Join us',
			'createYourAccount' => 'Join us to start your search',
			'signupSubtitle' => 'Find trusted doctors, book appointments, and manage your healthcare.',
			'passwordLengthNotice' => 'At least 8 characters',
			'agreeTermsPrefix' => 'I agree to the ',
			'termsOfService' => 'Terms of Service',
			'andText' => ' and ',
			'privacyPolicy' => 'Privacy Policy',
			'alreadyHaveAccount' => 'Already have an account?',
			'verifyYourNumber' => 'Verify your number',
			'otpSentTo' => 'We sent a 6-digit code to ',
			'defaultPhoneNumber' => '+20 10 1234 5678',
			'resendTimerDefault' => '0:60',
			'resendCode' => 'Resend code',
			'codeSentAgain' => 'A new code was sent.',
			'otpCodeTitle' => 'Enter 6 Digits Code',
			'otpCodeDescription' => 'Enter the 6 digits code that you received on your phone.',
			'resetYourPassword' => 'Reset your password',
			'resetPasswordSubtitle' => 'Enter your email and we\'ll send you a\nsecure link to reset it.',
			'sendResetLink' => 'Send reset link',
			'rememberedPassword' => 'Remembered your password?',
			'passwordResetSuccess' => 'Password reset link sent to your email.',
			'roleSelectionTitle' => 'Choose your role',
			'roleSelectionSubtitle' => 'The selected role determines the experience and\navailable features.',
			'patientRoleTitle' => 'Patient',
			'patientRoleDescription' => 'Find doctors, book appointments, and manage your medical records.',
			'adminRoleTitle' => 'Admin',
			'adminRoleDescription' => 'Manage doctors, appointments, users, and the platform.',
			'enterFullName' => 'Enter your full name',
			'enterEmailAddress' => 'Enter your email address',
			'enterValidEmailAddress' => 'Enter a valid email address',
			'enterPassword' => 'Enter your password',
			'useAtLeast8Characters' => 'Use at least 8 characters',
			'hiSteven' => 'Hi Sama 👋',
			'findYourDoctor' => 'Find Your Doctor',
			'searchDoctorHint' => 'Search.... ',
			'live' => 'LIVE',
			'liveDoctor' => 'Live Doctor',
			'seeAll' => 'See all',
			'popularDoctor' => 'Popular Doctor',
			'featuredDoctor' => 'Featured Doctor',
			'dental' => 'Dental',
			'cardiology' => 'Cardiology',
			'eyeCare' => 'Eye Care',
			'nutrition' => 'Nutrition',
			'pediatric' => 'Pediatric',
			'neurology' => 'Neurology',
			'medicineSpecialist' => 'Medicine Specialist',
			'dentalSpecialist' => 'Dental Specialist',
			'heartSpecialist' => 'Heart Specialist',
			'eyeSpecialist' => 'Eye Specialist',
			'generalSurgeon' => 'General Surgeon',
			'perHour' => '/hour',
			'reviews' => 'Reviews',
			'findDoctors' => 'Find Doctors',
			'searchDentistHint' => 'Dentist',
			'dentist' => 'Dentist',
			'yearsExperienceSuffix' => 'Years experience',
			'patientStories' => 'Patient Stories',
			'nextAvailable' => 'Next Available',
			'bookNow' => 'Book Now',
			'noDoctorsFound' => 'No doctors found',
			'bookingComingSoon' => 'Booking is not available yet.',
			'bookingMessage' => ({required Object name}) => 'Booking appointment with ${name}...',
			'tomorrow' => 'tomorrow',
			'liveCardiologist' => 'Cardiologist',
			'liveDentist' => 'Dentist',
			'livePediatrician' => 'Pediatrician',
			'liveNeurologist' => 'Neurologist',
			'serviceOne' => 'Patient care should be the number one priority.',
			'serviceTwo' => 'If you run your practice you know how frustrating.',
			'serviceThree' => 'That\'s why some of appointment reminder system.',
			'doctorDetails' => 'Doctor Details',
			'services' => 'Services',
			'statRunning' => 'Running',
			'statOngoing' => 'Ongoing',
			'statPatient' => 'Patient',
			'profile' => 'Profile',
			'setUpYourProfile' => 'Set up your profile',
			'profileHeaderSubtitle' => 'Update your profile to connect your doctor with\nbetter impression.',
			'personalInformation' => 'Personal information',
			'contactNumber' => 'Contact Number',
			'dateOfBirth' => 'Date of birth',
			'dateOfBirthPlaceholder' => 'DD MM YYYY',
			'location' => 'Location',
			'addDetails' => 'Add Details',
			'settings' => 'Settings',
			'language' => 'Language',
			'profileUpdatedSuccess' => 'Profile updated successfully',
			'logOut' => 'Log Out',
			'favouriteDoctors' => 'Favourite Doctors',
			'favouriteDoctorsSubtitle' => 'Your saved and trusted medical specialists',
			'featureDoctor' => 'Feature Doctor',
			'selectTime' => 'Select Time',
			'selectDate' => 'Select Date',
			'today' => 'Today',
			'dateOptionToday' => 'Today, 23 Feb',
			'dateOptionTomorrow' => 'Tomorrow, 24 Feb',
			'dateOptionThu' => 'Thu, 25 Feb',
			'dateOptionFri' => 'Fri, 26 Feb',
			'dateOptionSat' => 'Sat, 27 Feb',
			'dateOptionSun' => 'Sun, 28 Feb',
			'noSlotsAvailable' => 'No slots available',
			'nextAvailabilityOn' => ({required Object date}) => 'Next availability on ${date}',
			'contactClinic' => 'Contact Clinic',
			'contactingClinic' => 'Contacting clinic...',
			'slotsAvailable' => ({required Object count}) => '${count} slots available',
			'slotsCount' => ({required Object count}) => '${count} slots',
			'afternoonSlots' => 'Afternoon',
			'eveningSlots' => 'Evening',
			'morningSlots' => 'Morning',
			'reminder' => 'Reminder',
			'reminderDescription' => 'Remind me 15 minutes before the appointment',
			'bookAppointment' => 'Book Appointment',
			'appointmentBookedSuccess' => ({required Object name, required Object date, required Object time}) => 'Appointment booked successfully with ${name} on ${date} at ${time}',
			'viewDetails' => 'View Details',
			'confirm' => 'Confirm',
			'thankYou' => 'Thank You !',
			'appointmentSuccessful' => 'Your Appointment Successful',
			'appointmentBookedWith' => ({required Object name, required Object date, required Object time}) => 'You booked an appointment with ${name} on ${date}, at ${time}',
			'done' => 'Done',
			'editYourAppointment' => 'Edit your appointment',
			'userNotFoundError' => 'No user found with this email. Please check the email or create a new account.',
			'wrongPasswordError' => 'Invalid login credentials. Please try again.',
			'emailAlreadyInUseError' => 'This email is already in use by another account.',
			'invalidEmailError' => 'Invalid email address.',
			'weakPasswordError' => 'The password is too weak. Please choose a stronger password.',
			'userDisabledError' => 'This user account has been disabled. Please contact support.',
			'tooManyRequestsError' => 'Too many attempts. Access temporarily disabled. Please try again later.',
			'networkRequestFailedError' => 'Network connection failed. Please check your internet connection.',
			'accountExistsWithDifferentCredentialError' => 'An account already exists with the same email but different sign-in credentials.',
			'operationNotAllowedError' => 'This sign-in method is not enabled.',
			'invalidVerificationCodeError' => 'Invalid verification code (OTP). Please try again.',
			'invalidVerificationIdError' => 'Invalid verification ID. Please resend the code.',
			'sessionExpiredError' => 'The verification code has expired. Please request a new code.',
			'invalidPhoneNumberError' => 'Invalid phone number. Please include the country code (e.g., +20...).',
			'quotaExceededError' => 'SMS quota exceeded. Please try again later.',
			'captchaCheckFailedError' => 'reCAPTCHA security check failed. Please try again.',
			'serviceError' => 'A service error occurred. Please try again later.',
			'unexpectedError' => 'An unexpected error occurred. Please try again.',
			'googleSignInConfigError' => 'Google Sign-In configuration error. Please check SHA-1 and serverClientId.',
			'googleSignInInterruptedError' => 'Sign-in was interrupted. Please try again.',
			'googleSignInFailedError' => 'Google sign-in failed.',
			'enterSixDigitOtp' => 'Please enter the 6-digit verification code.',
			'phoneVerifiedSuccess' => 'Phone number verified successfully!',
			_ => null,
		};
	}
}
