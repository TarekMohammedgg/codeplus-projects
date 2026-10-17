import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

class ClinicLocationMap extends StatelessWidget {
  const ClinicLocationMap({super.key, this.location});

  static const LatLng defaultLocation = LatLng(30.0444, 31.2357);

  final LatLng? location;

  @override
  Widget build(BuildContext context) {
    final targetLocation = location ?? defaultLocation;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowElevated, blurRadius: 30),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 190,
          width: double.infinity,
          //CR hardcode color
          // Solved
          color: AppColors.mapPlaceholder,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: targetLocation,
              initialZoom: 14.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'doctor_hunt',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: targetLocation,
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.error,
                      size: 38,
                      shadows: [
                        Shadow(
                          color: AppColors.shadowStrong,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
