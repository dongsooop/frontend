import 'package:dongsoop/ui/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonImgStyle extends StatelessWidget {
  final String? imagePath;
  final double size;
  final bool showPlaceholderIfEmpty;

  const CommonImgStyle({
    super.key,
    this.imagePath,
    this.size = 88,
    this.showPlaceholderIfEmpty = true,
  });

  bool _isNetworkUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    if (!hasImage && !showPlaceholderIfEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorStyles.gray1,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: hasImage
            ? _isNetworkUrl(imagePath!)
                ? Image.network(
                    imagePath!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFallbackIcon();
                    },
                  )
                : Image.asset(
                    imagePath!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  )
            : _buildFallbackIcon(),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/image_not_supported.svg',
        width: 32,
        height: 32,
        colorFilter: const ColorFilter.mode(
          ColorStyles.gray3,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
