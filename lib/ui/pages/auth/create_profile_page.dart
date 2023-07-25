import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import '../../root.dart';
import 'providers/create_profile_view_model_provider.dart';

class CreateProfilePage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(createProfileViewModelProvider);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
        child: BigButton(
          child: Text(Labels.next),
          onPressed: model.isReady
              ? () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    model.createProfile(
                      onCreate: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Root(),
                        ),
                        (route) => false,
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
          Labels.contactDetails,
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
            Text(Labels.firstName),
            SizedBox(height: 12),
            TextFormField(
              initialValue: model.firstName,
              textCapitalization: TextCapitalization.words,
              onChanged: (v) => model.firstName = v,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))
              ],
            ),
            SizedBox(height: 32),
            Text(Labels.lastName),
            SizedBox(height: 12),
            TextFormField(
              initialValue: model.lastName,
              textCapitalization: TextCapitalization.words,
              onChanged: (v) => model.lastName = v,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))
              ],
            ),
            SizedBox(height: 32),
            Text(Labels.emailAddress),
            SizedBox(height: 12),
            TextFormField(
              initialValue: model.emailAddress,
              onChanged: (v) => model.emailAddress = v.toLowerCase(),
              onSaved: (v) => model.emailAddress = v!.toLowerCase(),
              validator: (v) => model.validateEmail(v!.toLowerCase()),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.deny(' ', replacementString: '')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
