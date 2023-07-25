import 'dart:io';

import 'package:bind_app/ui/components/my_files.dart';
import 'package:bind_app/ui/components/progess_loader.dart';
import 'package:bind_app/ui/pages/auth/providers/add_documents_view_model_provider.dart';

import '../../components/app_info_tooltip.dart';
import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import '../../components/small_gray_button.dart';
import 'providers/write_address_view_model_provider.dart';
import 'write_address_page.dart';

class AddDocumentPage extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(addDocumentsViewModelProvider);
    final aadharController = useTextEditingController();
    final aadharController2 = useTextEditingController();
    final verificationController = useTextEditingController();

    void next() {
      ref.read(writeAddressViewModelProvider).needStoreAddress = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WriteAddressPage(),
        ),
      );
    }

    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        appBar: MyAppBar(
          underline: false,
          title: Text(Labels.virtualStoreVerification),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BigButton(
                child: Text(model.profile.storeAddressExist
                    ? Labels.done
                    : Labels.next),
                onPressed: model.isReady
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          if (model.profile.storeAddressExist) {
                            model.completeProfile(onComplete: () {
                              Navigator.pop(context);
                            });
                          } else {
                            next();
                          }
                        }
                      }
                    : null,
              ),
              if (!model.profile.storeAddressExist)
                TextButton(
                  onPressed: () {
                    model.skip();
                    next();
                  },
                  child: Text(
                    Labels.skipForNow,
                    style: TextStyle(color: style.bodySmall!.color),
                  ),
                ),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              RichText(
                text: TextSpan(
                  text: '',
                  style: style.titleMedium,
                  children: Labels.verifyYourBusinessListing(Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: AppColors.green,
                  ))
                      .map((e) => e is String
                          ? TextSpan(text: e)
                          : WidgetSpan(child: e))
                      .toList(),
                ),
              ),
              SizedBox(height: 24),
              RichText(
                text: TextSpan(
                    text: Labels.aadharNumber,
                    style: style.bodyMedium,
                    children: [
                      WidgetSpan(
                        child:
                            AppInfoToolTip(message: Labels.theDataOfAadharCard),
                      )
                    ]),
              ),
              SizedBox(height: 12),
              TextFormField(
                maxLength: 12,
                keyboardType: TextInputType.number,
                onChanged: (v) => model.aadharId = v,
                validator: (v) => model.aadharValidator(v!),
              ),
              SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(Labels.uploadAadhar),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${Labels.maxUploadSize4mb}- ${Labels.pdf}, ${Labels.jpgPng}",
                      style: style.labelSmall,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                readOnly: true,
                controller: aadharController,
                decoration: InputDecoration(
                  labelText: 'Front',
                  suffixIcon: SmallGrayButton(
                    lable: Labels.select,
                    onPressed: () async {
                      final picked = await MyImages.pickDocument(context);
                      if (picked != null) {
                        model.aadhar = picked;
                        aadharController.text = picked.path.split('/').last;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                readOnly: true,
                controller: aadharController2,
                decoration: InputDecoration(
                  labelText: 'Back',
                  suffixIcon: SmallGrayButton(
                    lable: Labels.select,
                    onPressed: () async {
                      final picked = await MyImages.pickDocument(context);
                      if (picked != null) {
                        model.aadhar2 = picked;
                        aadharController2.text = picked.path.split('/').last;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 48),
              Text(Labels.personalVerification),
              SizedBox(height: 12),
              Text(
                Labels.clickYourPictureHoldingAadhar,
                style: style.labelSmall,
              ),
              Text(
                Labels.maxUploadSize4mb + "- " + Labels.jpgPng,
                style: style.labelSmall,
              ),
              SizedBox(height: 12),
              TextField(
                readOnly: true,
                controller: verificationController,
                onTap: () async {
                  File? file = await MyImages.takeShot(context);
                  if (file != null) {
                    verificationController.text = file.path.split('/').last;
                    model.verification = file;
                  }
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.camera_alt_outlined),
                  hintText: Labels.clickToCapture,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
