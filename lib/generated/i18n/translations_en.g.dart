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

	/// en: 'Doctor'
	String get doctorRoleTitle => 'Doctor';

	/// en: 'Manage appointments and consult with patients.'
	String get doctorRoleDescription => 'Manage appointments and consult with patients.';

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

	/// en: 'Please enter your phone number'
	String get enterPhoneNumber => 'Please enter your phone number';

	/// en: 'Please enter a valid phone number (e.g. 01012345678)'
	String get enterValidPhoneNumber => 'Please enter a valid phone number (e.g. 01012345678)';

	/// en: 'Enter your password'
	String get enterPassword => 'Enter your password';

	/// en: 'Use at least 8 characters'
	String get useAtLeast8Characters => 'Use at least 8 characters';

	/// en: 'Hi 👋'
	String get greetingGeneric => 'Hi 👋';

	/// en: 'Hi $name 👋'
	String greetingWithName({required Object name}) => 'Hi ${name} 👋';

	/// en: 'Find Your Doctor'
	String get findYourDoctor => 'Find Your Doctor';

	/// en: 'Search.... '
	String get searchDoctorHint => 'Search.... ';

	/// en: 'LIVE'
	String get live => 'LIVE';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'Couldn't update favorites. Try again.'
	String get favoriteUpdateFailed => 'Couldn\'t update favorites. Try again.';

	/// en: 'Top Rated Doctors'
	String get topRatedDoctors => 'Top Rated Doctors';

	/// en: 'Popular Doctor'
	String get popularDoctor => 'Popular Doctor';

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

	/// en: '$rating · $count Reviews'
	String ratingSummary({required Object rating, required Object count}) => '${rating} · ${count} Reviews';

	/// en: 'Recent Reviews'
	String get recentReviews => 'Recent Reviews';

	/// en: 'No reviews yet'
	String get noReviewsYet => 'No reviews yet';

	/// en: 'Clinic location has not been set yet'
	String get clinicLocationNotSet => 'Clinic location has not been set yet';

	/// en: 'Booking Review'
	String get bookingReview => 'Booking Review';

	/// en: 'Confirm Booking'
	String get confirmBooking => 'Confirm Booking';

	/// en: 'Appointment Date'
	String get appointmentDate => 'Appointment Date';

	/// en: 'Appointment Time'
	String get appointmentTime => 'Appointment Time';

	/// en: 'Consultation Fee'
	String get consultationFee => 'Consultation Fee';

	/// en: 'Clinic Address'
	String get clinicAddress => 'Clinic Address';

	/// en: 'Reviews'
	String get reviews => 'Reviews';

	/// en: 'Find Doctors'
	String get findDoctors => 'Find Doctors';

	/// en: 'Dentist'
	String get searchDentistHint => 'Dentist';

	/// en: 'Dentist'
	String get dentist => 'Dentist';

	/// en: 'Book Now'
	String get bookNow => 'Book Now';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'Popular Doctors'
	String get popularDoctors => 'Popular Doctors';

	/// en: 'No doctors found'
	String get noDoctorsFound => 'No doctors found';

	/// en: 'Booking is not available yet.'
	String get bookingComingSoon => 'Booking is not available yet.';

	/// en: 'Doctor has no available times yet'
	String get doctorNoAvailableTimes => 'Doctor has no available times yet';

	/// en: 'Booking appointment with $name...'
	String bookingMessage({required Object name}) => 'Booking appointment with ${name}...';

	/// en: 'Tomorrow'
	String get tomorrow => 'Tomorrow';

	/// en: 'Doctor Details'
	String get doctorDetails => 'Doctor Details';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Set up your profile'
	String get setUpYourProfile => 'Set up your profile';

	/// en: 'Update your profile to connect your doctor with better impression.'
	String get profileHeaderSubtitle => 'Update your profile to connect your doctor with\nbetter impression.';

	/// en: 'Personal information'
	String get personalInformation => 'Personal information';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Contact Number'
	String get contactNumber => 'Contact Number';

	/// en: 'Date of birth'
	String get dateOfBirth => 'Date of birth';

	/// en: 'DD MM YYYY'
	String get dateOfBirthPlaceholder => 'DD MM YYYY';

	/// en: 'Gender'
	String get gender => 'Gender';

	/// en: 'Location'
	String get location => 'Location';

	/// en: 'Add Details'
	String get addDetails => 'Add Details';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Change Password'
	String get changePassword => 'Change Password';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Account Settings'
	String get accountSettings => 'Account Settings';

	/// en: 'More Options'
	String get moreOptions => 'More Options';

	/// en: 'Current Password'
	String get currentPassword => 'Current Password';

	/// en: 'New Password'
	String get newPassword => 'New Password';

	/// en: 'Confirm New Password'
	String get confirmNewPassword => 'Confirm New Password';

	/// en: 'Password changed successfully'
	String get passwordChangedSuccess => 'Password changed successfully';

	/// en: 'Passwords do not match'
	String get passwordsDoNotMatch => 'Passwords do not match';

	/// en: 'Wrong current password. Please try again.'
	String get wrongCurrentPassword => 'Wrong current password. Please try again.';

	/// en: 'Edit Profile'
	String get editProfile => 'Edit Profile';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Male'
	String get male => 'Male';

	/// en: 'Female'
	String get female => 'Female';

	/// en: 'Select date of birth'
	String get selectDob => 'Select date of birth';

	/// en: 'Profile updated successfully'
	String get profileUpdatedSuccess => 'Profile updated successfully';

	/// en: 'Log Out'
	String get logOutConfirmTitle => 'Log Out';

	/// en: 'Are you sure you want to logout?'
	String get logOutConfirmMessage => 'Are you sure you want to logout?';

	/// en: 'Log Out'
	String get logOut => 'Log Out';

	/// en: 'Ok'
	String get ok => 'Ok';

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

	/// en: 'Available Slots'
	String get availableSlots => 'Available Slots';

	/// en: 'Next availability on $date'
	String nextAvailabilityOn({required Object date}) => 'Next availability on ${date}';

	/// en: 'OR'
	String get or => 'OR';

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

	/// en: 'Date'
	String get dateLabel => 'Date';

	/// en: 'Time'
	String get timeLabel => 'Time';

	/// en: 'Fee'
	String get feeLabel => 'Fee';

	/// en: 'Appointment'
	String get appointmentLabel => 'Appointment';

	/// en: 'Thank You !'
	String get thankYou => 'Thank You !';

	/// en: 'Your Appointment Successful'
	String get appointmentSuccessful => 'Your Appointment Successful';

	/// en: 'You booked an appointment with $name on $date, at $time'
	String appointmentBookedWith({required Object name, required Object date, required Object time}) => 'You booked an appointment with ${name} on ${date}, at ${time}';

	/// en: 'This time was just booked by someone else. Please choose another slot.'
	String get slotAlreadyBooked => 'This time was just booked by someone else. Please choose another slot.';

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

	/// en: 'Please agree to the Terms of Service and Privacy Policy to continue.'
	String get acceptTermsAndPrivacyWarning => 'Please agree to the Terms of Service and Privacy Policy to continue.';

	/// en: 'Account created successfully!'
	String get accountCreatedSuccess => 'Account created successfully!';

	/// en: 'This account does not have admin permissions.'
	String get adminPermissionDenied => 'This account does not have admin permissions.';

	/// en: 'Welcome Back!'
	String get adminLoginTitle => 'Welcome Back!';

	/// en: 'Login to your admin account'
	String get adminLoginSubtitle => 'Login to your admin account';

	/// en: 'admin@doctorhunt.com'
	String get adminEmailHint => 'admin@doctorhunt.com';

	/// en: 'Secure admin access only'
	String get secureAdminAccessOnly => 'Secure admin access only';

	/// en: 'Doctors'
	String get doctorsTitle => 'Doctors';

	/// en: 'Total Doctors'
	String get totalDoctors => 'Total Doctors';

	/// en: 'Active Doctors'
	String get activeDoctors => 'Active Doctors';

	/// en: '$label ($count)'
	String labelWithCount({required Object label, required Object count}) => '${label} (${count})';

	/// en: 'Active'
	String get activeLabel => 'Active';

	/// en: 'Inactive'
	String get inactiveLabel => 'Inactive';

	/// en: 'Add Doctor'
	String get addDoctor => 'Add Doctor';

	/// en: 'Search doctors...'
	String get searchAdminDoctorsHint => 'Search doctors...';

	/// en: 'There are currently no doctors registered on Doctor Hunt. Add your first doctor to get started.'
	String get noDoctorsYet => 'There are currently no doctors registered on Doctor Hunt. Add your first doctor to get started.';

	/// en: 'Create Doctor'
	String get createDoctorTitle => 'Create Doctor';

	/// en: 'Doctor Name'
	String get doctorNameLabel => 'Doctor Name';

	/// en: 'Enter doctor name'
	String get doctorNameHint => 'Enter doctor name';

	/// en: 'Specialty'
	String get specialtyLabel => 'Specialty';

	/// en: 'Select specialty'
	String get selectSpecialtyHint => 'Select specialty';

	/// en: 'Tap to pick an image'
	String get tapToPickImage => 'Tap to pick an image';

	/// en: 'Add photo'
	String get addPhoto => 'Add photo';

	/// en: 'Tap photo to change'
	String get tapPhotoToChange => 'Tap photo to change';

	/// en: 'Create Doctor'
	String get createDoctorButton => 'Create Doctor';

	/// en: 'Doctor created successfully'
	String get doctorCreatedSuccess => 'Doctor created successfully';

	/// en: 'Consultation Fee'
	String get doctorFeeLabel => 'Consultation Fee';

	/// en: 'Enter fee, e.g. 30'
	String get doctorFeeHint => 'Enter fee, e.g. 30';

	/// en: 'Please enter a fee greater than 0'
	String get enterValidFee => 'Please enter a fee greater than 0';

	/// en: 'Activate'
	String get activate => 'Activate';

	/// en: 'Deactivate'
	String get deactivate => 'Deactivate';

	/// en: 'Patients will see this doctor and can book again.'
	String get activateDoctorConfirm => 'Patients will see this doctor and can book again.';

	/// en: 'Patients will no longer see or book this doctor. Booking history is kept.'
	String get deactivateDoctorConfirm => 'Patients will no longer see or book this doctor. Booking history is kept.';

	/// en: 'Doctor activated'
	String get doctorActivatedSuccess => 'Doctor activated';

	/// en: 'Doctor deactivated'
	String get doctorDeactivatedSuccess => 'Doctor deactivated';

	/// en: 'Please enter the doctor's name'
	String get enterDoctorName => 'Please enter the doctor\'s name';

	/// en: 'Please select a specialty'
	String get selectSpecialtyError => 'Please select a specialty';

	/// en: 'Failed to pick image. Please try again.'
	String get pickImageError => 'Failed to pick image. Please try again.';

	/// en: 'Failed to upload image. Please try again.'
	String get uploadImageError => 'Failed to upload image. Please try again.';

	/// en: 'Cardiologist'
	String get specialtyCardiologist => 'Cardiologist';

	/// en: 'Orthopedic'
	String get specialtyOrthopedic => 'Orthopedic';

	/// en: 'Dentist'
	String get specialtyDentist => 'Dentist';

	/// en: 'Pediatrician'
	String get specialtyPediatrician => 'Pediatrician';

	/// en: 'Dermatologist'
	String get specialtyDermatologist => 'Dermatologist';

	/// en: 'Neurologist'
	String get specialtyNeurologist => 'Neurologist';

	/// en: 'Eye Specialist'
	String get specialtyEyeSpecialist => 'Eye Specialist';

	/// en: 'Medicine Specialist'
	String get specialtyMedicineSpecialist => 'Medicine Specialist';

	/// en: 'General Surgeon'
	String get specialtyGeneralSurgeon => 'General Surgeon';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Edit Doctor'
	String get editDoctorTitle => 'Edit Doctor';

	/// en: 'Manage Availability'
	String get manageAvailability => 'Manage Availability';

	/// en: 'Rating'
	String get rating => 'Rating';

	/// en: 'Doctor updated successfully'
	String get doctorUpdatedSuccess => 'Doctor updated successfully';

	/// en: 'Change image'
	String get changeImage => 'Change image';

	/// en: 'Dr. Pediatrician'
	String get placeholderDoctorName => 'Dr. Pediatrician';

	/// en: 'Home'
	String get tabHome => 'Home';

	/// en: 'Favorites'
	String get tabFavorites => 'Favorites';

	/// en: 'Appointments'
	String get tabAppointments => 'Appointments';

	/// en: 'My Appointments'
	String get myAppointments => 'My Appointments';

	/// en: 'No favorite doctors yet'
	String get noFavoritesFound => 'No favorite doctors yet';

	/// en: 'Appointments'
	String get appointments => 'Appointments';

	/// en: 'Upcoming'
	String get upcoming => 'Upcoming';

	/// en: 'Completed'
	String get completed => 'Completed';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: 'Cancel Appointment'
	String get cancelAppointment => 'Cancel Appointment';

	/// en: 'Rate Doctor'
	String get rateDoctor => 'Rate Doctor';

	/// en: 'Reviewed'
	String get reviewed => 'Reviewed';

	/// en: 'Tap to rate your visit'
	String get tapToRateYourVisit => 'Tap to rate your visit';

	/// en: 'Cancelled by you'
	String get cancelledByYou => 'Cancelled by you';

	/// en: 'Cancelled by clinic'
	String get cancelledByClinic => 'Cancelled by clinic';

	/// en: 'Cancel Appointment'
	String get cancelAppointmentTitle => 'Cancel Appointment';

	/// en: 'Are you sure you want to cancel this appointment?'
	String get cancelAppointmentMessage => 'Are you sure you want to cancel this appointment?';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Appointment cancelled successfully'
	String get appointmentCancelledSuccess => 'Appointment cancelled successfully';

	/// en: 'No upcoming appointments'
	String get noUpcomingAppointments => 'No upcoming appointments';

	/// en: 'No completed appointments'
	String get noCompletedAppointments => 'No completed appointments';

	/// en: 'No cancelled appointments'
	String get noCancelledAppointments => 'No cancelled appointments';

	/// en: 'Your appointments will appear here.'
	String get noAppointmentsDescription => 'Your appointments will appear here.';

	/// en: 'Upcoming'
	String get statusUpcoming => 'Upcoming';

	/// en: 'Completed'
	String get statusCompleted => 'Completed';

	/// en: 'Cancelled'
	String get statusCancelled => 'Cancelled';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Appointment Details'
	String get appointmentDetails => 'Appointment Details';

	/// en: 'Rate Doctor'
	String get rateDoctorTitle => 'Rate Doctor';

	/// en: 'Your feedback helps other patients and improves care'
	String get ratingDoctorSubtitle => 'Your feedback helps other patients and improves care';

	/// en: 'Please select a rating'
	String get selectRatingRequired => 'Please select a rating';

	/// en: 'Write your review (optional)...'
	String get reviewCommentHint => 'Write your review (optional)...';

	/// en: 'Your Review'
	String get reviewCommentLabel => 'Your Review';

	/// en: 'Submit'
	String get submitReview => 'Submit';

	/// en: 'Review added'
	String get reviewAddedSuccess => 'Review added';

	/// en: 'Only completed appointments can be reviewed'
	String get appointmentNotCompleted => 'Only completed appointments can be reviewed';

	/// en: 'You have already reviewed this appointment'
	String get alreadyReviewed => 'You have already reviewed this appointment';

	/// en: 'Availability'
	String get availability => 'Availability';

	/// en: 'Not set'
	String get notSet => 'Not set';

	/// en: 'Activate Doctor'
	String get activateDoctorTitle => 'Activate Doctor';

	/// en: 'Deactivate Doctor'
	String get deactivateDoctorTitle => 'Deactivate Doctor';

	/// en: 'Doctor Availability'
	String get doctorAvailability => 'Doctor Availability';

	/// en: 'Working Days'
	String get workingDays => 'Working Days';

	/// en: '$count days enabled'
	String daysEnabled({required Object count}) => '${count} days enabled';

	/// en: 'Working Hours'
	String get workingHours => 'Working Hours';

	/// en: 'Start Time'
	String get startTime => 'Start Time';

	/// en: 'End Time'
	String get endTime => 'End Time';

	/// en: 'Slot Duration'
	String get slotDuration => 'Slot Duration';

	/// en: '$count min'
	String minutesDuration({required Object count}) => '${count} min';

	/// en: 'Please select at least one working day'
	String get errorSelectAtLeastOneDay => 'Please select at least one working day';

	/// en: 'Start time must be before end time'
	String get errorStartMustBeBeforeEnd => 'Start time must be before end time';

	/// en: 'Slot duration cannot exceed working hours'
	String get errorSlotDurationTooLong => 'Slot duration cannot exceed working hours';

	/// en: 'Availability updated successfully'
	String get availabilityUpdatedSuccess => 'Availability updated successfully';

	/// en: 'Save Availability'
	String get saveAvailability => 'Save Availability';

	/// en: 'Admin Profile'
	String get adminProfile => 'Admin Profile';

	/// en: 'Edit your details & clinic location'
	String get adminProfileSubtitle => 'Edit your details & clinic location';

	/// en: 'Save Changes'
	String get saveChanges => 'Save Changes';

	/// en: 'Clinic Address (Arabic)'
	String get clinicAddressAr => 'Clinic Address (Arabic)';

	/// en: 'Clinic Address (English)'
	String get clinicAddressEn => 'Clinic Address (English)';

	/// en: 'Clinic Location'
	String get clinicLocation => 'Clinic Location';

	/// en: 'Tap anywhere on the map to set clinic location pin'
	String get tapMapToSetLocation => 'Tap anywhere on the map to set clinic location pin';

	/// en: 'Please enter clinic address in Arabic'
	String get clinicAddressArRequired => 'Please enter clinic address in Arabic';

	/// en: 'Please enter clinic address in English'
	String get clinicAddressEnRequired => 'Please enter clinic address in English';

	/// en: 'Please select clinic location on the map'
	String get clinicLocationRequired => 'Please select clinic location on the map';

	/// en: 'Verification email sent to $email'
	String emailVerificationSent({required Object email}) => 'Verification email sent to ${email}';

	/// en: 'Please re-login before updating your email'
	String get requiresRecentLogin => 'Please re-login before updating your email';

	/// en: 'Admin profile and clinic updated successfully'
	String get adminProfileUpdatedSuccess => 'Admin profile and clinic updated successfully';

	/// en: 'Patient: $name'
	String patientNameLabel({required Object name}) => 'Patient: ${name}';

	/// en: 'Doctor: $name'
	String doctorWithNameLabel({required Object name}) => 'Doctor: ${name}';

	/// en: 'Mark as Completed'
	String get markCompleted => 'Mark as Completed';

	/// en: 'Mark Appointment Completed'
	String get markCompletedTitle => 'Mark Appointment Completed';

	/// en: 'Are you sure you want to mark this appointment as completed?'
	String get markCompletedMessage => 'Are you sure you want to mark this appointment as completed?';

	/// en: 'Appointment marked as completed successfully'
	String get appointmentMarkedCompletedSuccess => 'Appointment marked as completed successfully';

	/// en: 'Patient Information'
	String get patientInfo => 'Patient Information';

	/// en: 'Patient Name'
	String get patientName => 'Patient Name';

	/// en: 'Phone Number'
	String get patientPhone => 'Phone Number';

	/// en: 'Email'
	String get patientEmail => 'Email';

	/// en: 'Cancelled by patient'
	String get cancelledByPatient => 'Cancelled by patient';

	/// en: 'Cancelled by admin'
	String get cancelledByAdmin => 'Cancelled by admin';

	/// en: 'Build version'
	String get buildVersion => 'Build version';

	/// en: 'v1.0.0'
	String get versionValue => 'v1.0.0';

	/// en: 'Doctor Hunt Apps Privacy Policy'
	String get privacyPolicyTitle => 'Doctor Hunt Apps Privacy Policy';

	/// en: 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words believable. It is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more'
	String get privacyPolicyIntro => 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words believable. It is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more';

	/// en: 'The standard chunk of lorem Ipsum used since 1500s is reproduced below for those interested.'
	String get privacyPolicyBullet1 => 'The standard chunk of lorem Ipsum used since 1500s is reproduced below for those interested.';

	/// en: 'Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum". The point of using.'
	String get privacyPolicyBullet2 => 'Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum". The point of using.';

	/// en: 'Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted.'
	String get privacyPolicyBullet3 => 'Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted.';

	/// en: 'The point of using Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted.'
	String get privacyPolicyBullet4 => 'The point of using Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted.';

	/// en: 'It is a long established fact that reader distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a moreIt is a long established.'
	String get privacyPolicyOutro => 'It is a long established fact that reader distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a moreIt is a long established.';

	/// en: '...'
	String get loadingEllipsis => '...';

	/// en: 'Doctor Name (AR)'
	String get doctorNameArLabel => 'Doctor Name (AR)';

	/// en: 'Doctor Name (EN)'
	String get doctorNameEnLabel => 'Doctor Name (EN)';

	/// en: 'Set weekly working days, hours and appointment duration'
	String get doctorAvailabilitySubtitle => 'Set weekly working days, hours and appointment duration';

	/// en: '$count slots per day'
	String slotsPerDay({required Object count}) => '${count} slots per day';

	/// en: '$duration / slot'
	String perSlot({required Object duration}) => '${duration} / slot';
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
			'passwordResetSuccess' => 'Password reset link sent to your email.',
			'roleSelectionTitle' => 'Choose your role',
			'roleSelectionSubtitle' => 'The selected role determines the experience and\navailable features.',
			'patientRoleTitle' => 'Patient',
			'patientRoleDescription' => 'Find doctors, book appointments, and manage your medical records.',
			'doctorRoleTitle' => 'Doctor',
			'doctorRoleDescription' => 'Manage appointments and consult with patients.',
			'adminRoleTitle' => 'Admin',
			'adminRoleDescription' => 'Manage doctors, appointments, users, and the platform.',
			'enterFullName' => 'Enter your full name',
			'enterEmailAddress' => 'Enter your email address',
			'enterValidEmailAddress' => 'Enter a valid email address',
			'enterPhoneNumber' => 'Please enter your phone number',
			'enterValidPhoneNumber' => 'Please enter a valid phone number (e.g. 01012345678)',
			'enterPassword' => 'Enter your password',
			'useAtLeast8Characters' => 'Use at least 8 characters',
			'greetingGeneric' => 'Hi 👋',
			'greetingWithName' => ({required Object name}) => 'Hi ${name} 👋',
			'findYourDoctor' => 'Find Your Doctor',
			'searchDoctorHint' => 'Search.... ',
			'live' => 'LIVE',
			'seeAll' => 'See all',
			'favoriteUpdateFailed' => 'Couldn\'t update favorites. Try again.',
			'topRatedDoctors' => 'Top Rated Doctors',
			'popularDoctor' => 'Popular Doctor',
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
			'ratingSummary' => ({required Object rating, required Object count}) => '${rating} · ${count} Reviews',
			'recentReviews' => 'Recent Reviews',
			'noReviewsYet' => 'No reviews yet',
			'clinicLocationNotSet' => 'Clinic location has not been set yet',
			'bookingReview' => 'Booking Review',
			'confirmBooking' => 'Confirm Booking',
			'appointmentDate' => 'Appointment Date',
			'appointmentTime' => 'Appointment Time',
			'consultationFee' => 'Consultation Fee',
			'clinicAddress' => 'Clinic Address',
			'reviews' => 'Reviews',
			'findDoctors' => 'Find Doctors',
			'searchDentistHint' => 'Dentist',
			'dentist' => 'Dentist',
			'bookNow' => 'Book Now',
			'filterAll' => 'All',
			'favorites' => 'Favorites',
			'popularDoctors' => 'Popular Doctors',
			'noDoctorsFound' => 'No doctors found',
			'bookingComingSoon' => 'Booking is not available yet.',
			'doctorNoAvailableTimes' => 'Doctor has no available times yet',
			'bookingMessage' => ({required Object name}) => 'Booking appointment with ${name}...',
			'tomorrow' => 'Tomorrow',
			'doctorDetails' => 'Doctor Details',
			'profile' => 'Profile',
			'setUpYourProfile' => 'Set up your profile',
			'profileHeaderSubtitle' => 'Update your profile to connect your doctor with\nbetter impression.',
			'personalInformation' => 'Personal information',
			'email' => 'Email',
			'contactNumber' => 'Contact Number',
			'dateOfBirth' => 'Date of birth',
			'dateOfBirthPlaceholder' => 'DD MM YYYY',
			'gender' => 'Gender',
			'location' => 'Location',
			'addDetails' => 'Add Details',
			'settings' => 'Settings',
			'language' => 'Language',
			'changePassword' => 'Change Password',
			'notifications' => 'Notifications',
			'accountSettings' => 'Account Settings',
			'moreOptions' => 'More Options',
			'currentPassword' => 'Current Password',
			'newPassword' => 'New Password',
			'confirmNewPassword' => 'Confirm New Password',
			'passwordChangedSuccess' => 'Password changed successfully',
			'passwordsDoNotMatch' => 'Passwords do not match',
			'wrongCurrentPassword' => 'Wrong current password. Please try again.',
			'editProfile' => 'Edit Profile',
			'save' => 'Save',
			'male' => 'Male',
			'female' => 'Female',
			'selectDob' => 'Select date of birth',
			'profileUpdatedSuccess' => 'Profile updated successfully',
			'logOutConfirmTitle' => 'Log Out',
			'logOutConfirmMessage' => 'Are you sure you want to logout?',
			'logOut' => 'Log Out',
			'ok' => 'Ok',
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
			'availableSlots' => 'Available Slots',
			'nextAvailabilityOn' => ({required Object date}) => 'Next availability on ${date}',
			'or' => 'OR',
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
			'dateLabel' => 'Date',
			'timeLabel' => 'Time',
			'feeLabel' => 'Fee',
			'appointmentLabel' => 'Appointment',
			'thankYou' => 'Thank You !',
			'appointmentSuccessful' => 'Your Appointment Successful',
			'appointmentBookedWith' => ({required Object name, required Object date, required Object time}) => 'You booked an appointment with ${name} on ${date}, at ${time}',
			'slotAlreadyBooked' => 'This time was just booked by someone else. Please choose another slot.',
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
			'acceptTermsAndPrivacyWarning' => 'Please agree to the Terms of Service and Privacy Policy to continue.',
			'accountCreatedSuccess' => 'Account created successfully!',
			'adminPermissionDenied' => 'This account does not have admin permissions.',
			'adminLoginTitle' => 'Welcome Back!',
			'adminLoginSubtitle' => 'Login to your admin account',
			'adminEmailHint' => 'admin@doctorhunt.com',
			'secureAdminAccessOnly' => 'Secure admin access only',
			'doctorsTitle' => 'Doctors',
			'totalDoctors' => 'Total Doctors',
			'activeDoctors' => 'Active Doctors',
			'labelWithCount' => ({required Object label, required Object count}) => '${label} (${count})',
			'activeLabel' => 'Active',
			'inactiveLabel' => 'Inactive',
			'addDoctor' => 'Add Doctor',
			'searchAdminDoctorsHint' => 'Search doctors...',
			'noDoctorsYet' => 'There are currently no doctors registered on Doctor Hunt. Add your first doctor to get started.',
			'createDoctorTitle' => 'Create Doctor',
			'doctorNameLabel' => 'Doctor Name',
			'doctorNameHint' => 'Enter doctor name',
			'specialtyLabel' => 'Specialty',
			'selectSpecialtyHint' => 'Select specialty',
			'tapToPickImage' => 'Tap to pick an image',
			'addPhoto' => 'Add photo',
			'tapPhotoToChange' => 'Tap photo to change',
			'createDoctorButton' => 'Create Doctor',
			'doctorCreatedSuccess' => 'Doctor created successfully',
			'doctorFeeLabel' => 'Consultation Fee',
			'doctorFeeHint' => 'Enter fee, e.g. 30',
			'enterValidFee' => 'Please enter a fee greater than 0',
			'activate' => 'Activate',
			'deactivate' => 'Deactivate',
			'activateDoctorConfirm' => 'Patients will see this doctor and can book again.',
			'deactivateDoctorConfirm' => 'Patients will no longer see or book this doctor. Booking history is kept.',
			'doctorActivatedSuccess' => 'Doctor activated',
			'doctorDeactivatedSuccess' => 'Doctor deactivated',
			'enterDoctorName' => 'Please enter the doctor\'s name',
			'selectSpecialtyError' => 'Please select a specialty',
			'pickImageError' => 'Failed to pick image. Please try again.',
			'uploadImageError' => 'Failed to upload image. Please try again.',
			'specialtyCardiologist' => 'Cardiologist',
			'specialtyOrthopedic' => 'Orthopedic',
			'specialtyDentist' => 'Dentist',
			'specialtyPediatrician' => 'Pediatrician',
			'specialtyDermatologist' => 'Dermatologist',
			'specialtyNeurologist' => 'Neurologist',
			'specialtyEyeSpecialist' => 'Eye Specialist',
			'specialtyMedicineSpecialist' => 'Medicine Specialist',
			'specialtyGeneralSurgeon' => 'General Surgeon',
			'edit' => 'Edit',
			'cancel' => 'Cancel',
			'editDoctorTitle' => 'Edit Doctor',
			'manageAvailability' => 'Manage Availability',
			'rating' => 'Rating',
			'doctorUpdatedSuccess' => 'Doctor updated successfully',
			'changeImage' => 'Change image',
			'placeholderDoctorName' => 'Dr. Pediatrician',
			'tabHome' => 'Home',
			'tabFavorites' => 'Favorites',
			'tabAppointments' => 'Appointments',
			'myAppointments' => 'My Appointments',
			'noFavoritesFound' => 'No favorite doctors yet',
			'appointments' => 'Appointments',
			'upcoming' => 'Upcoming',
			'completed' => 'Completed',
			'cancelled' => 'Cancelled',
			'cancelAppointment' => 'Cancel Appointment',
			'rateDoctor' => 'Rate Doctor',
			'reviewed' => 'Reviewed',
			'tapToRateYourVisit' => 'Tap to rate your visit',
			'cancelledByYou' => 'Cancelled by you',
			'cancelledByClinic' => 'Cancelled by clinic',
			'cancelAppointmentTitle' => 'Cancel Appointment',
			'cancelAppointmentMessage' => 'Are you sure you want to cancel this appointment?',
			'confirm' => 'Confirm',
			'appointmentCancelledSuccess' => 'Appointment cancelled successfully',
			'noUpcomingAppointments' => 'No upcoming appointments',
			'noCompletedAppointments' => 'No completed appointments',
			'noCancelledAppointments' => 'No cancelled appointments',
			'noAppointmentsDescription' => 'Your appointments will appear here.',
			'statusUpcoming' => 'Upcoming',
			'statusCompleted' => 'Completed',
			'statusCancelled' => 'Cancelled',
			'retry' => 'Retry',
			'appointmentDetails' => 'Appointment Details',
			'rateDoctorTitle' => 'Rate Doctor',
			'ratingDoctorSubtitle' => 'Your feedback helps other patients and improves care',
			'selectRatingRequired' => 'Please select a rating',
			'reviewCommentHint' => 'Write your review (optional)...',
			'reviewCommentLabel' => 'Your Review',
			'submitReview' => 'Submit',
			'reviewAddedSuccess' => 'Review added',
			'appointmentNotCompleted' => 'Only completed appointments can be reviewed',
			'alreadyReviewed' => 'You have already reviewed this appointment',
			'availability' => 'Availability',
			'notSet' => 'Not set',
			'activateDoctorTitle' => 'Activate Doctor',
			'deactivateDoctorTitle' => 'Deactivate Doctor',
			'doctorAvailability' => 'Doctor Availability',
			'workingDays' => 'Working Days',
			'daysEnabled' => ({required Object count}) => '${count} days enabled',
			'workingHours' => 'Working Hours',
			'startTime' => 'Start Time',
			'endTime' => 'End Time',
			'slotDuration' => 'Slot Duration',
			'minutesDuration' => ({required Object count}) => '${count} min',
			'errorSelectAtLeastOneDay' => 'Please select at least one working day',
			'errorStartMustBeBeforeEnd' => 'Start time must be before end time',
			'errorSlotDurationTooLong' => 'Slot duration cannot exceed working hours',
			'availabilityUpdatedSuccess' => 'Availability updated successfully',
			'saveAvailability' => 'Save Availability',
			'adminProfile' => 'Admin Profile',
			'adminProfileSubtitle' => 'Edit your details & clinic location',
			'saveChanges' => 'Save Changes',
			'clinicAddressAr' => 'Clinic Address (Arabic)',
			'clinicAddressEn' => 'Clinic Address (English)',
			'clinicLocation' => 'Clinic Location',
			'tapMapToSetLocation' => 'Tap anywhere on the map to set clinic location pin',
			'clinicAddressArRequired' => 'Please enter clinic address in Arabic',
			'clinicAddressEnRequired' => 'Please enter clinic address in English',
			'clinicLocationRequired' => 'Please select clinic location on the map',
			'emailVerificationSent' => ({required Object email}) => 'Verification email sent to ${email}',
			'requiresRecentLogin' => 'Please re-login before updating your email',
			'adminProfileUpdatedSuccess' => 'Admin profile and clinic updated successfully',
			'patientNameLabel' => ({required Object name}) => 'Patient: ${name}',
			'doctorWithNameLabel' => ({required Object name}) => 'Doctor: ${name}',
			'markCompleted' => 'Mark as Completed',
			'markCompletedTitle' => 'Mark Appointment Completed',
			'markCompletedMessage' => 'Are you sure you want to mark this appointment as completed?',
			'appointmentMarkedCompletedSuccess' => 'Appointment marked as completed successfully',
			'patientInfo' => 'Patient Information',
			'patientName' => 'Patient Name',
			'patientPhone' => 'Phone Number',
			'patientEmail' => 'Email',
			'cancelledByPatient' => 'Cancelled by patient',
			'cancelledByAdmin' => 'Cancelled by admin',
			'buildVersion' => 'Build version',
			'versionValue' => 'v1.0.0',
			'privacyPolicyTitle' => 'Doctor Hunt Apps Privacy Policy',
			'privacyPolicyIntro' => 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words believable. It is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more',
			'privacyPolicyBullet1' => 'The standard chunk of lorem Ipsum used since 1500s is reproduced below for those interested.',
			'privacyPolicyBullet2' => 'Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum". The point of using.',
			'privacyPolicyBullet3' => 'Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted.',
			'privacyPolicyBullet4' => 'The point of using Lorem Ipsum is that it has a moreIt is a long established fact that reader will distracted.',
			'privacyPolicyOutro' => 'It is a long established fact that reader distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a moreIt is a long established.',
			'loadingEllipsis' => '...',
			'doctorNameArLabel' => 'Doctor Name (AR)',
			'doctorNameEnLabel' => 'Doctor Name (EN)',
			'doctorAvailabilitySubtitle' => 'Set weekly working days, hours and appointment duration',
			'slotsPerDay' => ({required Object count}) => '${count} slots per day',
			'perSlot' => ({required Object duration}) => '${duration} / slot',
			_ => null,
		};
	}
}
