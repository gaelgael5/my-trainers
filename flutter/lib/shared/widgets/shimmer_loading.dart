import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? child;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppDimensions.radiusMd,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  final double? width;
  final double height;

  const ShimmerText({
    super.key,
    this.width,
    this.height = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: width,
      height: height,
      borderRadius: AppDimensions.xs,
    );
  }
}

class ShimmerAvatar extends StatelessWidget {
  final double size;

  const ShimmerAvatar({
    super.key,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }
}

class ShimmerButton extends StatelessWidget {
  final double? width;
  final double height;

  const ShimmerButton({
    super.key,
    this.width,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: width,
      height: height,
      borderRadius: AppDimensions.radiusMd,
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;

  const ShimmerCard({
    super.key,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(AppDimensions.base),
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: width,
      height: height,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerText(width: 120),
            const SizedBox(height: AppDimensions.sm),
            const ShimmerText(width: 80),
            const SizedBox(height: AppDimensions.sm),
            ShimmerText(width: width != null ? width! * 0.7 : 200),
          ],
        ),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  final bool showAvatar;
  final bool showTrailing;

  const ShimmerListTile({
    super.key,
    this.showAvatar = true,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.base,
        vertical: AppDimensions.sm,
      ),
      child: Row(
        children: [
          if (showAvatar) ...[
            const ShimmerAvatar(size: 40),
            const SizedBox(width: AppDimensions.md),
          ],
          const Expanded(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                const ShimmerText(width: 150, height: 18),
                const SizedBox(height: AppDimensions.xs),
                const ShimmerText(
                  width: 100,
                  height: 14,
                ),
              ],
            ),
          ),
          if (showTrailing)
            const ShimmerLoading(
              width: 24,
              height: 24,
              borderRadius: AppDimensions.xs,
            ),
        ],
      ),
    );
  }
}

class ShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  const ShimmerGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppDimensions.md,
        mainAxisSpacing: AppDimensions.md,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ShimmerCard(),
    );
  }
}