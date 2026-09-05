///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsAr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'دكتور هانت';
	@override String get skip => 'تخطي';
	@override String get continueText => 'متابعة';
	@override String get getStarted => 'ابدأ الآن';
	@override String get next => 'التالي';
	@override String get back => 'رجوع';
	@override String get or => 'أو';
	@override String get arabicLanguage => 'العربية';
	@override String get englishLanguage => 'English';
	@override String get onboardingTitle1 => 'اعثر على أطباء موثوقين';
	@override String get onboardingSubtitle1 => 'على عكس الاعتقاد الشائع، لوريم إيبسوم ليس نصًا عشوائيًا، بل يعود إلى أكثر من 2000 عام.';
	@override String get onboardingTitle2 => 'اختر أفضل الأطباء';
	@override String get onboardingSubtitle2 => 'على عكس الاعتقاد الشائع، لوريم إيبسوم ليس نصًا عشوائيًا، بل يعود إلى أكثر من 2000 عام.';
	@override String get onboardingTitle3 => 'مواعيد سهلة';
	@override String get onboardingSubtitle3 => 'على عكس الاعتقاد الشائع، لوريم إيبسوم ليس نصًا عشوائيًا، بل يعود إلى أكثر من 2000 عام.';
	@override String get emailAddress => 'البريد الإلكتروني';
	@override String get emailHint => 'wpos/36@gmail.com';
	@override String get password => 'كلمة المرور';
	@override String get passwordHint => '••••••••••••';
	@override String get enterPasswordHint => '••••••••••••';
	@override String get fullName => 'الاسم';
	@override String get fullNameHint => 'الاسم';
	@override String get signIn => 'تسجيل الدخول';
	@override String get logIn => 'دخول';
	@override String get createAccount => 'إنشاء حساب';
	@override String get google => 'Google';
	@override String get facebook => 'Facebook';
	@override String get showPassword => 'إظهار كلمة المرور';
	@override String get hidePassword => 'إخفاء كلمة المرور';
	@override String get welcomeBack => 'مرحبًا بعودتك';
	@override String get loginSubtitle => 'احجز مع أفضل طبيب لصحتك\nوعش حياتك بكل سعادة';
	@override String get forgotPassword => 'نسيت كلمة المرور';
	@override String get forgotPasswordSubtitle => 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';
	@override String get dontHaveAccount => 'ليس لديك حساب؟ ';
	@override String get joinUs => 'انضم إلينا';
	@override String get createYourAccount => 'انضم إلينا وابدأ البحث';
	@override String get signupSubtitle => 'اعثر على أطباء موثوقين، واحجز المواعيد، وأدر رعايتك الصحية.';
	@override String get passwordLengthNotice => '8 أحرف على الأقل';
	@override String get agreeTermsPrefix => 'أوافق على ';
	@override String get termsOfService => 'شروط الخدمة';
	@override String get andText => ' و';
	@override String get privacyPolicy => 'سياسة الخصوصية';
	@override String get alreadyHaveAccount => 'لديك حساب بالفعل؟';
	@override String get verifyYourNumber => 'تحقق من رقمك';
	@override String get otpSentTo => 'أرسلنا رمزًا من 6 أرقام إلى ';
	@override String get defaultPhoneNumber => '+20 10 1234 5678';
	@override String get resendTimerDefault => '0:60';
	@override String get resendCode => 'إعادة إرسال الرمز';
	@override String get codeSentAgain => 'تم إرسال رمز جديد.';
	@override String get otpCodeTitle => 'أدخل الرمز المكون من 6 أرقام';
	@override String get otpCodeDescription => 'أدخل الرمز المكون من 6 أرقام الذي وصلك على هاتفك.';
	@override String get resetYourPassword => 'إعادة تعيين كلمة المرور';
	@override String get resetPasswordSubtitle => 'أدخل بريدك الإلكتروني وسنرسل لك\nرابطًا آمنًا لإعادة التعيين.';
	@override String get sendResetLink => 'إرسال رابط إعادة التعيين';
	@override String get rememberedPassword => 'تذكرت كلمة المرور؟';
	@override String get passwordResetSuccess => 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.';
	@override String get roleSelectionTitle => 'اختر دورك';
	@override String get roleSelectionSubtitle => 'يحدد الدور المختار التجربة والميزات\nالمتاحة لك.';
	@override String get patientRoleTitle => 'مريض';
	@override String get patientRoleDescription => 'اعثر على الأطباء، واحجز المواعيد، وأدر سجلك الطبي.';
	@override String get doctorRoleTitle => 'طبيب';
	@override String get doctorRoleDescription => 'إدارة المواعيد والتواصل مع المرضى.';
	@override String get adminRoleTitle => 'مسؤول';
	@override String get adminRoleDescription => 'إدارة الأطباء والمواعيد والمستخدمين والمنصة.';
	@override String get enterFullName => 'أدخل اسمك بالكامل';
	@override String get enterEmailAddress => 'أدخل بريدك الإلكتروني';
	@override String get enterValidEmailAddress => 'أدخل بريدًا إلكترونيًا صحيحًا';
	@override String get enterPassword => 'أدخل كلمة المرور';
	@override String get useAtLeast8Characters => 'استخدم 8 أحرف على الأقل';
	@override String get hiSteven => 'مرحبًا سما 👋';
	@override String get findYourDoctor => 'اعثر على طبيبك';
	@override String get searchDoctorHint => 'ابحث.... ';
	@override String get live => 'مباشر';
	@override String get liveDoctor => 'طبيب مباشر';
	@override String get seeAll => 'عرض الكل';
	@override String get popularDoctor => 'الأطباء الأكثر شعبية';
	@override String get featuredDoctor => 'أطباء مميزون';
	@override String get dental => 'أسنان';
	@override String get cardiology => 'قلب';
	@override String get eyeCare => 'رعاية العيون';
	@override String get nutrition => 'تغذية';
	@override String get pediatric => 'أطفال';
	@override String get neurology => 'أعصاب';
	@override String get medicineSpecialist => 'أخصائي طب عام';
	@override String get dentalSpecialist => 'أخصائي أسنان';
	@override String get heartSpecialist => 'أخصائي قلب';
	@override String get eyeSpecialist => 'أخصائي عيون';
	@override String get generalSurgeon => 'جراح عام';
	@override String get perHour => '/ساعة';
	@override String get reviews => 'تقييمات';
	@override String get findDoctors => 'اعثر على أطباء';
	@override String get searchDentistHint => 'طبيب أسنان';
	@override String get dentist => 'طبيب أسنان';
	@override String get yearsExperienceSuffix => 'سنوات خبرة';
	@override String get patientStories => 'قصص المرضى';
	@override String get nextAvailable => 'الموعد القادم';
	@override String get bookNow => 'احجز الآن';
	@override String get noDoctorsFound => 'لم يتم العثور على أطباء';
	@override String get bookingComingSoon => 'الحجز غير متاح حاليًا.';
	@override String get comingSoon => 'قريباً';
	@override String bookingMessage({required Object name}) => 'حجز موعد مع ${name}...';
	@override String get tomorrow => 'غدًا';
	@override String get liveCardiologist => 'طبيب قلب';
	@override String get liveDentist => 'طبيب أسنان';
	@override String get livePediatrician => 'طبيب أطفال';
	@override String get liveNeurologist => 'طبيب أعصاب';
	@override String get serviceOne => 'رعاية المريض يجب أن تكون الأولوية الأولى.';
	@override String get serviceTwo => 'إذا كنت تدير عيادتك فأنت تعرف مدى الإحباط.';
	@override String get serviceThree => 'لهذا السبب نستخدم نظامًا لتذكير المواعيد.';
	@override String get doctorDetails => 'تفاصيل الطبيب';
	@override String get services => 'الخدمات';
	@override String get statRunning => 'جارية';
	@override String get statOngoing => 'مستمرة';
	@override String get statPatient => 'مريض';
	@override String get profile => 'الملف الشخصي';
	@override String get setUpYourProfile => 'إعداد ملفك الشخصي';
	@override String get profileHeaderSubtitle => 'قم بتحديث ملفك الشخصي للتواصل مع طبيبك\nبشكل أفضل.';
	@override String get personalInformation => 'المعلومات الشخصية';
	@override String get contactNumber => 'رقم الهاتف';
	@override String get dateOfBirth => 'تاريخ الميلاد';
	@override String get dateOfBirthPlaceholder => 'يوم شهر سنة';
	@override String get location => 'الموقع';
	@override String get addDetails => 'إضافة تفاصيل';
	@override String get settings => 'الإعدادات';
	@override String get language => 'اللغة';
	@override String get profileUpdatedSuccess => 'تم تحديث الملف الشخصي بنجاح';
	@override String get logOut => 'تسجيل الخروج';
	@override String get favouriteDoctors => 'الأطباء المفضلون';
	@override String get favouriteDoctorsSubtitle => 'أطباؤك المفضلون والموثوقون لسهولة الوصول إليهم';
	@override String get featureDoctor => 'أطباء مميزون';
	@override String get selectTime => 'اختيار الموعد';
	@override String get selectDate => 'اختر التاريخ';
	@override String get today => 'اليوم';
	@override String get dateOptionToday => 'اليوم، 23 فبراير';
	@override String get dateOptionTomorrow => 'غداً، 24 فبراير';
	@override String get dateOptionThu => 'الخميس، 25 فبراير';
	@override String get dateOptionFri => 'الجمعة، 26 فبراير';
	@override String get dateOptionSat => 'السبت، 27 فبراير';
	@override String get dateOptionSun => 'الأحد، 28 فبراير';
	@override String get noSlotsAvailable => 'لا توجد مواعيد متاحة';
	@override String nextAvailabilityOn({required Object date}) => 'الموعد التالي المتاح في ${date}';
	@override String get contactClinic => 'الاتصال بالعيادة';
	@override String get contactingClinic => 'جارٍ الاتصال بالعيادة...';
	@override String slotsAvailable({required Object count}) => '${count} مواعيد متاحة';
	@override String slotsCount({required Object count}) => '${count} مواعيد';
	@override String get afternoonSlots => 'فترة بعد الظهر';
	@override String get eveningSlots => 'الفترة المسائية';
	@override String get morningSlots => 'الفترة الصباحية';
	@override String get reminder => 'تذكير';
	@override String get reminderDescription => 'تذكيري قبل الموعد بـ 15 دقيقة';
	@override String get bookAppointment => 'حجز الموعد';
	@override String appointmentBookedSuccess({required Object name, required Object date, required Object time}) => 'تم حجز الموعد بنجاح مع ${name} في يوم ${date} الساعة ${time}';
	@override String get viewDetails => 'عرض التفاصيل';
	@override String get confirm => 'تأكيد';
	@override String get thankYou => 'شكراً لك !';
	@override String get appointmentSuccessful => 'تم حجز موعدك بنجاح';
	@override String appointmentBookedWith({required Object name, required Object date, required Object time}) => 'لقد قمت بحجز موعد مع ${name} في ${date}، الساعة ${time}';
	@override String get done => 'تم';
	@override String get editYourAppointment => 'تعديل الموعد';
	@override String get userNotFoundError => 'هذا البريد الإلكتروني غير مسجل لدينا، يرجى التأكد من صحة البريد أو إنشاء حساب جديد.';
	@override String get wrongPasswordError => 'بيانات تسجيل الدخول غير صحيحة، يرجى المحاولة مرة أخرى.';
	@override String get emailAlreadyInUseError => 'هذا البريد الإلكتروني مستخدم بالفعل بحساب آخر.';
	@override String get invalidEmailError => 'البريد الإلكتروني غير صالح.';
	@override String get weakPasswordError => 'كلمة المرور ضعيفة جدًا، يرجى اختيار كلمة مرور أقوى.';
	@override String get userDisabledError => 'تم تعطيل هذا الحساب، يرجى التواصل مع الدعم.';
	@override String get tooManyRequestsError => 'تم حظر المحاولات مؤقتًا لكثرة الطلبات، يرجى المحاولة لاحقًا.';
	@override String get networkRequestFailedError => 'تعذر الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت.';
	@override String get accountExistsWithDifferentCredentialError => 'يوجد حساب مسجل بالفعل ببيانات اعتماد مختلفة.';
	@override String get operationNotAllowedError => 'طريقة تسجيل الدخول هذه غير مفعلة حاليًا.';
	@override String get invalidVerificationCodeError => 'رمز التحقق (OTP) غير صحيح، يرجى المحاولة مرة أخرى.';
	@override String get invalidVerificationIdError => 'معرف التحقق غير صالح، يرجى إعادة إرسال الرمز.';
	@override String get sessionExpiredError => 'انتهت صلاحية رمز التحقق، يرجى طلب رمز جديد.';
	@override String get invalidPhoneNumberError => 'رقم الهاتف غير صالح، يرجى التأكد من كتابة الرقم مع رمز الدولة (مثال: +20...).';
	@override String get quotaExceededError => 'تم تجاوز الحد المسموح لإرسال الرسائل، يرجى المحاولة لاحقًا.';
	@override String get captchaCheckFailedError => 'فشل التحقق الأمني (reCAPTCHA)، يرجى المحاولة لاحقاً.';
	@override String get serviceError => 'حدث خطأ في الخدمة، يرجى المحاولة لاحقاً.';
	@override String get unexpectedError => 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.';
	@override String get googleSignInConfigError => 'خطأ في إعدادات Google Sign-In، يرجى التأكد من الـ SHA-1 و serverClientId.';
	@override String get googleSignInInterruptedError => 'تمت مقاطعة عملية تسجيل الدخول، يرجى المحاولة ثانية.';
	@override String get googleSignInFailedError => 'فشل تسجيل الدخول عبر Google.';
	@override String get enterSixDigitOtp => 'يرجى إدخال رمز التحقق المكون من 6 أرقام.';
	@override String get phoneVerifiedSuccess => 'تم تأكيد رقم الهاتف بنجاح!';
	@override String get adminLoginTitle => 'مرحبًا بعودتك!';
	@override String get adminLoginSubtitle => 'سجّل الدخول إلى حساب المسؤول';
	@override String get adminEmailHint => 'admin@doctorhunt.com';
	@override String get secureAdminAccessOnly => 'وصول آمن للمسؤولين فقط';
	@override String get doctorsTitle => 'الأطباء';
	@override String get totalDoctors => 'إجمالي الأطباء';
	@override String get activeLabel => 'نشط';
	@override String get inactiveLabel => 'غير نشط';
	@override String get addDoctor => 'إضافة طبيب';
	@override String get searchAdminDoctorsHint => 'ابحث عن أطباء...';
	@override String get noDoctorsYet => 'لا يوجد أطباء بعد. اضغط على إضافة طبيب لإنشاء واحد.';
	@override String get createDoctorTitle => 'إضافة طبيب جديد';
	@override String get doctorNameLabel => 'اسم الطبيب';
	@override String get doctorNameHint => 'أدخل اسم الطبيب';
	@override String get specialtyLabel => 'التخصص';
	@override String get selectSpecialtyHint => 'اختر التخصص';
	@override String get doctorImageLabel => 'صورة الطبيب';
	@override String get uploadDoctorImageTitle => 'رفع صورة الطبيب';
	@override String get tapToPickImage => 'اضغط لاختيار صورة';
	@override String get createDoctorButton => 'إنشاء طبيب';
	@override String get doctorCreatedSuccess => 'تم إنشاء الطبيب بنجاح';
	@override String get enterDoctorName => 'يرجى إدخال اسم الطبيب';
	@override String get selectSpecialtyError => 'يرجى اختيار التخصص';
	@override String get pickImageError => 'فشل اختيار الصورة، يرجى المحاولة مرة أخرى.';
	@override String get uploadImageError => 'فشل رفع الصورة، يرجى المحاولة مرة أخرى.';
	@override String get specialtyCardiologist => 'طبيب قلب';
	@override String get specialtyOrthopedic => 'طبيب عظام';
	@override String get specialtyDentist => 'طبيب أسنان';
	@override String get specialtyPediatrician => 'طبيب أطفال';
	@override String get specialtyDermatologist => 'طبيب جلدية';
	@override String get specialtyNeurologist => 'طبيب أعصاب';
	@override String get specialtyEyeSpecialist => 'طبيب عيون';
	@override String get specialtyMedicineSpecialist => 'أخصائي طب عام';
	@override String get specialtyGeneralSurgeon => 'جراح عام';
	@override String get edit => 'تعديل';
	@override String get delete => 'حذف';
	@override String get cancel => 'إلغاء';
	@override String get editDoctorTitle => 'تعديل بيانات الطبيب';
	@override String get updateDoctorButton => 'تحديث الطبيب';
	@override String get doctorUpdatedSuccess => 'تم تحديث بيانات الطبيب بنجاح';
	@override String get deleteDoctorTitle => 'حذف الطبيب';
	@override String get deleteDoctorConfirm => 'هل أنت متأكد من رغبتك في حذف هذا الطبيب؟';
	@override String get doctorDeletedSuccess => 'تم حذف الطبيب بنجاح';
	@override String get changeImage => 'تغيير الصورة';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'دكتور هانت',
			'skip' => 'تخطي',
			'continueText' => 'متابعة',
			'getStarted' => 'ابدأ الآن',
			'next' => 'التالي',
			'back' => 'رجوع',
			'or' => 'أو',
			'arabicLanguage' => 'العربية',
			'englishLanguage' => 'English',
			'onboardingTitle1' => 'اعثر على أطباء موثوقين',
			'onboardingSubtitle1' => 'على عكس الاعتقاد الشائع، لوريم إيبسوم ليس نصًا عشوائيًا، بل يعود إلى أكثر من 2000 عام.',
			'onboardingTitle2' => 'اختر أفضل الأطباء',
			'onboardingSubtitle2' => 'على عكس الاعتقاد الشائع، لوريم إيبسوم ليس نصًا عشوائيًا، بل يعود إلى أكثر من 2000 عام.',
			'onboardingTitle3' => 'مواعيد سهلة',
			'onboardingSubtitle3' => 'على عكس الاعتقاد الشائع، لوريم إيبسوم ليس نصًا عشوائيًا، بل يعود إلى أكثر من 2000 عام.',
			'emailAddress' => 'البريد الإلكتروني',
			'emailHint' => 'wpos/36@gmail.com',
			'password' => 'كلمة المرور',
			'passwordHint' => '••••••••••••',
			'enterPasswordHint' => '••••••••••••',
			'fullName' => 'الاسم',
			'fullNameHint' => 'الاسم',
			'signIn' => 'تسجيل الدخول',
			'logIn' => 'دخول',
			'createAccount' => 'إنشاء حساب',
			'google' => 'Google',
			'facebook' => 'Facebook',
			'showPassword' => 'إظهار كلمة المرور',
			'hidePassword' => 'إخفاء كلمة المرور',
			'welcomeBack' => 'مرحبًا بعودتك',
			'loginSubtitle' => 'احجز مع أفضل طبيب لصحتك\nوعش حياتك بكل سعادة',
			'forgotPassword' => 'نسيت كلمة المرور',
			'forgotPasswordSubtitle' => 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.',
			'dontHaveAccount' => 'ليس لديك حساب؟ ',
			'joinUs' => 'انضم إلينا',
			'createYourAccount' => 'انضم إلينا وابدأ البحث',
			'signupSubtitle' => 'اعثر على أطباء موثوقين، واحجز المواعيد، وأدر رعايتك الصحية.',
			'passwordLengthNotice' => '8 أحرف على الأقل',
			'agreeTermsPrefix' => 'أوافق على ',
			'termsOfService' => 'شروط الخدمة',
			'andText' => ' و',
			'privacyPolicy' => 'سياسة الخصوصية',
			'alreadyHaveAccount' => 'لديك حساب بالفعل؟',
			'verifyYourNumber' => 'تحقق من رقمك',
			'otpSentTo' => 'أرسلنا رمزًا من 6 أرقام إلى ',
			'defaultPhoneNumber' => '+20 10 1234 5678',
			'resendTimerDefault' => '0:60',
			'resendCode' => 'إعادة إرسال الرمز',
			'codeSentAgain' => 'تم إرسال رمز جديد.',
			'otpCodeTitle' => 'أدخل الرمز المكون من 6 أرقام',
			'otpCodeDescription' => 'أدخل الرمز المكون من 6 أرقام الذي وصلك على هاتفك.',
			'resetYourPassword' => 'إعادة تعيين كلمة المرور',
			'resetPasswordSubtitle' => 'أدخل بريدك الإلكتروني وسنرسل لك\nرابطًا آمنًا لإعادة التعيين.',
			'sendResetLink' => 'إرسال رابط إعادة التعيين',
			'rememberedPassword' => 'تذكرت كلمة المرور؟',
			'passwordResetSuccess' => 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
			'roleSelectionTitle' => 'اختر دورك',
			'roleSelectionSubtitle' => 'يحدد الدور المختار التجربة والميزات\nالمتاحة لك.',
			'patientRoleTitle' => 'مريض',
			'patientRoleDescription' => 'اعثر على الأطباء، واحجز المواعيد، وأدر سجلك الطبي.',
			'doctorRoleTitle' => 'طبيب',
			'doctorRoleDescription' => 'إدارة المواعيد والتواصل مع المرضى.',
			'adminRoleTitle' => 'مسؤول',
			'adminRoleDescription' => 'إدارة الأطباء والمواعيد والمستخدمين والمنصة.',
			'enterFullName' => 'أدخل اسمك بالكامل',
			'enterEmailAddress' => 'أدخل بريدك الإلكتروني',
			'enterValidEmailAddress' => 'أدخل بريدًا إلكترونيًا صحيحًا',
			'enterPassword' => 'أدخل كلمة المرور',
			'useAtLeast8Characters' => 'استخدم 8 أحرف على الأقل',
			'hiSteven' => 'مرحبًا سما 👋',
			'findYourDoctor' => 'اعثر على طبيبك',
			'searchDoctorHint' => 'ابحث.... ',
			'live' => 'مباشر',
			'liveDoctor' => 'طبيب مباشر',
			'seeAll' => 'عرض الكل',
			'popularDoctor' => 'الأطباء الأكثر شعبية',
			'featuredDoctor' => 'أطباء مميزون',
			'dental' => 'أسنان',
			'cardiology' => 'قلب',
			'eyeCare' => 'رعاية العيون',
			'nutrition' => 'تغذية',
			'pediatric' => 'أطفال',
			'neurology' => 'أعصاب',
			'medicineSpecialist' => 'أخصائي طب عام',
			'dentalSpecialist' => 'أخصائي أسنان',
			'heartSpecialist' => 'أخصائي قلب',
			'eyeSpecialist' => 'أخصائي عيون',
			'generalSurgeon' => 'جراح عام',
			'perHour' => '/ساعة',
			'reviews' => 'تقييمات',
			'findDoctors' => 'اعثر على أطباء',
			'searchDentistHint' => 'طبيب أسنان',
			'dentist' => 'طبيب أسنان',
			'yearsExperienceSuffix' => 'سنوات خبرة',
			'patientStories' => 'قصص المرضى',
			'nextAvailable' => 'الموعد القادم',
			'bookNow' => 'احجز الآن',
			'noDoctorsFound' => 'لم يتم العثور على أطباء',
			'bookingComingSoon' => 'الحجز غير متاح حاليًا.',
			'comingSoon' => 'قريباً',
			'bookingMessage' => ({required Object name}) => 'حجز موعد مع ${name}...',
			'tomorrow' => 'غدًا',
			'liveCardiologist' => 'طبيب قلب',
			'liveDentist' => 'طبيب أسنان',
			'livePediatrician' => 'طبيب أطفال',
			'liveNeurologist' => 'طبيب أعصاب',
			'serviceOne' => 'رعاية المريض يجب أن تكون الأولوية الأولى.',
			'serviceTwo' => 'إذا كنت تدير عيادتك فأنت تعرف مدى الإحباط.',
			'serviceThree' => 'لهذا السبب نستخدم نظامًا لتذكير المواعيد.',
			'doctorDetails' => 'تفاصيل الطبيب',
			'services' => 'الخدمات',
			'statRunning' => 'جارية',
			'statOngoing' => 'مستمرة',
			'statPatient' => 'مريض',
			'profile' => 'الملف الشخصي',
			'setUpYourProfile' => 'إعداد ملفك الشخصي',
			'profileHeaderSubtitle' => 'قم بتحديث ملفك الشخصي للتواصل مع طبيبك\nبشكل أفضل.',
			'personalInformation' => 'المعلومات الشخصية',
			'contactNumber' => 'رقم الهاتف',
			'dateOfBirth' => 'تاريخ الميلاد',
			'dateOfBirthPlaceholder' => 'يوم شهر سنة',
			'location' => 'الموقع',
			'addDetails' => 'إضافة تفاصيل',
			'settings' => 'الإعدادات',
			'language' => 'اللغة',
			'profileUpdatedSuccess' => 'تم تحديث الملف الشخصي بنجاح',
			'logOut' => 'تسجيل الخروج',
			'favouriteDoctors' => 'الأطباء المفضلون',
			'favouriteDoctorsSubtitle' => 'أطباؤك المفضلون والموثوقون لسهولة الوصول إليهم',
			'featureDoctor' => 'أطباء مميزون',
			'selectTime' => 'اختيار الموعد',
			'selectDate' => 'اختر التاريخ',
			'today' => 'اليوم',
			'dateOptionToday' => 'اليوم، 23 فبراير',
			'dateOptionTomorrow' => 'غداً، 24 فبراير',
			'dateOptionThu' => 'الخميس، 25 فبراير',
			'dateOptionFri' => 'الجمعة، 26 فبراير',
			'dateOptionSat' => 'السبت، 27 فبراير',
			'dateOptionSun' => 'الأحد، 28 فبراير',
			'noSlotsAvailable' => 'لا توجد مواعيد متاحة',
			'nextAvailabilityOn' => ({required Object date}) => 'الموعد التالي المتاح في ${date}',
			'contactClinic' => 'الاتصال بالعيادة',
			'contactingClinic' => 'جارٍ الاتصال بالعيادة...',
			'slotsAvailable' => ({required Object count}) => '${count} مواعيد متاحة',
			'slotsCount' => ({required Object count}) => '${count} مواعيد',
			'afternoonSlots' => 'فترة بعد الظهر',
			'eveningSlots' => 'الفترة المسائية',
			'morningSlots' => 'الفترة الصباحية',
			'reminder' => 'تذكير',
			'reminderDescription' => 'تذكيري قبل الموعد بـ 15 دقيقة',
			'bookAppointment' => 'حجز الموعد',
			'appointmentBookedSuccess' => ({required Object name, required Object date, required Object time}) => 'تم حجز الموعد بنجاح مع ${name} في يوم ${date} الساعة ${time}',
			'viewDetails' => 'عرض التفاصيل',
			'confirm' => 'تأكيد',
			'thankYou' => 'شكراً لك !',
			'appointmentSuccessful' => 'تم حجز موعدك بنجاح',
			'appointmentBookedWith' => ({required Object name, required Object date, required Object time}) => 'لقد قمت بحجز موعد مع ${name} في ${date}، الساعة ${time}',
			'done' => 'تم',
			'editYourAppointment' => 'تعديل الموعد',
			'userNotFoundError' => 'هذا البريد الإلكتروني غير مسجل لدينا، يرجى التأكد من صحة البريد أو إنشاء حساب جديد.',
			'wrongPasswordError' => 'بيانات تسجيل الدخول غير صحيحة، يرجى المحاولة مرة أخرى.',
			'emailAlreadyInUseError' => 'هذا البريد الإلكتروني مستخدم بالفعل بحساب آخر.',
			'invalidEmailError' => 'البريد الإلكتروني غير صالح.',
			'weakPasswordError' => 'كلمة المرور ضعيفة جدًا، يرجى اختيار كلمة مرور أقوى.',
			'userDisabledError' => 'تم تعطيل هذا الحساب، يرجى التواصل مع الدعم.',
			'tooManyRequestsError' => 'تم حظر المحاولات مؤقتًا لكثرة الطلبات، يرجى المحاولة لاحقًا.',
			'networkRequestFailedError' => 'تعذر الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت.',
			'accountExistsWithDifferentCredentialError' => 'يوجد حساب مسجل بالفعل ببيانات اعتماد مختلفة.',
			'operationNotAllowedError' => 'طريقة تسجيل الدخول هذه غير مفعلة حاليًا.',
			'invalidVerificationCodeError' => 'رمز التحقق (OTP) غير صحيح، يرجى المحاولة مرة أخرى.',
			'invalidVerificationIdError' => 'معرف التحقق غير صالح، يرجى إعادة إرسال الرمز.',
			'sessionExpiredError' => 'انتهت صلاحية رمز التحقق، يرجى طلب رمز جديد.',
			'invalidPhoneNumberError' => 'رقم الهاتف غير صالح، يرجى التأكد من كتابة الرقم مع رمز الدولة (مثال: +20...).',
			'quotaExceededError' => 'تم تجاوز الحد المسموح لإرسال الرسائل، يرجى المحاولة لاحقًا.',
			'captchaCheckFailedError' => 'فشل التحقق الأمني (reCAPTCHA)، يرجى المحاولة لاحقاً.',
			'serviceError' => 'حدث خطأ في الخدمة، يرجى المحاولة لاحقاً.',
			'unexpectedError' => 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.',
			'googleSignInConfigError' => 'خطأ في إعدادات Google Sign-In، يرجى التأكد من الـ SHA-1 و serverClientId.',
			'googleSignInInterruptedError' => 'تمت مقاطعة عملية تسجيل الدخول، يرجى المحاولة ثانية.',
			'googleSignInFailedError' => 'فشل تسجيل الدخول عبر Google.',
			'enterSixDigitOtp' => 'يرجى إدخال رمز التحقق المكون من 6 أرقام.',
			'phoneVerifiedSuccess' => 'تم تأكيد رقم الهاتف بنجاح!',
			'adminLoginTitle' => 'مرحبًا بعودتك!',
			'adminLoginSubtitle' => 'سجّل الدخول إلى حساب المسؤول',
			'adminEmailHint' => 'admin@doctorhunt.com',
			'secureAdminAccessOnly' => 'وصول آمن للمسؤولين فقط',
			'doctorsTitle' => 'الأطباء',
			'totalDoctors' => 'إجمالي الأطباء',
			'activeLabel' => 'نشط',
			'inactiveLabel' => 'غير نشط',
			'addDoctor' => 'إضافة طبيب',
			'searchAdminDoctorsHint' => 'ابحث عن أطباء...',
			'noDoctorsYet' => 'لا يوجد أطباء بعد. اضغط على إضافة طبيب لإنشاء واحد.',
			'createDoctorTitle' => 'إضافة طبيب جديد',
			'doctorNameLabel' => 'اسم الطبيب',
			'doctorNameHint' => 'أدخل اسم الطبيب',
			'specialtyLabel' => 'التخصص',
			'selectSpecialtyHint' => 'اختر التخصص',
			'doctorImageLabel' => 'صورة الطبيب',
			'uploadDoctorImageTitle' => 'رفع صورة الطبيب',
			'tapToPickImage' => 'اضغط لاختيار صورة',
			'createDoctorButton' => 'إنشاء طبيب',
			'doctorCreatedSuccess' => 'تم إنشاء الطبيب بنجاح',
			'enterDoctorName' => 'يرجى إدخال اسم الطبيب',
			'selectSpecialtyError' => 'يرجى اختيار التخصص',
			'pickImageError' => 'فشل اختيار الصورة، يرجى المحاولة مرة أخرى.',
			'uploadImageError' => 'فشل رفع الصورة، يرجى المحاولة مرة أخرى.',
			'specialtyCardiologist' => 'طبيب قلب',
			'specialtyOrthopedic' => 'طبيب عظام',
			'specialtyDentist' => 'طبيب أسنان',
			'specialtyPediatrician' => 'طبيب أطفال',
			'specialtyDermatologist' => 'طبيب جلدية',
			'specialtyNeurologist' => 'طبيب أعصاب',
			'specialtyEyeSpecialist' => 'طبيب عيون',
			'specialtyMedicineSpecialist' => 'أخصائي طب عام',
			'specialtyGeneralSurgeon' => 'جراح عام',
			'edit' => 'تعديل',
			'delete' => 'حذف',
			'cancel' => 'إلغاء',
			'editDoctorTitle' => 'تعديل بيانات الطبيب',
			'updateDoctorButton' => 'تحديث الطبيب',
			'doctorUpdatedSuccess' => 'تم تحديث بيانات الطبيب بنجاح',
			'deleteDoctorTitle' => 'حذف الطبيب',
			'deleteDoctorConfirm' => 'هل أنت متأكد من رغبتك في حذف هذا الطبيب؟',
			'doctorDeletedSuccess' => 'تم حذف الطبيب بنجاح',
			'changeImage' => 'تغيير الصورة',
			_ => null,
		};
	}
}
