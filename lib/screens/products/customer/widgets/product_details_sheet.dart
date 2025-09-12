import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/product/product_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/products/customer/widgets/images_carousel.dart';
import 'package:gahezha/screens/products/shop/edit_products.dart';
import 'package:iconly/iconly.dart';

class ProductDetailsSheet extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetailsSheet({super.key, required this.productModel});

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {
  int quantity = 1;
  bool extrasAreEmpty = false;

  // Store selected specification values (by option name)
  Map<String, String> selectedSpecs = {};

  // Store selected add-ons (by addon name)
  Map<String, bool> addOns = {};

  @override
  void initState() {
    super.initState();

    extrasAreEmpty =
        widget.productModel.specifications.isEmpty &&
        widget.productModel.selectedAddOns.isEmpty;

    // Initialize specifications (default to first option)
    for (var spec in widget.productModel.specifications) {
      final key = spec.keys.first;
      final values = spec[key] ?? [];
      if (values.isNotEmpty) {
        selectedSpecs[key] = values.first["name"] ?? "";
      }
    }

    // Initialize add-ons
    for (var addon in widget.productModel.selectedAddOns) {
      final addonName = addon["name"] ?? "";
      addOns[addonName] = false;
    }
  }

  void increase() => setState(() => quantity++);
  void decrease() => setState(() {
    if (quantity > 1) quantity--;
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.productModel.calculateTotalPrice(
      selectedSpecs: selectedSpecs,
      addOns: addOns,
      quantity: quantity,
    );
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: extrasAreEmpty ? 0.6 : 0.85,
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
                  ProductImagesCarousel(
                    productImages: widget.productModel.images,
                  ),
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
                      widget.productModel.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.productModel.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${S.current.sar} ${widget.productModel.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ---------- DYNAMIC SPECIFICATIONS ----------
                    if (widget.productModel.specifications.isNotEmpty) ...[
                      ...widget.productModel.specifications.map((spec) {
                        final key = spec.keys.first;
                        final values = spec[key] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ...values.map((value) {
                              final optionName = value["name"] ?? "";
                              final optionPrice =
                                  (value["price"] ?? 0.0) as double;

                              return RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        optionName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (optionPrice > 0)
                                      Text(
                                        "(+${S.current.sar} ${optionPrice.toStringAsFixed(2)})",
                                        style: const TextStyle(
                                          color: primaryBlue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                                value: optionName,
                                groupValue: selectedSpecs[key],
                                onChanged: (val) {
                                  setState(() {
                                    selectedSpecs[key] = val!;
                                  });
                                },
                              );
                            }),
                            const SizedBox(height: 12),
                          ],
                        );
                      }),
                    ],

                    // ---------- DYNAMIC ADD-ONS ----------
                    if (widget.productModel.selectedAddOns.isNotEmpty) ...[
                      Text(
                        S.current.add_extras,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ...widget.productModel.selectedAddOns.map((addon) {
                        final addonName = addon["name"] ?? "";
                        final addonPrice = (addon["price"] ?? 0.0) as double;

                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(addonName)),
                              if (addonPrice > 0)
                                Text(
                                  "(+${S.current.sar} ${addonPrice.toStringAsFixed(2)})",
                                  style: const TextStyle(
                                    color: primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                          value: addOns[addonName] ?? false,
                          onChanged: (value) {
                            setState(() {
                              addOns[addonName] = value!;
                            });
                          },
                        );
                      }),
                    ],
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
              spacing: 10,
              children: [
                // Counter
                Material(
                  color:
                      currentUserType == UserType.shop ||
                          currentUserType == UserType.admin
                      ? Colors.red.withOpacity(0.1)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: currentUserType == UserType.customer
                        ? null
                        : () {
                            Navigator.pop(context);
                            ProductCubit.instance.deleteProductById(
                              widget.productModel.id,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${widget.productModel.name} ${S.current.deleted}",
                                ),
                              ),
                            );
                          },
                    child: Container(
                      padding:
                          currentUserType == UserType.shop ||
                              currentUserType == UserType.admin
                          ? EdgeInsets.symmetric(horizontal: 25, vertical: 15)
                          : null,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            currentUserType == UserType.shop ||
                                currentUserType == UserType.admin
                            ? null
                            : Border.all(color: Colors.grey.shade300),
                      ),
                      child:
                          currentUserType == UserType.shop ||
                              currentUserType == UserType.admin
                          ? Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  IconlyBold.delete,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                Text(
                                  "Delete",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          : Row(
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
                  ),
                ),

                // Add to Cart Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (currentUserType == UserType.guest) {
                        Navigator.pop(
                          context,
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Create an account first"),
                              action: SnackBarAction(
                                label: "Sign Up",
                                textColor: primaryBlue,
                                onPressed: () {
                                  navigateTo(
                                    context: context,
                                    screen: Signup(isGuestMode: true),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      } else if (currentUserType == UserType.shop ||
                          currentUserType == UserType.admin) {
                        Navigator.pop(context);
                        navigateTo(
                          context: context,
                          screen: EditProductPage(product: widget.productModel),
                        );
                      } else {
                        Navigator.pop(context);
                        final selectedAddOnList = addOns.entries
                            .where((e) => e.value)
                            .map((e) => e.key)
                            .toList();

                        debugPrint("Added to cart:");
                        debugPrint("Quantity: $quantity");
                        debugPrint("Specifications: $selectedSpecs");
                        debugPrint("Add-ons: $selectedAddOnList");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 15,
                      ),
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      currentUserType == UserType.shop ||
                              currentUserType == UserType.admin
                          ? IconlyLight.edit
                          : Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    label: Text(
                      currentUserType == UserType.shop ||
                              currentUserType == UserType.admin
                          ? "Edit ${widget.productModel.name}"
                          : "Add to cart $totalPrice",
                      overflow: TextOverflow.ellipsis,
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
