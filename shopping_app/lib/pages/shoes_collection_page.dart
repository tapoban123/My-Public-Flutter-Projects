import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/global_variables.dart';
import 'package:shopping_app/components/product_card.dart';
import 'package:shopping_app/pages/product_details_page.dart';
import 'package:shopping_app/providers/search_items_provider.dart';

/*
This page defines the first screen of the shopping app where all the shoe items are displayed.
*/
class ShoesCollectionPage extends StatefulWidget {
  const ShoesCollectionPage({super.key});

  @override
  State<ShoesCollectionPage> createState() => _ShoesCollectionPageState();
}

class _ShoesCollectionPageState extends State<ShoesCollectionPage> {
  // The following is the list of filters that can be applied on the items available.
  final List<String> filters = const [
    "All",
    "Nike",
    "Adidas",
    "Puma",
    "Jordan",
    "Bata",
    "Reebok",
  ];
  late String currentFilter;
  bool searchingItem = false;

  @override
  void initState() {
    // Sets the current filter to "All"
    currentFilter = filters[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> itemsToDisplay = [];

    TextEditingController searchItemController = TextEditingController();

    const OutlineInputBorder textFieldBorderStyle = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
      ),
    );

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Shoes\nCollection",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: Consumer<SearchItemsProvider>(
                  builder: (context, searchItemsProvider, child) {
                    return TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search",
                        border: textFieldBorderStyle,
                        enabledBorder: textFieldBorderStyle,
                        focusedBorder: textFieldBorderStyle,
                      ),
                      controller: searchItemController,
                      onChanged: (value) {
                        // This function is called when the customer is trying to search for some specific items.
                        // If searchTextField is empty, all the items are displayed, else, only the filtered items are displayed.
                        if (searchItemController.text.isEmpty) {
                          searchItemsProvider.returnAllItems();
                        } else {
                          searchItemsProvider.returnFilteredItems();
                          searchItemsProvider.addOrRemoveFromFoundItems(value);
                        }
                      },
                      cursorColor: Colors.black,
                    );
                  },
                ),
              ),
            ],
          ),
          // The following ListView displays the list of filters
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentFilter = filter;
                      });
                    },
                    child: Chip(
                      label: Text(filter),
                      labelStyle: const TextStyle(fontSize: 16),
                      backgroundColor: currentFilter == filter
                          ? Theme.of(context).colorScheme.primary
                          : const Color.fromRGBO(245, 247, 249, 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Color.fromRGBO(245, 247, 249, 1),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<SearchItemsProvider>(
              builder: (context, searchItemsProvider, child) {
                /* We are using the LayoutBuilder to get the screen size and height in order 
                   to the make the application responsive. */
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // We are the getting the items to display from the SearchItemsProvider
                    itemsToDisplay = searchItemsProvider.getItems;

                    // When searchItemsList is empty, displays a proper message
                    if (itemsToDisplay.isEmpty) {
                      return Center(
                        child: Text(
                          "No items found.",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    }

                    Map<String, Object> product;

                    // The following displays a proper message when no items are available for a filter.
                    if (currentFilter != filters[0]) {
                      bool noItemsFound =
                          checkFilteredData(itemsToDisplay, 'company');

                      if (noItemsFound) {
                        return Center(
                          child: Text(
                            "Sorry, $currentFilter is currently out of stock.",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      }
                    }

                    // A GridView is returned when the maxWidth of the screen in above 650
                    if (constraints.maxWidth > 650) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: currentFilter == filters[0]
                            ? itemsToDisplay.length
                            : (itemsToDisplay.where((element) =>
                                element['company'] == currentFilter)).length,
                        itemBuilder: (context, index) {
                          // Returns data when no filter is applied
                          if (currentFilter == filters[0]) {
                            product = itemsToDisplay[index];

                            return gridViewContent(context, product, index);
                          } else {
                            // Returns filtered data as per the filter applied
                            product = itemsToDisplay.singleWhere((element) =>
                                element['company'] == currentFilter);

                            return gridViewContent(context, product, index);
                          }
                        },
                      );
                    } else {
                      // The ListView is returned when the maxWidth if lower than 650
                      return ListView.builder(
                        itemCount: itemsToDisplay.length,
                        itemBuilder: (context, index) {
                          product = itemsToDisplay[index];

                          // Returns when no filters are applied
                          if (currentFilter == filters[0]) {
                            return listViewContent(context, product, index);
                          } else {
                            // Returns filtered data as per the applied filter
                            if (products[index]['company'] == currentFilter) {
                              return listViewContent(context, product, index);
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                        },
                      );
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Returns True if any item matches the applied filter, else returns False
  bool checkFilteredData(
      List<Map<String, Object>> products, String searchField) {
    List<Map<String, Object>> filteredData = [];

    for (var item in products) {
      if (item[searchField] == currentFilter) {
        filteredData.add(item);
      }
    }
    if (filteredData.isEmpty) {
      return true;
    }
    return false;
  }

  // Returns the ListView Content Card
  GestureDetector listViewContent(
      BuildContext context, Map<String, Object> product, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              productId: product['id'].toString(),
              productName: product['title'].toString(),
              price: product['price'].toString(),
              imagePath: product['imageUrl'].toString(),
              companyName: product['company'].toString(),
              sizes: product['sizes'] as List<int>,
            ),
          ),
        );
      },
      child: ProductCard(
        title: product['title'].toString(),
        price: product['price'].toString(),
        imagePath: product['imageUrl'].toString(),
        backgroundColor: index.isEven
            ? const Color.fromRGBO(216, 240, 253, 1)
            : const Color.fromRGBO(245, 247, 249, 1),
      ),
    );
  }

  // Returns the GridView content card
  GestureDetector gridViewContent(
      BuildContext context, Map<String, Object> product, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              productId: product['id'].toString(),
              productName: product['title'].toString(),
              price: product['price'].toString(),
              imagePath: product['imageUrl'].toString(),
              companyName: product['company'].toString(),
              sizes: product['sizes'] as List<int>,
            ),
          ),
        );
      },
      child: ProductCard(
        title: product['title'].toString(),
        price: product['price'].toString(),
        imagePath: product['imageUrl'].toString(),
        backgroundColor: index.isEven
            ? const Color.fromRGBO(216, 240, 253, 1)
            : const Color.fromRGBO(245, 247, 249, 1),
      ),
    );
  }
}
