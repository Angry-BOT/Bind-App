import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/rate.dart';
import '../../components/my_appbar.dart';
import 'providers/review_view_model_provider.dart';
import '../../../utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReplyPage extends ConsumerWidget {
  ReplyPage({Key? key, required this.rate}) : super(key: key);
  final Rate rate;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Labels.review),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 32),
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
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                                    textInputAction: TextInputAction.done,

                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                initialValue: rate.reply,
                onSaved: (v) {
                  ref
                      .read(reviewsViewModelProvider(rate.storeId))
                      .reply(rate.id, v!);
                  Navigator.pop(context);
                },
                validator: (v) => v!.isEmpty ? "Enter reply message" : null,
              ),
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
              child: Text(Labels.reply),
            ),
          ),
        ],
      ),
    );
  }
}
