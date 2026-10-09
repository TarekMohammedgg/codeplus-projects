import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/models/clinic_model.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_card.dart';
import 'package:doctor_hunt/apps/core/widgets/clinic_location_map.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// The ONE clinic location (address + map) in a card.
class ClinicLocationCard extends StatelessWidget {
  const ClinicLocationCard({super.key, required this.clinic});

  final ClinicModel? clinic;

  @override
  Widget build(BuildContext context) {
    final address = clinic?.localizedAddress ?? '';
    final location = clinic?.location;

    return AppCard(
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
              Text(context.tr.clinicLocation, style: context.bold16TextMain),
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
  }
}
