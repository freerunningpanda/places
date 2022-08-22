import 'package:flutter/material.dart';

import 'package:places/data/sight.dart';
import 'package:places/ui/res/app_assets.dart';
import 'package:places/ui/res/app_colors.dart';
import 'package:places/ui/res/app_strings.dart';
import 'package:places/ui/res/app_typography.dart';
import 'package:places/ui/widgets/chevrone_back.dart';
import 'package:places/ui/widgets/sight_icons.dart';

class SightDetails extends StatelessWidget {
  final Sight sight;
  const SightDetails({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _SightDetailsImage(
                  sight: sight,
                  height: 360,
                ),
                const Positioned(
                  left: 16,
                  top: 36,
                  child: ChevroneBack(
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _DetailsScreenTitle(
                    sight: sight,
                  ),
                  const SizedBox(height: 24),
                  _DetailsScreenDescription(sight: sight),
                  const SizedBox(height: 24),
                  _SightDetailsBuildRouteBtn(sight: sight),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const _SightDetailsBottom(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsScreenTitle extends StatelessWidget {
  final Sight sight;

  const _DetailsScreenTitle({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sight.name,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            Text(
              sight.type,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(width: 16),
            Text(
              '${AppString.closed} 9:00',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _SightDetailsImage extends StatelessWidget {
  final Sight sight;
  final double height;
  const _SightDetailsImage({
    Key? key,
    required this.sight,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.network(
        sight.url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _DetailsScreenDescription extends StatelessWidget {
  final Sight sight;
  const _DetailsScreenDescription({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      child: Text(
        sight.details,
        style: theme.textTheme.displaySmall,
      ),
    );
  }
}

class _SightDetailsBuildRouteBtn extends StatelessWidget {
  final Sight sight;
  const _SightDetailsBuildRouteBtn({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.green,
        ),
        child: GestureDetector(
          onTap: () => debugPrint('Build a route pressed'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SightIcons(
                assetName: AppAssets.goIcon,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                AppString.goButtonTitle.toUpperCase(),
                style: AppTypography.sightDetailsButtonName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SightDetailsBottom extends StatelessWidget {
  const _SightDetailsBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => debugPrint('Schedule pressed'),
          child: Row(
            children: const [
              SizedBox(
                width: 17,
              ),
              SightIcons(
                assetName: AppAssets.calendar,
                width: 22,
                height: 19,
              ),
              SizedBox(width: 9),
              Text(
                AppString.schedule,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => debugPrint('To favourite pressed'),
          child: Row(
            children: [
               SightIcons(
                assetName: AppAssets.favouriteDark,
                width: 20,
                height: 18,
                color: theme.iconTheme.color,
              ),
              const SizedBox(width: 9),
              Text(
                AppString.favourite,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(
                width: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}