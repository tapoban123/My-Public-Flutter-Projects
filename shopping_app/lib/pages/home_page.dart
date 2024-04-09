import 'package:flutter/material.dart';
import 'package:shopping_app/pages/shoes_collection_page.dart';
import 'package:shopping_app/pages/shopping_cart_page.dart';

// This page is implements the navigation mechanism of the BottomNavigationBar
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  // Pages to navigate
  final pages = [
    const ShoesCollectionPage(),
    const ShoppingCartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (pageIndex) {
          setState(() {
            currentPageIndex = pageIndex;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '',
          )
        ],
        iconSize: 35,
        selectedFontSize: 0,
        unselectedFontSize: 0,
      ),
      /* IndexedStack allows us to maintain the state of each page whenever 
         the page is navigated from one to another. */
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),
    );
  }
}
