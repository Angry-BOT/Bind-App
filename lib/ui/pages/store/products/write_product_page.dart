import 'dart:io';
import 'package:bind_app/extension/string_extension.dart';
import 'package:bind_app/ui/components/my_files.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../components/drop_down_field.dart';
import '../../../components/my_appbar.dart';
import '../../../components/progess_loader.dart';
import 'providers/write_product_view_model_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/data.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WriteProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(writeProductViewModelProvider);
    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: model.isReady
            ? FloatingActionButton.extended(
                onPressed: model.isReady
                    ? () {
                        model.writeProduct(
                          onWrite: () {
                            Navigator.pop(context);
                          },
                        );
                      }
                    : null,
                label: Text(Labels.save),
              )
            : SizedBox(),
        appBar: MyAppBar(
          underline: true,
          title: Text(
            model.id != null ? Labels.editProduct : Labels.addProduct,
            style: style.titleLarge,
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            Text(Labels.uploadProductImage),
            SizedBox(height: 8),
            Text(
              Labels.firstImageWillBeTheDisplay,
              style: style.labelSmall,
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
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
                              : model.image != null
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          model.image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: model.file != null || model.image != null
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: model.images
                            .map(
                              (e) => AppImageBox(
                                image: NetworkImage(e),
                                onTap: () {
                                  model.removeImage(e);
                                },
                              ),
                            )
                            .toList()
                            .cast<Widget>() +
                        model.files
                            .map(
                              (e) => AppImageBox(
                                image: FileImage(e),
                                onTap: () {
                                  model.removeFile(e);
                                },
                              ),
                            )
                            .toList() +
                        [
                          if (model.images.length + model.files.length < 4)
                            GestureDetector(
                              onTap: () async {
                                final File? pickedFile =
                                    await MyImages.pickAndCompress();
                                if (pickedFile != null) {
                                  model.addfile(pickedFile);
                                }
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrayButtonColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: ImageIcon(
                                    AssetImage(Assets.addBig),
                                  ),
                                ),
                              ),
                            ),
                        ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(Labels.productName),
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
              initialValue: model.description,
              maxLength: 200,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => model.description = v,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 24),
            Text(Labels.priceOnEnquiry),
            SizedBox(height: 12),
            DropDownField<String?>(
              value: model.priceOnEnquire,
              values: [Labels.yes, Labels.no],
              onSelect: (v) => model.priceOnEnquire = v,
            ),
            SizedBox(height: 32),
            !model.priceOn
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Labels.price),
                            SizedBox(height: 12),
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixText: " ${Labels.rupee} "),
                              initialValue: model.price?.toString(),
                              onChanged: (v) => model.price =
                                  v.isNotEmpty ? double.parse(v) : null,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Labels.unit),
                            SizedBox(height: 12),
                            DropDownField<String?>(
                              value: model.unit,
                              values: Data.units,
                              onSelect: (v) => model.unit = v,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(height: 56)
          ],
        ),
      ),
    );
  }
}

class AppImageBox extends StatelessWidget {
  const AppImageBox({
    Key? key,
    required this.onTap,
    required this.image,
  }) : super(key: key);

  final VoidCallback onTap;
  final ImageProvider image;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.topRight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.lightGrayButtonColor,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: image,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 24,
              color: theme.dividerColor,
              child: Center(
                child: Text(
                  Labels.remove.toUpperCase(),
                  style: style.labelSmall!.copyWith(
                    color: theme.cardColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
