import 'package:flutter/material.dart';

/* 
The following provider contains methods for adding or removing items from the cart.

The notifyListeners() method notifies all the widgets that are listening to this provider, or,
in simple words, it updates the UI of the cart whenever any item is added or removed.
*/
class CartProvider extends ChangeNotifier {
  final List<Map<String, Object>> _cartItems = [];

  // Method for adding items to the cart
  void addToCart(Map<String, Object> cartItem) {
    _cartItems.add(cartItem);
    
    notifyListeners();
  }

  // Method for removing items from the cart
  void removeFromCart(Map<String, Object> cartItem) {
    _cartItems.remove(cartItem);

    notifyListeners();
  }

  // Returns the list of cart items
  List<Map<String, Object>> get getCartItems => _cartItems;
}
