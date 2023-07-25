import 'dart:io';

import '../../components/big_button.dart';
import '../../components/my_appbar.dart';
import '../../components/progess_loader.dart';
import 'providers/rate_view_model_provider.dart';
import '../../theme/app_colors.dart';
import '../../../utils/assets.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class RatePage extends ConsumerWidget {
  final String storeId;
  final String enquiryId;
  RatePage({required this.storeId, required this.enquiryId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final model = ref.watch(rateViewModelProvider(storeId));
    return ProgressLoader(
      isLoading: model.loading,
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(Labels.rate),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: BigButton(
            child: Text(Labels.submit),
            onPressed: model.ready
                ? () {
                    model.submit(
                        onDone: () {
                          Navigator.pop(context);
                        },
                        enquiryId: enquiryId);
                  }
                : null,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Text(
              Labels.didTheSellerFulfillYourRequirement,
              style: style.titleMedium,
            ),
            Row(
              children: [
                Radio<bool>(
                  value: model.fulFill ?? false,
                  groupValue: true,
                  onChanged: (v) {
                    model.fulFill = !v!;
                  },
                ),
                Text(Labels.yes),
                SizedBox(width: 16),
                Radio<bool>(
                  value: model.fulFill ?? true,
                  groupValue: false,
                  onChanged: (v) {
                    model.fulFill = !v!;
                  },
                ),
                Text(Labels.no),
              ],
            ),
            SizedBox(height: 16),
            Text(
              Labels.areYouSatisfiedWith,
              style: style.titleMedium,
            ),
            Row(
              children: [
                Radio<bool>(
                  value: model.quality ?? false,
                  groupValue: true,
                  onChanged: (v) {
                    model.quality = !v!;
                  },
                ),
                Text(Labels.yes),
                SizedBox(width: 16),
                Radio<bool>(
                  value: model.quality ?? true,
                  groupValue: false,
                  onChanged: (v) {
                    model.quality = !v!;
                  },
                ),
                Text(Labels.no),
              ],
            ),
            SizedBox(height: 16),
            Text(
              Labels.rateTheSeller,
              style: style.titleMedium,
            ),
            SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 0.0,
              minRating: 1,
              itemSize: 32,
              unratedColor: theme.dividerColor,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                model.rating = rating;
              },
            ),
            SizedBox(height: 16),
            Text(
              Labels.addPictures,
              style: style.titleMedium,
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: () async {
                              final file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (file != null) {
                                model.addFile(File(file.path));
                              }
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.lightGrayButtonColor,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Center(
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
                        SizedBox(width: 4),
                      ] +
                      model.files
                          .map(
                            (e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: GestureDetector(
                                  onTap: () => model.removeFile(e),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.lightGrayButtonColor,
                                      image: DecorationImage(
                                        image: FileImage(e),
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
                                              Labels.delete,
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
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              Labels.addAReview,
              style: style.titleMedium,
            ),
            SizedBox(height: 8),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (v) => model.review = v,
              minLines: 5,
              maxLines: 10,
              textInputAction: TextInputAction.done,
            )
          ],
        ),
      ),
    );
  }
}
