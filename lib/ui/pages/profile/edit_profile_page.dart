import 'package:cached_network_image/cached_network_image.dart';

import 'widgets/update_email_sheet.dart';

import '../../components/my_appbar.dart';
import '../../components/progess_loader.dart';
import '../../components/small_gray_button.dart';
import 'providers/edit_profile_view_model_provider.dart';
import 'widgets/update_phone_number_sheet.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditProfilePage extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(editProfileViewModelProvider);
    final controller = useTextEditingController(text: model.mobile);
    final emailController = useTextEditingController(text: model.emailAddress);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.editProfile),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: model.ready
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  model.update(onDone: () {
                    Navigator.pop(context);
                  });
                }
              },
              label: Text(Labels.save),
            )
          : SizedBox(),
      body: ProgressLoader(
        isLoading: model.loading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => model.pickImage(),
                  child: CircleAvatar(
                    radius: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Material(
                          color: theme.cardColor.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Center(
                              child: Text(
                                Labels.change,
                                style: style.labelSmall,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundImage: model.file != null
                        ? FileImage(model.file!)
                        : model.image != null
                            ? CachedNetworkImageProvider(model.image!)
                                as ImageProvider
                            : null,
                  ),
                ),
              ),
              Text(Labels.firstName),
              SizedBox(height: 8),
              TextFormField(
                initialValue: model.firstName,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => model.firstName = v,
              ),
              SizedBox(height: 24),
              Text(Labels.lastName),
              SizedBox(height: 8),
              TextFormField(
                initialValue: model.lastName,
                textCapitalization: TextCapitalization.words,
                onChanged: (v) => model.lastName = v,
              ),
              SizedBox(height: 24),
              Text(Labels.emailAddress),
              SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: emailController,
                decoration: InputDecoration(
                  suffixIcon: SmallGrayButton(
                    lable: Labels.change,
                    onPressed: () async {
                      String? updated = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: theme.cardColor,
                        builder: (context) => UpdateEmailSheet(),
                      );
                      model.clear();
                      if (updated != null) {
                        emailController.text = '$updated';
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(Labels.mobileNo),
              SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: controller,
                decoration: InputDecoration(
                  suffixIcon: SmallGrayButton(
                    lable: Labels.change,
                    onPressed: () async {
                      String? updated = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: theme.cardColor,
                        builder: (context) => UpdatePhoneNumberSheet(),
                      );
                      model.clear();
                      if (updated != null) {
                        controller.text = '$updated';
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(Labels.aboutMe),
              SizedBox(height: 8),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: model.about,
                maxLines: 5,
                minLines: 3,
                onChanged: (v) => model.about = v,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
