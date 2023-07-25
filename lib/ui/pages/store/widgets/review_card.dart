import 'package:cached_network_image/cached_network_image.dart';

import '../../../../model/rate.dart';
import '../reply_page.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  final Rate rate;
  final bool isAdmin;
  final String? username;
  const ReviewCard({Key? key, required this.rate,this.isAdmin = false,this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(rate.customerName),
                    Spacer(),
                    RatingBarIndicator(
                      rating: rate.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                   isAdmin? Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReplyPage(rate: rate),
                            ),
                          );
                        },
                        child: Text(
                            rate.reply == null ? Labels.reply : Labels.editReply),
                      ),
                    ):SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  rate.review,
                  style: TextStyle(color: style.bodySmall!.color),
                ),
              ),
             rate.images.isNotEmpty? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: rate.images.map((e) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        height: 64,
                        width: 64,
                        child: CachedNetworkImage(
        imageUrl:e,fit: BoxFit.cover,),
                      ),
                    ) ).toList(),
                  ),
                ),
              ):SizedBox(),
             rate.reply!=null&&!isAdmin? Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        Labels.replyFromStoreOwner,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '@$username',
                        // style: style.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        rate.reply!,
                        style: TextStyle(color: style.bodySmall!.color),
                      ),
                    ),
                  ],
                ),
              ):SizedBox()
            ],
          ),
        ),
        Divider(height: 1)
      ],
    );
  }
}
