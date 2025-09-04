import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/public_widgets/cached_images.dart';

class ProductDetailsSheet extends StatefulWidget {
  final String productName;
  final String productImage;
  final double productPrice;
  final String description;

  const ProductDetailsSheet({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.description,
  });

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {
  int quantity = 1;

  // ---------- Radio Example: Sizes ----------
  String selectedSize = "Medium";

  // ---------- Checkboxes Example: Add-ons ----------
  Map<String, bool> addOns = {
    "Extra Cheese": false,
    "Gift Wrap": false,
    "Spicy": false,
  };

  void increase() {
    setState(() {
      quantity++;
    });
  }

  void decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, controller) => Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- IMAGE ----------
              Stack(
                children: [
                  CustomCachedImage(imageUrl: widget.productImage, height: 260),
                  Positioned(
                    top: 8,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadiusDirectional.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ---------- DETAILS ----------
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ---------- PRICE ----------
                    Text(
                      "\$${widget.productPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------- SIZE OPTIONS (RADIO) ----------
                    const Text(
                      "Choose Size",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Column(
                      children: ["Small", "Medium", "Large"]
                          .map(
                            (size) => RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(size),
                              value: size,
                              groupValue: selectedSize,
                              onChanged: (value) {
                                setState(() {
                                  selectedSize = value!;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    // ---------- ADD-ONS (CHECKBOX) ----------
                    const Text(
                      "Add Extras",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Column(
                      children: addOns.keys.map((addon) {
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(addon),
                          value: addOns[addon],
                          onChanged: (value) {
                            setState(() {
                              addOns[addon] = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ---------- COUNTER + ADD TO CART ----------
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Counter
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: decrease,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: increase,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Add to Cart Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Example: collect selected options
                      final selectedAddOns = addOns.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();

                      debugPrint("Added to cart:");
                      debugPrint("Quantity: $quantity");
                      debugPrint("Size: $selectedSize");
                      debugPrint("Extras: $selectedAddOns");

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Add $quantity to Cart",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
