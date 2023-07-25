import '../posts/widgets/components/post_image_widget.dart';
import '../posts/widgets/components/post_text_widget.dart';
import '../posts/widgets/components/post_video_widget.dart';

import '../../../model/faq.dart';
import '../../../model/post/post_image.dart';
import '../../../model/post/post_text.dart';
import '../../../model/post/post_video.dart';
import '../../../repository/faq_repository.dart';
import '../../components/my_appbar.dart';

import '../profile/providers/profile_provider.dart';
import '../../theme/app_colors.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ignore: must_be_immutable
class FaqPage extends ConsumerWidget {
  final Faq faq;
  FaqPage({Key? key, required this.faq}) : super(key: key);
  bool feedback = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final reviewed = ref.watch(profileProvider).value!.reviewedFaqs ?? [];
    final repository = ref.read(faqRepositoryProvider);
    final widgets = <Widget>[];
    final videos = faq.components
        .where((element) => element is PostVideo)
        .map((e) => e as PostVideo);
    return VideoPlayer(
      id: videos.isNotEmpty ? videos.first.value : null,
      builder: (player) {
        for (var item in faq.components) {
          if (item is PostText) {
            widgets.add(
              PostTextWidget(
                text: item,
              ),
            );
          } else if (item is PostImage) {
            widgets.add(
              PostImageWidget(
                image: item,
              ),
            );
          } else if (item is PostVideo) {
            widgets.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: player,
              ),
            );
          }
        }
        return Scaffold(
          appBar: MyAppBar(
            title: Text(faq.name),
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: widgets +
                (!reviewed.contains(faq.id)
                    ? [
                        SizedBox(height: 40),
                        Text(
                          Labels.isThisHelpful,
                          style: style.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                feedback = true;
                                repository.review(faq.id, true);
                              },
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(color: AppColors.green),
                                ),
                              ),
                              child: Text(Labels.yes),
                            ),
                            SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: () {
                                feedback = true;

                                repository.review(faq.id, true);
                              },
                              child: Text(Labels.no),
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(color: theme.colorScheme.error),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]
                    : [
                        feedback
                            ? Padding(
                                padding: const EdgeInsets.all(40),
                                child: Text(
                                  Labels.thanksForYourFeedback,
                                  style: style.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : SizedBox()
                      ]),
          ),
        );
      },
    );
  }
}
