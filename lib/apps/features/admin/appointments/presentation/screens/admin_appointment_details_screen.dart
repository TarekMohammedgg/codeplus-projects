import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/services/appointment_service.dart';
import 'package:doctor_hunt/apps/core/services/clinic_service.dart';
import 'package:doctor_hunt/apps/core/services/specialty_service.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_button.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/patient/appointments/presentation/widgets/appointment_status_chip.dart';
import 'package:doctor_hunt/apps/features/patient/doctor_details/presentation/widgets/clinic_location_map.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminAppointmentDetailsScreen extends StatefulWidget {
  const AdminAppointmentDetailsScreen({
    super.key,
    required this.appointment,
    this.clinicService,
    this.appointmentService,
    this.specialtyService,
  });

  final AppointmentModel appointment;
  final ClinicService? clinicService;
  final AppointmentService? appointmentService;
  final SpecialtyService? specialtyService;

  @override
  State<AdminAppointmentDetailsScreen> createState() =>
      _AdminAppointmentDetailsScreenState();
}

class _AdminAppointmentDetailsScreenState
    extends State<AdminAppointmentDetailsScreen> {
  ClinicService get _clinicService =>
      widget.clinicService ?? getIt<ClinicService>();
  AppointmentService get _appointmentService =>
      widget.appointmentService ?? getIt<AppointmentService>();
  SpecialtyService get _specialtyService =>
      widget.specialtyService ?? getIt<SpecialtyService>();

  late AppointmentModel _appointment;
  String? _specialtyName;
  bool _isCancelling = false;
  bool _isMarkingCompleted = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
    _loadSpecialty();
  }

  @override
  void didUpdateWidget(covariant AdminAppointmentDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appointment != widget.appointment) {
      _appointment = widget.appointment;
      _loadSpecialty();
    }
  }

  Future<void> _loadSpecialty() async {
    final specId = _appointment.specialtyId;
    if (specId != null && specId.isNotEmpty) {
      try {
        final specialties = await _specialtyService.fetchActiveSpecialties();
        final match = specialties.where((s) => s.id == specId).firstOrNull;
        if (match != null && mounted) {
          setState(() => _specialtyName = match.localizedName);
        }
      } catch (_) {}
    }
  }

  Future<void> _confirmMarkCompleted() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.tr.markCompletedTitle,
          style: context.semiBold16TextMain,
        ),
        content: Text(
          context.tr.markCompletedMessage,
          style: context.regular14TextSecondary,
        ),
        actions: [
          AppTextButton(
            label: context.tr.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            textStyle: context.medium14TextSecondary,
          ),
          AppTextButton(
            label: context.tr.confirm,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            foregroundColor: AppColors.primary,
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isMarkingCompleted = true);
      try {
        await _appointmentService.markCompleted(_appointment.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr.appointmentMarkedCompletedSuccess),
              backgroundColor: AppColors.primary,
            ),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            Navigator.of(context).maybePop();
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isMarkingCompleted = false);
          final appEx = AppException.from(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(appEx.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.tr.cancelAppointmentTitle,
          style: context.semiBold16TextMain,
        ),
        content: Text(
          context.tr.cancelAppointmentMessage,
          style: context.regular14TextSecondary,
        ),
        actions: [
          AppTextButton(
            label: context.tr.cancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            textStyle: context.medium14TextSecondary,
          ),
          AppTextButton(
            label: context.tr.confirm,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            foregroundColor: AppColors.error,
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isCancelling = true);
      try {
        await _appointmentService.cancel(
          _appointment,
          cancelledBy: CancelledBy.admin,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr.appointmentCancelledSuccess),
              backgroundColor: AppColors.primary,
            ),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            Navigator.of(context).maybePop();
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isCancelling = false);
          final appEx = AppException.from(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(appEx.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = LocaleSettings.currentLocale.languageCode;
    final formattedDate = DateFormat.yMMMd(locale).format(_appointment.startAt);
    final formattedTime = DateFormat.jm(locale).format(_appointment.startAt);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppIconButton.back(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          context.tr.appointmentDetails,
          style: context.bold18TextMain,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowCard,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: DoctorImage(
                              imageUrl: _appointment.doctorImageUrl,
                              fallback: const DoctorAvatarPlaceholder(
                                circle: false,
                              ),
                            ),
                          ),
                        ),
                        14.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _appointment.doctorName,
                                      style: context.semiBold16TextMain,
                                    ),
                                  ),
                                  8.horizontalSpace,
                                  AppointmentStatusChip(
                                    status: _appointment.status,
                                  ),
                                ],
                              ),
                              if (_specialtyName != null &&
                                  _specialtyName!.isNotEmpty) ...[
                                4.verticalSpace,
                                Text(
                                  _specialtyName!,
                                  style: context.regular12TextSecondary,
                                ),
                              ],
                              8.verticalSpace,
                              Text(
                                '\$${_appointment.fee.toStringAsFixed(0)}',
                                style: context.bold14Primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,

                  // Embedded Patient Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowCard,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            8.horizontalSpace,
                            Text(
                              context.tr.patientInfo,
                              style: context.bold16TextMain,
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        _DetailRow(
                          icon: Icons.badge_outlined,
                          label: context.tr.patientName,
                          value: _appointment.patientName,
                        ),
                        12.verticalSpace,
                        const Divider(height: 1, color: AppColors.outline),
                        12.verticalSpace,
                        _DetailRow(
                          icon: Icons.phone_outlined,
                          label: context.tr.patientPhone,
                          value: _appointment.patientPhone.isNotEmpty
                              ? _appointment.patientPhone
                              : '-',
                        ),
                        12.verticalSpace,
                        const Divider(height: 1, color: AppColors.outline),
                        12.verticalSpace,
                        _DetailRow(
                          icon: Icons.email_outlined,
                          label: context.tr.patientEmail,
                          value: _appointment.patientEmail.isNotEmpty
                              ? _appointment.patientEmail
                              : '-',
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,

                  // Booking Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowCard,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: context.tr.appointmentDate,
                          value: formattedDate,
                        ),
                        12.verticalSpace,
                        const Divider(height: 1, color: AppColors.outline),
                        12.verticalSpace,
                        _DetailRow(
                          icon: Icons.access_time_rounded,
                          label: context.tr.appointmentTime,
                          value: formattedTime,
                        ),
                        12.verticalSpace,
                        const Divider(height: 1, color: AppColors.outline),
                        12.verticalSpace,
                        _DetailRow(
                          icon: Icons.payments_outlined,
                          label: context.tr.consultationFee,
                          value: '\$${_appointment.fee.toStringAsFixed(0)}',
                          valueColor: AppColors.primary,
                        ),
                        if (_appointment.status ==
                            AppointmentStatus.cancelled) ...[
                          12.verticalSpace,
                          const Divider(height: 1, color: AppColors.outline),
                          12.verticalSpace,
                          _DetailRow(
                            icon: Icons.cancel_outlined,
                            label: context.tr.statusCancelled,
                            value:
                                _appointment.cancelledBy == CancelledBy.patient
                                ? context.tr.cancelledByPatient
                                : context.tr.cancelledByAdmin,
                            valueColor: AppColors.error,
                          ),
                        ],
                      ],
                    ),
                  ),
                  20.verticalSpace,

                  // Live Clinic Location Card
                  _LiveClinicLocationCard(
                    clinicStream: _clinicService.streamClinic(),
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),

          // Bottom Action (Upcoming only)
          if (_appointment.status == AppointmentStatus.upcoming)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppPrimaryButton(
                      key: const Key('admin_mark_completed_button'),
                      label: context.tr.markCompleted,
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: _isMarkingCompleted,
                      onPressed: (_isMarkingCompleted || _isCancelling)
                          ? null
                          : _confirmMarkCompleted,
                    ),
                    12.verticalSpace,
                    AppPrimaryButton.outlined(
                      key: const Key('admin_cancel_appointment_button'),
                      label: context.tr.cancelAppointment,
                      foregroundColor: AppColors.error,
                      borderColor: AppColors.error,
                      isLoading: _isCancelling,
                      onPressed: (_isMarkingCompleted || _isCancelling)
                          ? null
                          : _confirmCancel,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        10.horizontalSpace,
        Text(label, style: context.regular14TextSecondary),
        const Spacer(),
        Text(
          value,
          style: context.semiBold14TextMain.copyWith(
            color: valueColor ?? AppColors.textMain,
          ),
        ),
      ],
    );
  }
}

class _LiveClinicLocationCard extends StatelessWidget {
  const _LiveClinicLocationCard({required this.clinicStream});

  final Stream<ClinicModel?> clinicStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ClinicModel?>(
      stream: clinicStream,
      builder: (context, snapshot) {
        final clinic = snapshot.data;
        final address = clinic?.localizedAddress ?? '';
        final location = clinic?.location;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowCard,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  8.horizontalSpace,
                  Text(
                    context.tr.clinicLocation,
                    style: context.bold16TextMain,
                  ),
                ],
              ),
              12.verticalSpace,
              if (address.isEmpty && location == null)
                Text(
                  context.tr.clinicLocationNotSet,
                  style: context.regular14TextSecondary,
                )
              else ...[
                if (address.isNotEmpty) ...[
                  Text(address, style: context.regular14TextSecondary),
                  if (location != null) 12.verticalSpace,
                ],
                if (location != null) ClinicLocationMap(location: location),
              ],
            ],
          ),
        );
      },
    );
  }
}
