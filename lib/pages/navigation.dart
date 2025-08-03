import 'package:flutter/material.dart';
import 'package:rr_app/pages/featured.dart';
import 'package:rr_app/pages/menu.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class Navigation extends StatelessWidget {
  static const Widget logo = VectorGraphic(
    loader: AssetBytesLoader('assets/icons/icon.svg'),
  );

  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    const tabBar = TabBar(
      tabs: [
        Tab(text: 'Featured', icon: Icon(Icons.star_rounded)),
        Tab(text: 'Menu', icon: Icon(Icons.menu_book_rounded)),
      ],
    );

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: logo,
          centerTitle: true,
          bottom: MediaQuery.of(context).size.width >= 700 ? tabBar : null,
        ),
        bottomNavigationBar: MediaQuery.of(context).size.width < 700 ? tabBar : null,
        body: const TabBarView(children: [FeaturedPage(), MenuPage()]),
      ),
    );
  }
}
