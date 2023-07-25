import 'package:cached_network_image/cached_network_image.dart';

import '../../../../model/product.dart';
import '../../../../utils/labels.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function()? onTap;
  const ProductCard({Key? key, required this.product, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: theme.colorScheme.background,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name),
                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: style.bodySmall,
                            ),
                            Text(
                              product.price != null
                                  ? "${Labels.rupee} ${product.price}/${product.unit}"
                                  : Labels.priceOnEnquiry,
                              style: TextStyle(
                                color: style.bodySmall!.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(height: 1)
          ],
        ),
      ),
    );
  }
}
