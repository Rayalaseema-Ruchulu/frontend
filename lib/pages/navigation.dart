import 'package:flutter/material.dart';
import 'package:rr_app/pages/featured.dart';
import 'package:rr_app/pages/menu.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<StatefulWidget> createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  static const Widget logo = VectorGraphic(
    loader: AssetBytesLoader('assets/icons/icon.svg'),
  );

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: logo,
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Featured',
          ),
          NavigationDestination(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
      body: const <Widget>[FeaturedPage(), MenuPage()][pageIndex],
    );
  }
}
