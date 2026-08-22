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
	@override String get forgotPasswordSubtitle => 'أدخل بريدك الإلكتروني وسنرسل لك رمزًا من 4 أرقام للتحقق من حسابك.';
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
	@override String get otpSentTo => 'أرسلنا رمزًا من 4 أرقام إلى ';
	@override String get defaultPhoneNumber => '+20 10 1234 5678';
	@override String get resendTimerDefault => '0:42';
	@override String get resendCode => 'إعادة إرسال الرمز';
	@override String get codeSentAgain => 'تم إرسال رمز جديد.';
	@override String get otpCodeTitle => 'أدخل الرمز المكون من 4 أرقام';
	@override String get otpCodeDescription => 'أدخل الرمز المكون من 4 أرقام الذي وصلك على بريدك الإلكتروني.';
	@override String get resetYourPassword => 'إعادة تعيين كلمة المرور';
	@override String get resetPasswordSubtitle => 'أدخل بريدك الإلكتروني وسنرسل لك\nرابطًا آمنًا لإعادة التعيين.';
	@override String get sendResetLink => 'إرسال رابط إعادة التعيين';
	@override String get rememberedPassword => 'تذكرت كلمة المرور؟';
	@override String get passwordResetSuccess => 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.';
	@override String get roleSelectionTitle => 'اختر دورك';
	@override String get roleSelectionSubtitle => 'يحدد الدور المختار التجربة والميزات\nالمتاحة لك.';
	@override String get patientRoleTitle => 'مريض';
	@override String get patientRoleDescription => 'اعثر على الأطباء، واحجز المواعيد، وأدر سجلك الطبي.';
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
			'forgotPasswordSubtitle' => 'أدخل بريدك الإلكتروني وسنرسل لك رمزًا من 4 أرقام للتحقق من حسابك.',
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
			'otpSentTo' => 'أرسلنا رمزًا من 4 أرقام إلى ',
			'defaultPhoneNumber' => '+20 10 1234 5678',
			'resendTimerDefault' => '0:42',
			'resendCode' => 'إعادة إرسال الرمز',
			'codeSentAgain' => 'تم إرسال رمز جديد.',
			'otpCodeTitle' => 'أدخل الرمز المكون من 4 أرقام',
			'otpCodeDescription' => 'أدخل الرمز المكون من 4 أرقام الذي وصلك على بريدك الإلكتروني.',
			'resetYourPassword' => 'إعادة تعيين كلمة المرور',
			'resetPasswordSubtitle' => 'أدخل بريدك الإلكتروني وسنرسل لك\nرابطًا آمنًا لإعادة التعيين.',
			'sendResetLink' => 'إرسال رابط إعادة التعيين',
			'rememberedPassword' => 'تذكرت كلمة المرور؟',
			'passwordResetSuccess' => 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
			'roleSelectionTitle' => 'اختر دورك',
			'roleSelectionSubtitle' => 'يحدد الدور المختار التجربة والميزات\nالمتاحة لك.',
			'patientRoleTitle' => 'مريض',
			'patientRoleDescription' => 'اعثر على الأطباء، واحجز المواعيد، وأدر سجلك الطبي.',
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
			_ => null,
		};
	}
}
