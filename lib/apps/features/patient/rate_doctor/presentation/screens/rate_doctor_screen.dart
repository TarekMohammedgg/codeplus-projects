import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/models/review_model.dart';
import 'package:doctor_hunt/apps/core/extensions/app_error_text.dart';
import 'package:doctor_hunt/apps/core/extensions/context_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/appointment_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/utils/formatters.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/apps/features/patient/rate_doctor/presentation/controller/cubit/rate_doctor_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class RateDoctorScreen extends StatefulWidget {
  const RateDoctorScreen({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  State<RateDoctorScreen> createState() => _RateDoctorScreenState();
}

class _RateDoctorScreenState extends State<RateDoctorScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final isAllowed =
        appointment.status == AppointmentStatus.completed &&
        !appointment.isReviewed;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: AppBackButton.leading(),
        centerTitle: true,
        title: Text(context.tr.rateDoctorTitle, style: context.bold18TextMain),
      ),
      body: BlocConsumer<RateDoctorCubit, RateDoctorState>(
        listener: (context, state) {
          if (state.status == RateDoctorStatus.success) {
            context.showSuccessSnackBar(context.tr.reviewAddedSuccess);
            Navigator.of(context).maybePop();
          } else if (state.status == RateDoctorStatus.failure &&
              state.error != null) {
            context.showErrorSnackBar(state.error!.localized(context.tr));
          }
        },
        builder: (context, state) {
          if (!isAllowed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 56,
                      color: AppColors.textSecondary,
                    ),
                    16.verticalSpace,
                    Text(
                      appointment.isReviewed
                          ? context.tr.alreadyReviewed
                          : context.tr.appointmentNotCompleted,
                      style: context.semiBold16TextMain,
                      textAlign: TextAlign.center,
                    ),
                    24.verticalSpace,
                    AppPrimaryButton(
                      label: context.tr.confirm,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
            );
          }

          final cubit = context.read<RateDoctorCubit>();
          final formattedDate = formatDate(
            appointment.startAt,
            context.localeCode,
          );
          final formattedTime = formatTime(
            appointment.startAt,
            context.localeCode,
          );

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: AppCard(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 64,
                                    height: 64,
                                    child: DoctorImage(
                                      imageUrl: appointment.doctorImageUrl,
                                      fallback: const DoctorAvatarPlaceholder(
                                        circle: false,
                                      ),
                                    ),
                                  ),
                                ),
                                16.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.doctorName,
                                        style: context.semiBold16TextMain,
                                      ),
                                      if (state.specialtyName != null &&
                                          state.specialtyName!.isNotEmpty) ...[
                                        4.verticalSpace,
                                        Text(
                                          state.specialtyName!,
                                          style: context.regular12TextSecondary,
                                        ),
                                      ],
                                      6.verticalSpace,
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.event_available_rounded,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                          4.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              '$formattedDate · $formattedTime',
                                              style: context
                                                  .regular12TextSecondary,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        28.verticalSpace,

                        Text(
                          context.tr.ratingDoctorSubtitle,
                          style: context.medium14TextSecondary,
                          textAlign: TextAlign.center,
                        ),
                        20.verticalSpace,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final starIndex = index + 1;
                            final isFilled = starIndex <= state.rating;
                            return InkWell(
                              key: Key('star_$starIndex'),
                              onTap: () => cubit.setRating(starIndex),
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 8,
                                ),
                                child: Icon(
                                  isFilled
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 42,
                                  color: isFilled
                                      ? AppColors.warning
                                      : AppColors.outline,
                                ),
                              ),
                            );
                          }),
                        ),
                        if (state.rating == 0) ...[
                          8.verticalSpace,
                          Text(
                            context.tr.selectRatingRequired,
                            style: context.regular12TextSecondary.copyWith(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                        32.verticalSpace,

                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            context.tr.reviewCommentLabel,
                            style: context.semiBold14TextMain,
                          ),
                        ),
                        8.verticalSpace,
                        AppTextField(
                          key: const Key('rate_doctor_comment_field'),
                          controller: _commentController,
                          hintText: context.tr.reviewCommentHint,
                          maxLines: 4,
                          minLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              reviewCommentMaxLength,
                            ),
                          ],
                          onChanged: cubit.setComment,
                        ),
                        6.verticalSpace,
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            '${state.comment.length}/$reviewCommentMaxLength',
                            style: context.regular12TextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: AppPrimaryButton(
                    key: const Key('rate_doctor_submit_button'),
                    label: context.tr.submitReview,
                    isLoading: state.status == RateDoctorStatus.submitting,
                    onPressed: state.canSubmit
                        ? () => cubit.submitReview(appointment)
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
