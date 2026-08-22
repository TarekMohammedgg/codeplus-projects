import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/features/doctors/data/doctors_data.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/apps/features/home/data/doctors_home_data.dart';
import 'package:doctor_hunt/apps/features/home/data/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  int selectedNavIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void selectNav(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  void openFindDoctors() {
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    const FindDoctorsRoute().push(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeaderSection(
              greeting: t.hiSteven,
              title: t.findYourDoctor,
              searchController: searchController,
              onSettingsTap: () => const SettingsRoute().push(context),
              profileImage: Assets.assetsDummyProfileImage,
            ),
            24.verticalSpace,
            LiveDoctorSection(
              liveDoctors: liveDoctors(t),
              onSeeAllPressed: openFindDoctors,
            ),
            24.verticalSpace,
            DoctorCategorySection(
              categories: categories(t),
              onCategoryTap: (_) => openFindDoctors(),
            ),
            24.verticalSpace,
            PopularDoctorSection(
              doctors: popularDoctors(t),
              onSeeAllPressed: openFindDoctors,
            ),
            24.verticalSpace,
            FeaturedDoctorSection(
              doctors: featuredDoctors(t),
              onSeeAllPressed: openFindDoctors,
            ),
            32.verticalSpace,
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: selectedNavIndex,
        onTap: selectNav,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.onSeeAllPressed,
  });

  final String title;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: context.bold18TextMain),
          InkWell(
            onTap: onSeeAllPressed,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                children: [
                  Text(
                    t.seeAll,
                    style: context.medium14TextSub.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                  4.horizontalSpace,
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
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

class LiveDoctorSection extends StatelessWidget {
  const LiveDoctorSection({
    super.key,
    required this.liveDoctors,
    required this.onSeeAllPressed,
  });

  final List<LiveDoctorItem> liveDoctors;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: t.liveDoctor, onSeeAllPressed: onSeeAllPressed),
        14.verticalSpace,
        SizedBox(
          height: 156,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: liveDoctors.length,
            separatorBuilder: (context, index) => 14.horizontalSpace,
            itemBuilder: (context, index) {
              final doctor = liveDoctors[index];
              return LiveDoctorCard(doctor: doctor);
            },
          ),
        ),
      ],
    );
  }
}

class LiveDoctorCard extends StatelessWidget {
  const LiveDoctorCard({super.key, required this.doctor});

  final LiveDoctorItem doctor;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (doctor.image != null)
              Positioned.fill(
                child: Image.asset(
                  doctor.image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        doctor.accentColor.withValues(alpha: 0.75),
                        doctor.accentColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.04),
                      Colors.black.withValues(alpha: 0.25),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF003A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      t.live,
                      style: context.bold11White.copyWith(
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCategorySection extends StatelessWidget {
  const DoctorCategorySection({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  final List<DoctorCategoryItem> categories;
  final ValueChanged<DoctorCategoryItem>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => 14.horizontalSpace,
        itemBuilder: (context, index) {
          final category = categories[index];
          return DoctorCategoryCard(
            category: category,
            onTap: () => onCategoryTap?.call(category),
          );
        },
      ),
    );
  }
}

class DoctorCategoryCard extends StatelessWidget {
  const DoctorCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final DoctorCategoryItem category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.secondaryColor,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: category.primaryColor.withValues(alpha: 0.18),
        highlightColor: category.primaryColor.withValues(alpha: 0.08),
        child: SizedBox(
          width: 54,
          height: 54,
          child: Center(
            child: category.image != null
                ? Image.asset(
                    category.image!,
                    width: 26,
                    height: 26,
                    color: category.primaryColor,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      category.icon ?? Icons.category_rounded,
                      color: category.primaryColor,
                      size: 26,
                    ),
                  )
                : Icon(
                    category.icon ?? Icons.category_rounded,
                    color: category.primaryColor,
                    size: 26,
                  ),
          ),
        ),
      ),
    );
  }
}

class PopularDoctorSection extends StatelessWidget {
  const PopularDoctorSection({
    super.key,
    required this.doctors,
    this.onSeeAllPressed,
  });

