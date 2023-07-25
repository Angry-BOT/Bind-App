import 'package:bind_app/ui/pages/home/providers/home_search_view_model_provider.dart';

import '../../auth/providers/search_state_provider.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'home_search_results_view.dart';

class HomeSearchView extends HookConsumerWidget {
  const HomeSearchView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final searchState = ref.read(searchStateProvider.state);
    final controller = useTextEditingController();
    final model = ref.read(homeSearchViewModelProvider);
    return Stack(
      children: [
        searchState.state ? HomeSearchResultsView() : SizedBox(),
        Container(
          margin: EdgeInsets.all(16),
          child: TextField(
            controller: controller,
            onTap: () {
              searchState.state = true;
            },
            onSubmitted: (v) {
              searchState.state = false;
            },
            onChanged: (v) => model.debouncer.value = v,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: Labels.searchForProductsServicesStores,
              suffixIcon: model.debouncer.value.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        controller.text = '';
                        model.debouncer.value = '';
                      },
                      icon: Icon(
                        Icons.clear,
                      ),
                    )
                  : null,
            ),
          ),
          decoration: ShapeDecoration(
            color: theme.cardColor,
            shape: StadiumBorder(),
            shadows: [
              BoxShadow(
                color: theme.shadowColor,
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
