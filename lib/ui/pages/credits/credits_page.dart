import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/loading.dart';
import '../../components/my_appbar.dart';
import '../../theme/app_colors.dart';
import 'about_credit_page.dart';
import 'add_credits_page.dart';
import 'providers/master_data_provider.dart';
import 'providers/transactions_view_model_provider.dart';
import 'providers/wallet_provider.dart';
import 'widgets/transaction_card.dart';

class CreditsPage extends ConsumerWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final width = MediaQuery.of(context).size.width;
    final walletStream = ref.watch(walletProvider);
    final masterdata = ref.watch(masterDataProvider);
    final filter = ref.watch(transactionFilterProvider.state);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.bindCredits),
        actions: [
          walletStream.asData?.value.freez ?? false
              ? Chip(
                  backgroundColor: theme.colorScheme.error.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: theme.colorScheme.error,
                  ),
                  label: Text("Freezed"),
                )
              : SizedBox(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutCreditPage(),
                ),
              );
            },
            icon: CircleAvatar(
              backgroundColor: AppColors.lightOrange,
              child: Text(
                'i',
                style: style.titleLarge,
              ),
            ),
          ),
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            expandedHeight: width,
            floating: true,
            pinned: true,
            flexibleSpace: walletStream.when(
                data: (wallet) => FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        children: [
                          Spacer(),
                          Text(Labels.youHave),
                          Text(
                            "${wallet.credits}",
                            style: style.displayMedium!
                                .copyWith(color: style.bodyLarge!.color),
                          ),
                          Text(Labels.bINDCredits),
                          Spacer(),
                          masterdata.when(
                              data: (data) => Text(
                                  '1 ${Labels.coin} = ${Labels.rupee}${data.price}'),
                              loading: () => SizedBox(),
                              error: (e, s) {
                                if (e is FirebaseException) {
                                  if (e.code == "permission-denied") {
                                    ref.refresh(masterDataProvider);
                                  }
                                }
                                return Text(e.toString());
                              }),
                          Spacer(),
                          !wallet.freez
                              ? MaterialButton(
                                  color: theme.primaryColor,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddCreditsPage(),
                                      ),
                                    );
                                  },
                                  child: Text(Labels.addCredits),
                                )
                              : SizedBox(),
                          Spacer(),
                          SizedBox(height: 57),
                        ],
                      ),
                    ),
                loading: () => Loading(),
                error: (e, s) {
                  return Text("$e");
                }),
            bottom: PreferredSize(
              child: Column(
                children: [
                  Divider(height: 0.5),
                  ListTile(
                    title: Text(Labels.transactions),
                    trailing: SizedBox(
                      width: 120,
                      height: 36,
                      child: DropdownButtonFormField<String>(
                        value: filter.state == null
                            ? Labels.all
                            : filter.state!
                                ? Labels.debit
                                : Labels.credit,
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
                          Labels.credit,
                          Labels.debit,
                        ]
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == Labels.all) {
                            filter.state = null;
                          } else {
                            if (v == Labels.debit) {
                              filter.state = true;
                            } else {
                              filter.state = false;
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Divider(height: 0.5)
                ],
              ),
              preferredSize: Size.fromHeight(57),
            ),
          ),
        ];
      }, body: Consumer(builder: (context, ref, child) {
        final model = ref.watch(transactionsViewModelProvider(filter.state));
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (!model.busy &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
              model.loadMore();
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(transactionsViewModelProvider(filter.state)),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    model.reviews
                        .map((e) => TransactionCard(
                              transaction: e,
                            ))
                        .toList(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: model.loading && model.reviews.length > 10
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}
