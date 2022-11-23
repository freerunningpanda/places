import 'dart:async';

import 'package:flutter/material.dart';

import 'package:places/data/sight.dart';
import 'package:places/ui/res/app_assets.dart';
import 'package:places/ui/res/app_colors.dart';
import 'package:places/ui/res/app_strings.dart';
import 'package:places/ui/res/app_typography.dart';
import 'package:places/ui/widgets/close_bottom_sheet.dart';
import 'package:places/ui/widgets/sight_icons.dart';

class SightDetails extends StatefulWidget {
  final Sight sight;
  final double height;
  const SightDetails({
    Key? key,
    required this.sight,
    required this.height,
  }) : super(key: key);

  @override
  State<SightDetails> createState() => _SightDetailsState();
}

class _SightDetailsState extends State<SightDetails> {
  final _pageController = PageController();

  @override
  void initState() {
    var currentIndex = 0;
    Timer.periodic(
      const Duration(
        seconds: 3,
      ),
      (timer) {
        currentIndex++;
        if (currentIndex > 2) {
          currentIndex = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              child: Container(),
              color: AppColors.detailsScreenBackground,
            ),
          ),
          const SizedBox(height: 12),
          _SightDetailsClosed(
            height: widget.height,
            sight: widget.sight,
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}

class _SightDetailsFull extends StatelessWidget {
  final Sight sight;
  final double height;
  final PageController _pageController;

  const _SightDetailsFull({
    Key? key,
    required this.sight,
    required this.height,
    required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            height: 16,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              color: AppColors.detailsScreenBottomSheet,
            ),
          ),
        ),
        Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                color: theme.sliderTheme.thumbColor,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).orientation == Orientation.portrait ? 629 : 350,
                ),
                child: ListView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _SightDetailsGallery(
                        height: height,
                        sight: sight,
                        pageController: _pageController,
                      ),
                    ),
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
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SightDetailsClosed extends StatefulWidget {
  final Sight sight;
  final double height;
  final PageController _pageController;

  const _SightDetailsClosed({
    Key? key,
    required this.sight,
    required this.height,
    required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  @override
  State<_SightDetailsClosed> createState() => _SightDetailsClosedState();
}

class _SightDetailsClosedState extends State<_SightDetailsClosed> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: size.width / 2.5,
                right: size.width / 2.5,
                child: GestureDetector(
                  onTap: _showGallery,
                  child: Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      color: theme.iconTheme.color,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait ? size.height / 2.0 : size.height / 1.5,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _DetailsScreenTitle(
                      sight: widget.sight,
                    ),
                    const SizedBox(height: 24),
                    _DetailsScreenDescription(sight: widget.sight),
                    const SizedBox(height: 24),
                    _SightDetailsBuildRouteBtn(sight: widget.sight),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const _SightDetailsBottom(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showGallery() {
    showModalBottomSheet<_SightDetailsFull>(
      context: context,
      builder: (_) => _SightDetailsFull(
        height: widget.height,
        sight: widget.sight,
        pageController: widget._pageController,
      ),
      isScrollControlled: true,
    );
  }
}

class _SightDetailsGallery extends StatelessWidget {
  final Sight sight;
  final double height;
  final PageController _pageController;

  const _SightDetailsGallery({
    Key? key,
    required this.sight,
    required this.height,
    required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.8,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: height,
            flexibleSpace: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height,
                  child: Scrollbar(
                    controller: _pageController,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _SightDetailsImage(
                          sight: sight,
                          height: height,
                        ),
                        _SightDetailsImage(
                          sight: sight,
                          height: height,
                        ),
                        _SightDetailsImage(
                          sight: sight,
                          height: height,
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 32,
                  right: 16,
                  child: CloseBottomSheet(
                    width: 32,
                    height: 32,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: size.width / 2.3,
                  right: size.width / 2.3,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        color: theme.sliderTheme.thumbColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        sight.url ?? 'no_url',
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.sliderTheme.activeTrackColor,
        ),
        child: GestureDetector(
          onTap: () => debugPrint('🟡---------Build a route pressed'),
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
          onTap: () => debugPrint('🟡---------Schedule pressed'),
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
          onTap: () => debugPrint('🟡---------To favourite pressed'),
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
