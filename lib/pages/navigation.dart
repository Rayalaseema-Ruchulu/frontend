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

  int _pageIndex = 0;
  final _pages = const <Widget>[FeaturedPage(), MenuPage()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    leading: logo,
                    destinations: [
                      const NavigationRailDestination(
                        icon: Icon(Icons.star_outline_rounded),
                        selectedIcon: Icon(Icons.star_rounded),
                        label: Text('Featured'),
                      ),
                      const NavigationRailDestination(
                        icon: Icon(Icons.menu_book_rounded),
                        label: Text('Menu'),
                      ),
                    ],
                    onDestinationSelected: (value) {
                      setState(() {
                        _pageIndex = value;
                      });
                    },
                    selectedIndex: _pageIndex,
                    labelType: NavigationRailLabelType.all,
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(
                    child: IndexedStack(index: _pageIndex, children: _pages),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: logo, centerTitle: true),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _pageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _pageIndex = index;
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
            body: IndexedStack(index: _pageIndex, children: _pages),
          );
        }
      },
    );
  }
}
