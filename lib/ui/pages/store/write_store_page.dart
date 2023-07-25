import 'dart:io';

import 'package:bind_app/extension/string_extension.dart';
import 'package:bind_app/ui/components/my_files.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../components/progess_loader.dart';
import 'providers/setup_store_view_model_provider.dart';
import '../../theme/app_colors.dart';
import '../../../utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/labels.dart';
import '../../components/big_button.dart';
import '../../components/my_appbar.dart';

class WriteStorePage extends ConsumerWidget {
  final bool forCreate;

  WriteStorePage({this.forCreate = false});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(setupStoreViewModelProvider);
    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
          child: BigButton(
            child: Text(model.logo != null ? Labels.save : Labels.createStore),
            onPressed: model.isReady
                ? () {
                    model.writeStore(
                      onWrite: () {
                        Navigator.pop(context);
                        if (forCreate) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  }
                : null,
          ),
        ),
        appBar: MyAppBar(
          underline: true,
          title: Text(
            model.logo != null ? Labels.editStore : Labels.addStore,
            style: style.titleLarge,
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            AspectRatio(
              aspectRatio: 2.5,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        final File? pickedFile = await MyImages.pickAndCrop();
                        if (pickedFile != null) {
                          model.file = pickedFile;
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.lightGrayButtonColor,
                          image: model.file != null
                              ? DecorationImage(
                                  image: FileImage(model.file!),
                                  fit: BoxFit.cover,
                                )
                              : model.logo != null
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          model.logo!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: model.file != null || model.logo != null
                                  ? SizedBox()
                                  : Center(
                                      child: ImageIcon(
                                        AssetImage(Assets.addBig),
                                      ),
                                    ),
                            ),
                            Container(
                              height: 24,
                              color: theme.dividerColor,
                              child: Center(
                                child: Text(
                                  Labels.add,
                                  style: style.labelSmall!.copyWith(
                                    color: theme.cardColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Labels.storeLogo),
                          SizedBox(height: 8),
                          Text(
                            Labels.maxUploadSize4mb,
                            style: style.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(Labels.storeName),
            SizedBox(height: 12),
            TextFormField(
              initialValue: model.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (v) => model.name = v.nameTrim(),
            ),
            SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(Labels.description),
                Text(
                  " (${Labels.max200Characters})",
                  style: style.bodySmall,
                )
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              textInputAction: TextInputAction.done,
              initialValue: model.description,
              maxLength: 200,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => model.description = v,
            ),
          ],
        ),
      ),
    );
  }
}
