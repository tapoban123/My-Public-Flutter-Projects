import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart_provider.dart';

/*
This page defines the product details page, which is displayed when any item is tapped.
 */
class ProductDetailsPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String price;
  final String imagePath;
  final String companyName;
  final List<int> sizes;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.imagePath,
    required this.companyName,
    required this.sizes,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late int selectedSize;

  @override
  void initState() {
    selectedSize = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Details"),
            centerTitle: true,
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.productName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    widget.imagePath,
                    height: 250,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: const Color.fromRGBO(245, 247, 249, 1),
                  ),
                  // height: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$ ${widget.price}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.sizes.length,
                            itemBuilder: (context, index) {
                              int size = widget.sizes[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Function to select the size of the shoes
                                    setState(() {
                                      selectedSize = widget.sizes[index];
                                    });
                                  },
                                  child: Chip(
                                    backgroundColor: selectedSize == size
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                    label: Text(
                                      size.toString(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedSize != 0) {
                              final cartItem = {
                                'id': widget.productId,
                                'title': widget.productName,
                                'price': widget.price,
                                'imagUrl': widget.imagePath,
                                'company': widget.companyName,
                                'size': selectedSize,
                              };

                              // SnackBar displayed when the item is successfully added to cart
                              cartProvider.addToCart(cartItem);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Item added to cart successfully."),
                                ),
                              );
                            } else {
                              // SnackBar displayed when no size if selected
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please select a size before adding to cart"),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            fixedSize: const Size(350, 50),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
