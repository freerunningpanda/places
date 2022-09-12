import 'package:flutter/material.dart';
import 'package:places/data/sight.dart';
import 'package:places/ui/widgets/search_appbar.dart';

import 'package:places/ui/widgets/search_bar.dart';

class SightSearchScreen extends StatelessWidget {
  final List<Sight> sightList;
  const SightSearchScreen({Key? key, required this.sightList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const readOnly = false;
    const isEnabled = true;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            const SizedBox(height: 16),
            const SearchAppBar(),
            SearchBar(
              isEnabled: isEnabled,
              sightList: sightList,
              readOnly: readOnly,
            ),
            _SightListWidget(sightList: sightList),
          ],
        ),
      ),
    );
  }
}

class _SightListWidget extends StatelessWidget {
  final List<Sight> sightList;
  const _SightListWidget({Key? key, required this.sightList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: sightList.length,
        itemBuilder: (context, index) {
          final sight = sightList[index];

          return Row(
            children: [
              Column(
                children: [
                  Image.network(
                    sight.url ?? 'null',
                    width: 156,
                    height: 156,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      sight.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Text(sight.type),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
