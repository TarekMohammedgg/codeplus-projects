import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    this.size = 130,
    this.borderWidth = 3,
    this.borderColor,
    this.boxShadow,
  });

  final String? avatarUrl;
  final double size;
  final double borderWidth;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl?.trim();
    final placeholder = DoctorAvatarPlaceholder(size: size);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.8),
          width: borderWidth,
        ),
        boxShadow:
            boxShadow ??
            const [
              BoxShadow(
                color: Color(0x24000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
      ),
      child: ClipOval(
        child: (url != null && url.isNotEmpty)
            ? (url.startsWith('http')
                  ? Image.network(
                      url,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null ? child : placeholder;
                      },
                      errorBuilder: (_, _, _) => placeholder,
                    )
                  : Image.asset(
                      url,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => placeholder,
                    ))
            : placeholder,
      ),
    );
  }
}
