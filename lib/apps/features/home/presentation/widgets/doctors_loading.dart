import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DoctorsLoading extends StatelessWidget {
  const DoctorsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            _sectionTitleSkeleton(),
            const SizedBox(height: 14),
            SizedBox(
              height: 156,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, _) => Bone(
                  width: 116,
                  height: 156,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, _) => Bone(
                  width: 54,
                  height: 54,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitleSkeleton(),
            const SizedBox(height: 14),
            SizedBox(
              height: 240,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, _) => Bone(
                  width: 190,
                  height: 240,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitleSkeleton(),
            const SizedBox(height: 14),
            SizedBox(
              height: 195,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, _) => Bone(
                  width: 150,
                  height: 195,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitleSkeleton() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Bone.text(width: 130), Bone.text(width: 48)],
      ),
    );
  }
}
