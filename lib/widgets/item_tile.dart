import 'dart:async';

import 'package:common/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:rr_app/app.dart';
import 'package:rr_app/pages/item.dart';

class ItemTile extends StatefulWidget {
  const ItemTile(this._menuItem, {super.key});

  final MenuItem _menuItem;

  @override
  State<StatefulWidget> createState() {
    return _ItemTileState();
  }
}

class _ItemTileState extends State<ItemTile> {
  late final Future<ImageProvider> _thumbnail;
  ImageProvider? loadedImage;

  @override
  void initState() {
    super.initState();

    _thumbnail = getThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1.0,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Item(loadedImage, widget._menuItem);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: FutureBuilder(
                  future: _thumbnail,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Image(
                        image: snapshot.data!,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget._menuItem.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget._menuItem.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '\$${widget._menuItem.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ImageProvider> getThumbnail() async {
    final client = await App.apiClient;

    loadedImage = await client.getThumbnail(widget._menuItem.id);

    return loadedImage!;
  }
}
