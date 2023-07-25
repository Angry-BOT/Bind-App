import 'package:bind_app/ui/components/big_button.dart';
import 'package:bind_app/ui/pages/enquiry/providers/enquire_view_model_provider.dart';
import 'package:bind_app/utils/labels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:bind_app/model/product.dart';
import 'package:bind_app/ui/components/my_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductPage extends HookWidget {
  const ProductPage({Key? key, required this.product, required this.canAdd})
      : super(key: key);

  final Product product;
  final bool canAdd;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    Size textSize(String text, TextStyle style) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 10,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width - 48);
      return textPainter.size;
    }

    final autoplay = useState(true);

    final subtext = (product.priceOnEnquire ?? false)
        ? Labels.priceOnEnquiry
        : "${product.price}/${product.unit}";

    return Scaffold(
      appBar: MyAppBar(
        title: Text(product.name),
      ),
      bottomNavigationBar: canAdd
          ? Consumer(
              builder: (context, ref, child) {
                final model =
                    ref.watch(enquireViewModelProvider(product.storeId));
                final added = model.products.contains(product.name);
                return BigButton(
                  color: added ? theme.colorScheme.error : null,
                  bottomFlat: true,
                  child: Text(added
                      ? Labels.removeFromEnquiryList
                      : Labels.addToEnquiryList),
                  onPressed: () {
                    model.toggle(product.name);
                  },
                );
              },
            )
          : null,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: theme.primaryColorLight,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1,
                      enableInfiniteScroll:
                          product.images.length == 1 ? false : true,
                      autoPlay: autoplay.value,
                      autoPlayInterval: Duration(seconds: 2,milliseconds: 500)
                    ),
                    items: product.images
                        .map(
                          (i) => InteractiveViewer(
                            panEnabled:
                                false, // Set it to false to prevent panning.
                            minScale: 1,
                            maxScale: 4,
                            onInteractionStart: (v) {
                              autoplay.value = false;
                            },
                            onInteractionEnd: (v) {
                              autoplay.value = true;
                            },
                            child: CachedNetworkImage(
                              imageUrl: i,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 54),
                    Text(product.description),
                    SizedBox(height: 24),
                    Text(
                      subtext,
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 24,
            bottom: 24 +
                textSize(subtext, style.bodyMedium!).height +
                24 +
                textSize(product.description, style.bodyMedium!).height +
                24,
            child: Container(
              height: 108,
              width: 108,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(product.image),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
