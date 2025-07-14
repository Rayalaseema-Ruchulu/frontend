import 'package:common/grid.dart';
import 'package:common/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:rr_app/app.dart';
import 'package:rr_app/widgets/item_tile.dart';
import 'package:common/models/category.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(10), child: _Items());
  }
}

class _Items extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemsState();
  }
}

class _ItemsState extends State<_Items> {
  late final Future<List<(CategoryOrIngredient, List<MenuItem>)>> _items;

  @override
  void initState() {
    super.initState();

    _items = _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _items,
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
                          (context, itemIndex) => ItemTile(
                            category.$2[itemIndex],
                          ),
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

  Future<List<(CategoryOrIngredient, List<MenuItem>)>> _getItems() async {
    final client = await App.apiClient;
    final categories = await client.getCategories();

    final List<(CategoryOrIngredient, List<MenuItem>)> items = [];
    for (CategoryOrIngredient category in categories) {
      final categoryItems = await client.getCategoryItems(category.id);
      items.add((category, categoryItems));
    }

    return items;
  }
}
