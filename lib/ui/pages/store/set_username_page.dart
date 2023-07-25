import 'providers/setup_store_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import 'write_store_page.dart';

class SetUserNamePage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(setupStoreViewModelProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
        child: BigButton(
          child: Text(Labels.next),
          onPressed: model.username.isNotEmpty
              ? () {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteStorePage(forCreate: true),
                    ),
                  );
                  }
                }
              : null,
        ),
      ),
      appBar: MyAppBar(
        underline: false,
        title: Text(
          Labels.setBindId,
          style: style.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: 56,
            horizontal: 24,
          ),
          children: [
            Text(Labels.setABindId),
            SizedBox(height: 12),
            Text(
              Labels.thisWillBeYourUniqueEntrepreneur,
              style: style.labelSmall,
            ),
            SizedBox(height: 12),
            TextFormField(
              textCapitalization: TextCapitalization.words,
              onChanged: (v) => model.username = v,
              onSaved: (v) => model.username = v!,
              validator: (v)=>model.validateUserName(v!),
              inputFormatters: [
                FilteringTextInputFormatter.deny(' ',replacementString: '')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
