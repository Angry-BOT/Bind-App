import 'package:bind_app/ui/components/loading.dart';

import '../../../../utils/labels.dart';

import '../../../../model/store.dart' as model;
import '../providers/admin_enquires_provider.dart';
import 'enqury_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final filterStateProvider = StateProvider<String>((ref) => Labels.all);

class EnquriesView extends ConsumerWidget {
  final model.Store store;

  const EnquriesView({Key? key, required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final filterer = ref.watch(filterStateProvider.state);
    return Column(
      children: [
        ListTile(
          title: Text(Labels.myEnquiries),
          subtitle: Text(
            Labels.viewEnquiries,
            style: style.bodySmall,
          ),
          trailing: SizedBox(
            width: 104,
            height: 36,
            child: DropdownButtonFormField<String>(
              value: filterer.state,
              icon: Icon(Icons.keyboard_arrow_down),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.primaryColor,
                  ),
                ),
              ),
              items: [
                Labels.all,
                Labels.active,
                Labels.bought,
              ]
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                filterer.state = v!;
              },
            ),
          ),
        ),
        Divider(height: 0.5),
        Builder(builder: (context) {
          final model =
              ref.watch(storeEnquriesViewModelProvider(filterer.state));
          final enquriesStream = ref.watch(activeEnquiresProvider);
          return Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (!model.busy &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  model.loadMore();
                }
                return true;
              },
              child: RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(storeEnquriesViewModelProvider(filterer.state));
                    ref.refresh(activeEnquiresProvider);
                  },
                  child: enquriesStream.when(
                      data: (enquries) => CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.all(8),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate(
                                    (enquries
                                                .where((element) =>
                                                    filterer.state == Labels.all
                                                        ? true
                                                        : filterer.state ==
                                                                Labels.active
                                                            ? !element.bought
                                                            : element.bought)
                                                .toList() +
                                            model.enquiries)
                                        .map((e) => EnquiryCard(enquiry: e))
                                        .toList(),
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Center(
                                  child: model.loading &&
                                          model.enquiries.length > 5
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                            ],
                          ),
                      loading: () => Loading(),
                      error: (e, s) {
                        return Center(
                          child: Text('$e'),
                        );
                      })),
            ),
          );
        })
      ],
    );
  }
}
