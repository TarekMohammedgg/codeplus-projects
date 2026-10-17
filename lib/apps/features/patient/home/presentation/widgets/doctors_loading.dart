import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DoctorsLoading extends StatelessWidget {
  const DoctorsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: [
          const SizedBox(height: 24),
          const _BonesRow(count: 4, width: 54, height: 54, radius: 14),
          for (var section = 0; section < 2; section++) ...[
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Bone.text(width: 130), Bone.text(width: 48)],
              ),
            ),
            const SizedBox(height: 14),
            const _BonesRow(count: 2, width: 190, height: 240, radius: 16),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _BonesRow extends StatelessWidget {
  const _BonesRow({
    required this.count,
    required this.width,
    required this.height,
    required this.radius,
  });

  final int count;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, _) => Bone(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
