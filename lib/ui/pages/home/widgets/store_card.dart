import 'package:cached_network_image/cached_network_image.dart';

import '../../../../model/store.dart';
import '../../../components/gray_label.dart';
import '../../store/store_page.dart';
import 'package:flutter/material.dart';

import '../../../../utils/labels.dart';
import '../../../theme/app_colors.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({Key? key, required this.store, this.match = ''})
      : super(key: key);
  final Store store;
  final String match;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    if (match.isNotEmpty) {
      store.products.sort((a, b) => a.toLowerCase().contains(match) ? 0 : 1);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AspectRatio(
        aspectRatio: 2.75,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StorePage(store: store),
            ),
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: store.logo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    )
                                  ],
                                ),
                              ),
                              Spacer(flex: 4),
                              Text(
                                store.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                text: TextSpan(
                                    style: style.bodySmall,
                                    text: store.products
                                        .where((element) =>
                                            store.products.indexOf(element) < 3)
                                        .join(', '),
                                    children: (store.products.length > 3
                                        ? <InlineSpan>[
                                            WidgetSpan(
                                              child: GrayLabel(
                                                  label:
                                                      "+ ${store.products.length - 3} other"),
                                            )
                                          ]
                                        : null)),
                              ),
                              Spacer(flex: 3),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: store.active
                      ? SizedBox()
                      : Transform.translate(
                          offset: Offset(8, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: theme.colorScheme.error),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
                              child: Text(
                                'Closed',
                                style: style.bodySmall!
                                    .copyWith(color: theme.colorScheme.error),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// class StoreResultCard extends StatelessWidget {
//   const StoreResultCard({Key? key, required this.store}) : super(key: key);
//   final StoreResult store;
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: AspectRatio(
//         aspectRatio: 2.75,
//         child: GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => SharedStorePageRoot(id: store.id),
//             ),
//           ),
//           child: Container(
//             clipBehavior: Clip.antiAlias,
//             margin: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: theme.cardColor,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: theme.shadowColor,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: Stack(
//               alignment: Alignment.centerRight,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: AspectRatio(
//                           aspectRatio: 1,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: CachedNetworkImage(
//                               imageUrl: store.logo,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Flexible(
//                                           child: Text(
//                                             store.name,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         SizedBox(width: 4),
//                                         store.aadharVerifyed
//                                             ? Icon(
//                                                 Icons.check_circle_outline,
//                                                 size: 14,
//                                                 color: AppColors.green,
//                                               )
//                                             : SizedBox(),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(
//                                     store.rating.toStringAsFixed(1),
//                                     style: style.overline,
//                                   ),
//                                   Icon(
//                                     Icons.star,
//                                     size: 14,
//                                     color: AppColors.yellow,
//                                   ),
//                                 ],
//                               ),
//                               RichText(
//                                 text: TextSpan(
//                                   text: Labels.by,
//                                   style: style.caption!.copyWith(
//                                     color: style.bodyText1!.color,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: " ${store.username}",
//                                       style: style.caption,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Spacer(flex: 4),
//                               Text(
//                                 store.type.toUpperCase(),
//                                 style: TextStyle(
//                                   fontSize: 8,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Spacer(),

//                               RichText(
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 3,
//                                 text: TextSpan(
//                                     style: style.caption,
//                                     text: store.products
//                                         .where((element) =>
//                                             store.products.indexOf(element) < 3)
//                                         .join(', '),
//                                     children: (store.products.length > 3
//                                         ? <InlineSpan>[
//                                             WidgetSpan(
//                                               child: GrayLabel(
//                                                   label:
//                                                       "+ ${store.products.length - 3} other"),
//                                             )
//                                           ]
//                                         : null)),
//                               ),
//                               // Wrap(
//                               //   children: store.products
//                               //           .where((element) =>
//                               //               store.products.indexOf(element) < 3)
//                               //           .map(
//                               //             (e) => Text(
//                               //               e +
//                               //                   (store.products.last != e
//                               //                       ? ', '
//                               //                       : ''),
//                               //               style: style.caption,
//                               //             ),
//                               //           )
//                               //           .toList()
//                               //           .cast<Widget>() +
//                               //       ((store.products.length > 3)
//                               //           ? [

//                               //             ]
//                               //           : []),
//                               // ),
//                               Spacer(flex: 3),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   right: 0,
//                   child: store.active
//                       ? SizedBox()
//                       : Transform.translate(
//                           offset: Offset(8, 0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: theme.errorColor),
//                                 borderRadius: BorderRadius.circular(8)),
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
//                               child: Text(
//                                 'Closed',
//                                 style: style.caption!
//                                     .copyWith(color: theme.errorColor),
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
