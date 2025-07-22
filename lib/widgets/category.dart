import 'package:common/grid.dart';
import 'package:common/models/category.dart';
import 'package:common/models/menu_item.dart';
import 'package:common/network.dart';
import 'package:flutter/material.dart';
import 'package:rr_app/widgets/item_tile.dart';

class CategoryUtils {
  static Widget items(
    Future<List<(CategoryOrIngredient, List<MenuItem>)>> items,
  ) {
    return FutureBuilder(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(
              'Unable to load data from server: ${snapshot.error.toString()}',
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.$1.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    GridView.builder(
                      gridDelegate: const FixedHeightGridDelegate(
                        minItemWidth: 325,
                        fixedItemHeight: 128,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: category.$2.length,
                      itemBuilder:
                          (context, itemIndex) =>
                              ItemTile(category.$2[itemIndex]),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  static Future<List<(CategoryOrIngredient, List<MenuItem>)>>
  loadItemsFromCategories(
    ApiClient client,
    List<CategoryOrIngredient> categories,
  ) async {
    final itemsWithCategory = await Future.wait(
      categories.map((category) async {
        return (category, await client.getCategoryItems(category.id));
      }),
    );

    return itemsWithCategory;
  }
}
