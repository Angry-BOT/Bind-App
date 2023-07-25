import 'package:bind_app/ui/components/big_button.dart';
import 'package:bind_app/ui/pages/profile/providers/edit_username_view_model_provider.dart';
import 'package:bind_app/utils/labels.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final keyProvider = Provider.autoDispose((ref) => GlobalKey<FormState>());

class EditUsernameSheet extends HookConsumerWidget {
  const EditUsernameSheet({Key? key, required this.initial, required this.id})
      : super(key: key);
  final String initial;
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final model = ref.watch(editUsernameViewModelProvider);

    final _formkey = ref.watch(keyProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update username",
                style: style.titleLarge,
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                autofocus: true,
                initialValue: initial,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => model.username = v,
                onSaved: (v) => model.username = v!,
                validator: (v) => model.validateUserName(v!),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(' ', replacementString: '')
                ],
              ),
              SizedBox(
                height: 16,
              ),
              model.loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : BigButton(
                      child: Text(Labels.save),
                      onPressed:
                          model.username != null && model.username != initial
                              ? () async {
                                  if (_formkey.currentState!.validate()) {
                                    try {
                                      await model.update(id);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                }
                              : null,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
