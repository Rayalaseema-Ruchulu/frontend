import 'package:common/loading_tiles.dart';
import 'package:common/models/category.dart';
import 'package:common/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:rr_app/app.dart';

class Item extends StatefulWidget {
  const Item(this._thumbnail, this._menuItem, {super.key});

  final ImageProvider? _thumbnail;
  final MenuItem _menuItem;

  @override
  State<StatefulWidget> createState() {
    return _ItemState();
  }
}

class _ItemState extends State<Item> {
  late final Future<
    (
      List<CategoryOrIngredient> categories,
      List<CategoryOrIngredient> ingredients,
    )
  >
  _itemDetails;
  late final Future<ImageProvider> _fullImage;

  @override
  void initState() {
    super.initState();

    _itemDetails = _getDetails();
    _fullImage = _getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1020, maxHeight: 1000), // Account for padding
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(alignment: Alignment.topRight, child: CloseButton()),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child: itemImage()),
                          const SizedBox(width: 15),
                          Expanded(
                            child: itemDetails(context),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          itemImage(),
                          const SizedBox(height: 10),
                          itemDetails(context),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column itemDetails(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget._menuItem.name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),

        const SizedBox(height: 4),

        Text(
          '\$${widget._menuItem.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.labelLarge,
        ),

        const SizedBox(height: 10),

        FutureBuilder(
          future: _itemDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children:
                      snapshot.data!.$1
                          .map(
                            (category) => Chip(
                              label: Text(category.name),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                          )
                          .toList(),
                );
              } else {
                return Text(
                  'Error ${snapshot.error.toString()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
            } else {
              return const LoadingTiles();
            }
          },
        ),

        const SizedBox(height: 10),

        Text(
          widget._menuItem.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const Divider(),

        // Ingredients
        Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        FutureBuilder(
          future: _itemDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children:
                    snapshot.data!.$2
                        .map(
                          (ingredient) => Chip(
                            label: Text(ingredient.name),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        )
                        .toList(),
              );
            } else {
              return const LoadingTiles();
            }
          },
        ),
      ],
    );
  }

  Container itemImage() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: FutureBuilder(
          future: _fullImage,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                return Image(image: snapshot.data!);
              } else {
                return const Icon(Icons.image_not_supported_outlined);
              }
            } else {
              return widget._thumbnail == null
                  ? const Center(child: CircularProgressIndicator())
                  : Image(image: widget._thumbnail!);
            }
          },
        ),
      ),
    );
  }

  /// Retreives the categories and ingredients of an item
  Future<
    (
      List<CategoryOrIngredient> categories,
      List<CategoryOrIngredient> ingredients,
    )
  >
  _getDetails() async {
    final client = await App.apiClient;
    final itemDetails = await client.getItemDetails(widget._menuItem.id);

    final categoriesFutures = Future.wait(
      itemDetails.categories.map((id) => client.getCategory(id)).toList(),
    );
    final ingredientsFutures = Future.wait(
      itemDetails.ingredients.map((id) => client.getIngredient(id)).toList(),
    );

    final categories = await categoriesFutures;
    final ingredients = await ingredientsFutures;

    return (categories, ingredients);
  }

  Future<ImageProvider> _getImage() async {
    final client = await App.apiClient;
    return client.getImage(widget._menuItem.id);
  }
}
