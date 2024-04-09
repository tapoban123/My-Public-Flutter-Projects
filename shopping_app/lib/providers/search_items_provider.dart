import 'package:flutter/material.dart';
import 'package:shopping_app/global_variables.dart';

/* 
The following provider allows us to perform search operations on the items displayed.

It basically returns a list of filtered items whenever the searchTextField is changed.
Otherwise, it returns a the list of all items from the global_variables.dart file.
*/
class SearchItemsProvider extends ChangeNotifier {
  final List<Map<String, Object>> _foundItems = [];
  List<Map<String, Object>> _items = products;

  String _itemCompany = '';
  String _itemName = '';

  // The following method allows us to add or remove filtered items from the filtered list.
  void addOrRemoveFromFoundItems(String searchValue) {
    // Iterates over each Map present in the entire data list
    for (var item in products) {
      // The filtration will be done on the basis of itemTitles and itemCompanyNames
      _itemCompany = (item['company'] as String).toLowerCase();
      _itemName = (item['title'] as String).toLowerCase();

      // Checks if the searchValue matches with any itemData present in the dataSet
      if (_itemCompany.startsWith(searchValue) ||
          _itemName.startsWith(searchValue)) {
        /* If matches and the matched item is not already present in the dataset, then add the item
           to filteredDataList */
        if (_foundItems.contains(item) == false) {
          _foundItems.add(item);
        }
      } else {
        /* This else statement is reached when the searchValue does not match with 
           any itemData present in the dataSet and therefore, it checks if the item is already present
           in the foundItems. 
           If present, then removes it from the foundItemsList. */
        if (_foundItems.contains(item)) {
          _foundItems.remove(item);
        }
      }
    }
    // Finally, notifies all the listeners about the changes made in the filteredItemsList.
    notifyListeners();
  }

  // Returns the entire dataSet and notifies the listeners
  void returnAllItems() {
    _items = products;
    notifyListeners();
  }

  // Returns the filteredItemsList and notifies the listeners
  void returnFilteredItems() {
    _items = _foundItems;
    notifyListeners();
  }

  // Getter method to fetch the list of items: Filtered or All
  List<Map<String, Object>> get getItems => _items;
}
