import 'package:common/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:rr_app/app.dart';
import 'package:rr_app/widgets/category.dart';
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
    return CategoryUtils.items(_items);
  }

  Future<List<(CategoryOrIngredient, List<MenuItem>)>> _getItems() async {
    final client = await App.apiClient;
    final categories = await client.getCategories();

    return CategoryUtils.loadItemsFromCategories(client, categories);
  }
}
