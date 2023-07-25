import 'package:cached_network_image/cached_network_image.dart';

import '../../profile/seller_profile_page.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../model/store.dart' as models;

import '../share_page.dart';

class StoreBanner extends StatelessWidget {
  const StoreBanner({
    Key? key,
    required this.store,
    this.showShareButton = false,
  }) : super(key: key);

  final models.Store store;
  final bool showShareButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return AspectRatio(
      aspectRatio: 2.75,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: store.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      store.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  store.aadharVerified
                                      ? Icon(
                                          Icons.check_circle_outline,
                                          size: 14,
                                          color: AppColors.green,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                            Text(
                              store.rating.toStringAsFixed(1),
                              style: style.labelSmall,
                            ),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.yellow,
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            text: Labels.by,
                            style: style.bodySmall!.copyWith(
                              color: style.bodyLarge!.color,
                            ),
                            children: [
                              TextSpan(
                                text: " ${store.username}",
                                style: style.bodySmall,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SellerProfilePage(store: store),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                       if(store.isVerified) Material(
                          borderRadius: BorderRadius.circular(2),
                          color: Color(0xFF22C951),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                            child: Text('MSME VERIFIED',style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),),
                          ),
                        )
                      ] +
                      (showShareButton
                          ? [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SharePage(store: store),
                                    ),
                                  );
                                },
                                child: Text(Labels.share),
                              ),
                            ]
                          : []),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
