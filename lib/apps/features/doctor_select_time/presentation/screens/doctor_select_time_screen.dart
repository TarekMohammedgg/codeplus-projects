import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/data/models/time_slot_model.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/data/select_time_data.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/date_selector_list.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_profile_card.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/no_slots_available_section.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/thank_you_dialog.dart';
import 'package:doctor_hunt/apps/features/doctor_select_time/presentation/widgets/time_slots_section.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class SelectTimeScreen extends StatefulWidget {
  const SelectTimeScreen({super.key, required this.doctor});

  final DoctorDetailArgs doctor;

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  late List<DateOptionItem> _dateOptions;
  late String _selectedOptionId;
  String? _selectedSlotId;

  @override
  void initState() {
    super.initState();
    _dateOptions = availableDateOptions();
    _selectedOptionId = _dateOptions.first.id;
  }

  void _onDateOptionSelected(DateOptionItem option) {
    setState(() {
      _selectedOptionId = option.id;
      _selectedSlotId = null;
    });
  }

  void _onSlotSelected(String slotId) {
    setState(() {
      _selectedSlotId = slotId;
    });
  }

  DateOptionItem _findNextAvailableDate(
    List<DateOptionItem> dateOptions,
    String currentId,
  ) {
    final currentIndex = dateOptions.indexWhere((d) => d.id == currentId);
    final safeIndex = currentIndex == -1 ? 0 : currentIndex;

    return dateOptions
        .skip(safeIndex + 1)
        .firstWhere(
          (option) => option.hasSlots,
          orElse: () => dateOptions[safeIndex],
        );
  }

  String _formatNextAvailabilityDate(DateOptionItem nextOption) {
    if (nextOption.dayLabel.contains('Tomorrow')) {
      return 'Wed, 24 Feb';
    }
    return nextOption.dayLabel;
  }

  TimeSlotItem? _resolveSelectedSlot(List<TimeSlotItem> allSlots) {
    if (allSlots.isEmpty) return null;

    final match = allSlots.where((s) => s.id == _selectedSlotId);
    if (match.isNotEmpty) return match.first;

    return allSlots.first;
  }

  void _onConfirm(String dateLabel, String timeSlot) {
    ThankYouDialog.show(
      context,
      doctorName: widget.doctor.name,
      dateLabel: dateLabel,
      timeSlot: timeSlot,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateOption = _dateOptions.firstWhere(
      (opt) => opt.id == _selectedOptionId,
      orElse: () => _dateOptions.first,
    );
    final allSlots = selectedDateOption.allSlots;
    final selectedSlot = _resolveSelectedSlot(allSlots);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: AppIconButton.back(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              const HomeRoute().go(context);
            }
          },
        ),
        title: Text(tr.selectTime, style: context.bold18TextMain),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.verticalSpace,
                  DoctorProfileCard(doctor: widget.doctor),
                  20.verticalSpace,
                  DateSelectorList(
                    selectedOptionId: _selectedOptionId,
                    dateOptions: _dateOptions,
                    onSelectOption: _onDateOptionSelected,
                  ),
                  24.verticalSpace,
                  Center(
                    child: Text(
                      selectedDateOption.dayLabel,
                      style: context.bold18TextMain,
                    ),
                  ),
                  16.verticalSpace,
                  if (!selectedDateOption.hasSlots)
                    NoSlotsAvailableSection(
                      nextAvailableDateLabel: _formatNextAvailabilityDate(
                        _findNextAvailableDate(_dateOptions, _selectedOptionId),
                      ),
                      onNextAvailabilityTap: () {
                        final nextOption = _findNextAvailableDate(
                          _dateOptions,
                          _selectedOptionId,
                        );
                        _onDateOptionSelected(nextOption);
                      },
                      onContactClinicTap: () =>
                          context.showInfoSnackBar(tr.contactingClinic),
                    )
                  else ...[
                    TimeSlotsSection(
                      title:
                          '${tr.afternoonSlots} ${tr.slotsCount(count: selectedDateOption.afternoonSlots.length)}',
                      slots: selectedDateOption.afternoonSlots,
                      selectedSlotId: selectedSlot?.id,
                      onSelectSlot: _onSlotSelected,
                    ),
                    20.verticalSpace,
                    TimeSlotsSection(
                      title:
                          '${tr.eveningSlots} ${tr.slotsCount(count: selectedDateOption.eveningSlots.length)}',
                      slots: selectedDateOption.eveningSlots,
                      selectedSlotId: selectedSlot?.id,
                      onSelectSlot: _onSlotSelected,
                    ),
                  ],
                  24.verticalSpace,
                ],
              ),
            ),
          ),
          if (selectedDateOption.hasSlots)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: selectedSlot == null
                        ? null
                        : () => _onConfirm(
                            selectedDateOption.dayLabel,
                            selectedSlot.time,
                          ),
                    child: Text(tr.confirm, style: context.bold16White),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