  final List<PopularDoctorItem> doctors;
  final VoidCallback? onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: t.popularDoctor,
          onSeeAllPressed:
              onSeeAllPressed ?? () => const FindDoctorsRoute().push(context),
        ),
        14.verticalSpace,
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            separatorBuilder: (context, index) => 14.horizontalSpace,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return PopularDoctorCard(
                doctor: doctor,
                onTap: () => DoctorDetailsRoute(
                  DoctorDetailArgs(
                    id: doctor.id,
                    name: doctor.name,
                    specialty: doctor.specialty,
                    image: doctor.image,
                    rating: doctor.rating,
                    isFavorite: doctor.isFavorite,
                    services: defaultServices(t),
                  ),
                ).push(context),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularDoctorCard extends StatelessWidget {
  const PopularDoctorCard({super.key, required this.doctor, this.onTap});

  final PopularDoctorItem doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 125,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: doctor.accentColor.withValues(alpha: 0.12),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: doctor.image != null
                        ? Image.asset(
                            doctor.image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 125,
                            alignment: Alignment.topCenter,
                          )
                        : SizedBox(),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      doctor.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: doctor.isFavorite
                          ? AppColors.error
                          : AppColors.disabled,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bold16TextMain.copyWith(fontSize: 15),
                  ),
                  4.verticalSpace,
                  Text(
                    doctor.specialty,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.regular12TextSub.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                      4.horizontalSpace,
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: context.semiBold12TextMain,
                      ),
                      6.horizontalSpace,
                      Flexible(
                        child: Text(
                          '(${doctor.reviewsCount} ${t.reviews})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.regular11TextSub.copyWith(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                          ),
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
    );
  }
}

class FeaturedDoctorSection extends StatelessWidget {
  const FeaturedDoctorSection({
    super.key,
    required this.doctors,
    required this.onSeeAllPressed,
  });

  final List<FeaturedDoctorItem> doctors;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: t.featuredDoctor,
          onSeeAllPressed: onSeeAllPressed,
        ),
        14.verticalSpace,
        SizedBox(
          height: 195,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            separatorBuilder: (context, index) => 14.horizontalSpace,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return FeaturedDoctorCard(
                doctor: doctor,
                onTap: () => DoctorDetailsRoute(
                  DoctorDetailArgs(
                    id: doctor.id,
                    name: doctor.name,
                    specialty: doctor.specialty,
                    image: doctor.image,
                    rating: doctor.rating,
                    hourlyRate: doctor.hourlyRate,
                    isFavorite: doctor.isFavorite,
                    services: defaultServices(t),
                  ),
                ).push(context),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FeaturedDoctorCard extends StatelessWidget {
  const FeaturedDoctorCard({super.key, required this.doctor, this.onTap});

  final FeaturedDoctorItem doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB800),
                      size: 14,
                    ),
                    2.horizontalSpace,
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: context.semiBold11TextMain,
                    ),
                  ],
                ),
                Icon(
                  doctor.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: doctor.isFavorite
                      ? AppColors.error
                      : AppColors.disabled,
                  size: 16,
                ),
              ],
            ),
            8.verticalSpace,
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: doctor.accentColor.withValues(alpha: 0.15),
              ),
              child: ClipOval(
                child: doctor.image != null
                    ? Image.asset(
                        doctor.image!,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(),
              ),
            ),
            8.verticalSpace,
            Text(
              doctor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bold14TextMain.copyWith(fontSize: 13),
            ),
            2.verticalSpace,
            Text(
              doctor.specialty,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.regular11TextSub.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            6.verticalSpace,
            Text(
              '\$${doctor.hourlyRate.toStringAsFixed(2)}${t.perHour}',
              style: context.bold12Primary,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home_rounded,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            NavItem(
              icon: Icons.favorite_rounded,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            NavItem(
              icon: Icons.menu_book_rounded,
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            NavItem(
              icon: Icons.chat_bubble_rounded,
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isSelected
                ? Colors.white
                : AppColors.textSecondary.withValues(alpha: 0.6),
            size: 24,
          ),
        ),
      ),
    );
  }
}
