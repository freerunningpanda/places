import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/providers/search_data_provider.dart';
import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/state/appstate.dart';
import 'package:places/redux/state/search_screen_state.dart';
import 'package:places/ui/res/app_assets.dart';
import 'package:places/ui/res/app_strings.dart';
import 'package:places/ui/res/app_typography.dart';
import 'package:places/ui/screens/add_sight_screen/add_sight_vm.dart';
import 'package:places/ui/screens/sight_details/sight_details.dart';
import 'package:places/ui/widgets/search_appbar.dart';
import 'package:places/ui/widgets/search_bar.dart';
import 'package:places/ui/widgets/sight_icons.dart';
import 'package:provider/provider.dart';

class SightSearchScreen extends StatelessWidget {
  const SightSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredPlaces = PlaceInteractor.filteredPlaces;
    const readOnly = false;
    const isSearchPage = true;

    final width = MediaQuery.of(context).size.width;

    context.watch<SearchDataProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const SearchAppBar(),
              const SizedBox(height: 16),
              const SearchBar(
                isSearchPage: isSearchPage,
                readOnly: readOnly,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StoreConnector<AppState, SearchScreenState>(
                        builder: (context, vm) {
                          // Если история поиска пуста, показываем просто список найденных мест
                          if (vm is SearchHistoryEmptyState) {
                            return Column(
                              children: [
                                const SizedBox(),
                                _SightListWidget(filteredPlaces: filteredPlaces, theme: theme),
                              ],
                            );
                          } 
                          // Если история не пустая то берём её из state и отображаем на экране
                          else if (vm is SearchHistoryHasValueState) {
                            return _SearchHistoryList(
                              theme: theme,
                              searchStoryList: vm.searchStoryList,
                              width: width,
                            );
                          } else {
                          // В противном случае показываем список найденных мест
                            return Column(
                              children: [
                                const SizedBox(),
                                _SightListWidget(filteredPlaces: filteredPlaces, theme: theme),
                              ],
                            );
                          }
                        },
                        converter: (store) => store.state.searchScreenState,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SightListWidget extends StatelessWidget {
  final List<Place> filteredPlaces;
  final ThemeData theme;
  const _SightListWidget({Key? key, required this.filteredPlaces, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return StoreConnector<AppState, SearchScreenState>(
      builder: (context, vm) {
        // Начальное состояние экрана пустого списка найденных мест
        if (vm is SearchScreenEmptyState) {
          return _EmptyListWidget(
            height: height,
            width: width,
            theme: theme,
          );
        // Если места найдены, берём их из state и отображаем на экране
        } else if (vm is SearchScreenFoundPlacesState) {
          return ListView.builder(
            physics: Platform.isAndroid ? const ClampingScrollPhysics() : const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: vm.filteredPlaces.length,
            itemBuilder: (context, index) {
              final sight = vm.filteredPlaces[index];

              return _SightCardWidget(
                sight: sight,
                width: width,
                theme: theme,
              );
            },
          );
        }

        return _EmptyListWidget(
          height: height,
          width: width,
          theme: theme,
        );
      },
      converter: (store) => store.state.searchScreenState,
    );
  }
}

class _EmptyListWidget extends StatelessWidget {
  final double height;
  final double width;
  final ThemeData theme;

  const _EmptyListWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _EmptyStateWidget(height: height, width: width);
  }
}

class _SearchHistoryList extends StatelessWidget {
  final Set<String> searchStoryList;
  final ThemeData theme;
  final double width;

  const _SearchHistoryList({
    Key? key,
    required this.searchStoryList,
    required this.theme,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: Platform.isAndroid ? const ClampingScrollPhysics() : const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        _SearchHistoryTitle(theme: theme),
        const SizedBox(height: 4),
        _SearchItem(
          theme: theme,
          searchStoryList: searchStoryList,
          width: width,
        ),
        const SizedBox(height: 15),
        const _ClearHistoryButton(),
      ],
    );
  }
}

class _ClearHistoryButton extends StatelessWidget {
  const _ClearHistoryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);

    return TextButton(
      onPressed: () => store.dispatch(
        RemoveAllItemsFromHistoryAction(
          historyList: const {},
        ),
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          AppString.clearHistory,
          style: AppTypography.clearButton,
        ),
      ),
    );
  }
}

class _SearchHistoryTitle extends StatelessWidget {
  final ThemeData theme;

  const _SearchHistoryTitle({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppString.youSearch,
      style: theme.textTheme.labelLarge,
    );
  }
}

class _SearchItem extends StatelessWidget {
  final ThemeData theme;
  final Set<String> searchStoryList;
  final double width;

  const _SearchItem({
    Key? key,
    required this.theme,
    required this.searchStoryList,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<SearchDataProvider>();

    return Column(
      children: searchStoryList
          .map(
            (e) => Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.read<ViewModel>().searchController.text = e,
                      child: SizedBox(
                        width: width * 0.7,
                        child: Text(
                          e,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        context.read<SearchDataProvider>().removeItemFromHistory(e);
                      },
                      child: const SightIcons(assetName: AppAssets.delete, width: 24, height: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  final double height;
  final double width;

  const _EmptyStateWidget({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: height * 0.2,
          ),
          const SightIcons(
            assetName: AppAssets.search,
            width: 64,
            height: 64,
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            AppString.noPlaces,
            style: AppTypography.emptyListTitle,
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: width * 0.6,
            child: const Text(
              AppString.tryToChange,
              style: AppTypography.detailsTextDarkMode,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: height * 0.2,
          ),
        ],
      ),
    );
  }
}

class _SightCardWidget extends StatelessWidget {
  final Place sight;
  final double width;
  final ThemeData theme;

  const _SightCardWidget({
    Key? key,
    required this.sight,
    required this.width,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: SizedBox(
            child: Row(
              children: [
                _SightImage(sight: sight),
                const SizedBox(width: 16),
                _SightContent(width: width, sight: sight, theme: theme),
              ],
            ),
          ),
        ),
        _RippleEffect(sight: sight),
      ],
    );
  }
}

class _RippleEffect extends StatelessWidget {
  final Place sight;

  const _RippleEffect({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => Navigator.of(context).push<SightDetails>(
            MaterialPageRoute(
              builder: (context) => SightDetails(
                place: sight,
                height: 360,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SightContent extends StatelessWidget {
  final double width;
  final Place sight;
  final ThemeData theme;

  const _SightContent({
    Key? key,
    required this.width,
    required this.sight,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _SightTitle(width: width, sight: sight, theme: theme),
        const SizedBox(height: 8),
        _SightType(sight: sight, theme: theme),
        const SizedBox(height: 16),
        Container(
          height: 1,
          width: width * 0.73,
          color: theme.dividerColor,
        ),
      ],
    );
  }
}

class _SightType extends StatelessWidget {
  final Place sight;
  final ThemeData theme;

  const _SightType({
    Key? key,
    required this.sight,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      sight.placeType,
      style: theme.textTheme.bodyMedium,
    );
  }
}

class _SightTitle extends StatelessWidget {
  final double width;
  final Place sight;
  final ThemeData theme;

  const _SightTitle({
    Key? key,
    required this.width,
    required this.sight,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.73,
      child: Text(
        sight.name,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

class _SightImage extends StatelessWidget {
  final Place sight;

  const _SightImage({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(sight.urls[0]),
          ),
        ),
      ),
    );
  }
}
