import '../../../components/loading.dart';
import '../../credits/add_credits_page.dart';
import '../../credits/providers/wallet_provider.dart';
import '../../credits/widgets/credit.dart';
import '../providers/enquiry_buy_view_model_provider.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnquiryBuyDialog extends ConsumerWidget {
  const EnquiryBuyDialog({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final walletStream = ref.watch(walletProvider);
    final model = ref.watch(enquiryBuyViewModelProvider);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: walletStream.when(
          data: (wallet) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [CloseButton()],
              ),
              SizedBox(height: 16),
              Text(
                wallet.freez
                    ? Labels.oopsYourWalletHasbeenFreezed
                    : wallet.credits > 0
                        ? Labels.youWillBeCharged
                        : Labels.oopsYouDonHaveEnoughCredits,
                style: style.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              wallet.credits > 0 && !wallet.freez
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Credit(size: 32),
                        SizedBox(width: 8),
                        Text(
                          '1 Credit',
                          style: style.titleSmall,
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 32),
              model.loading
                  ? Loading()
                  : MaterialButton(
                      color: theme.primaryColor,
                      child: Text(wallet.credits > 0 || wallet.freez
                          ? Labels.okay
                          : Labels.buyNow),
                      onPressed: () async {
                        if (wallet.freez) {
                          Navigator.pop(context);
                        } else if (wallet.credits > 0) {
                          await model.buy(id);
                          Navigator.pop(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCreditsPageRoot(),
                            ),
                          );
                        }
                      },
                    ),
              SizedBox(height: 16),
            ],
          ),
          loading: () => Loading(),
          error: (e, s) => Text(
            '$e',
          ),
        ),
      ),
    );
  }
}
