import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';

/*
This page defines the UI screen where the shopping cart is displayed.
*/
class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            // Returns a "No items in cart" message when the cart is empty.
            if (cartProvider.getCartItems.isEmpty) {
              return Center(
                child: Text(
                  "No items in Cart",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            // Returns a ListView when the cart contains some items chosen by the customer.
            return ListView.builder(
              itemCount: cartProvider.getCartItems.length,
              itemBuilder: (context, index) {
                final Map cartItem = cartProvider.getCartItems[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(cartItem['imagUrl'] as String),
                    radius: 30,
                  ),
                  title: Text(
                    cartItem['title'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  subtitle: Text("Size: ${cartItem['size']}"),
                  trailing: IconButton(
                    onPressed: () {
                      // Displays a dialog box for the confirmation of deletion of items from the cart.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Delete Product",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          content: const Text(
                            "Are you sure you want to remove the product from your cart?",
                          ),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                // The following property allows us to change the onHover color of the TextButton
                                overlayColor: MaterialStateProperty.all(
                                    Colors.blue.shade100),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.red.shade100),
                              ),
                              onPressed: () {
                                // Removes the item from the cart.
                                cartProvider.removeFromCart(
                                    cartItem as Map<String, Object>);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Item removed from cart."),
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
