import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  late List<String> _images;
  late List<Map<String, List<Map<String, dynamic>>>> _specifications;
  late List<Map<String, dynamic>> _addOns;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );

    _images = List.from(widget.product.images);
    _specifications = List.from(widget.product.specifications);
    _addOns = List.from(widget.product.selectedAddOns);
  }

  void _addImage() {
    setState(() {
      _images.add(
        "https://via.placeholder.com/200",
      ); // Mock placeholder (replace with picker later)
    });
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void _addSpecification() {
    setState(() {
      _specifications.add({
        "New Spec": [
          {"name": "Option 1", "price": 0.0},
          {"name": "Option 2", "price": 0.0},
        ],
      });
    });
  }

  void _removeSpecification(int index) {
    setState(() => _specifications.removeAt(index));
  }

  void _addAddOn() {
    setState(() {
      _addOns.add({"name": "New Add-On", "price": 0.0});
    });
  }

  void _removeAddOn(int index) {
    setState(() => _addOns.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          forceMaterialTransparency: true,
          elevation: 0,
          title: const Text("Edit Product"),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // ---------------- Images ----------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Images",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_images.isNotEmpty)
                          GestureDetector(
                            onTap: _addImage,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: primaryBlue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsetsGeometry.directional(
                              end: _images.length == 1 ? 0 : 5,
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: _images[index],
                                    width: _images.length == 1
                                        ? MediaQuery.sizeOf(context).width *
                                              0.95
                                        : 250,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 180,
                      child: ElevatedButton(
                        onPressed: () => _addImage(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide.none,
                          ),
                        ),
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              IconlyLight.image,
                              size: 60,
                              color: primaryBlue,
                            ),
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: primaryBlue),
                                const Text(
                                  "Add your product's images",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 30),

              // ---------------- Basic Info ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      title: "Product Name",
                      hint: "Enter product's name",
                      icon: IconlyLight.document,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _descriptionController,
                      title: "Product Description",
                      hint: "Enter product's description",
                      icon: IconlyLight.document,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _priceController,
                      title: "Product Price",
                      hint: "Enter product's price",
                      icon: Icons.monetization_on_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _quantityController,
                      title: "Product Quantity",
                      hint: "Enter product's quantity",
                      icon: IconlyLight.bag,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // ---------------- Specifications ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Specifications",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_specifications.isNotEmpty)
                          GestureDetector(
                            onTap: _addSpecification,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: primaryBlue,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      children: _specifications.asMap().entries.map((entry) {
                        int specIndex = entry.key;
                        Map<String, List<Map<String, dynamic>>> spec =
                            entry.value;
                        String specName = spec.keys.first;
                        List<Map<String, dynamic>> options = spec.values.first;

                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Editable Spec Name + Delete whole spec
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            initialValue: specName,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Enter specification name",
                                              prefixIcon: Icon(
                                                IconlyLight.bookmark,
                                                color: primaryBlue,
                                              ),
                                              filled: true,
                                              fillColor: primaryBlue
                                                  .withOpacity(0.04),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                    horizontal: 12,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _specifications[specIndex] = {
                                                  value: options,
                                                };
                                              });
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              _removeSpecification(specIndex),
                                          icon: Icon(
                                            IconlyLight.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Options
                              Wrap(
                                spacing: 6,
                                children: options.asMap().entries.map((
                                  optEntry,
                                ) {
                                  int optIndex = optEntry.key;
                                  Map<String, dynamic> opt = optEntry.value;

                                  return GestureDetector(
                                    onDoubleTap: () async {
                                      final nameController =
                                          TextEditingController(
                                            text: opt["name"],
                                          );
                                      final priceController =
                                          TextEditingController(
                                            text: opt["price"].toString(),
                                          );

                                      Map<String, dynamic>?
                                      newValue = await showDialog<Map<String, dynamic>>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Edit Option"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: nameController,
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText:
                                                            "Enter option name",
                                                        labelText: "Name",
                                                      ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextField(
                                                  controller: priceController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: const InputDecoration(
                                                    hintText:
                                                        "Enter extra price (0 for none)",
                                                    labelText: "Extra Price",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryBlue,
                                                ),
                                                onPressed: () {
                                                  final name = nameController
                                                      .text
                                                      .trim();
                                                  final price =
                                                      double.tryParse(
                                                        priceController.text
                                                            .trim(),
                                                      ) ??
                                                      0.0;

                                                  if (name.isNotEmpty) {
                                                    Navigator.pop(context, {
                                                      "name": name,
                                                      "price": price,
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (newValue != null) {
                                        setState(() {
                                          options[optIndex] = newValue;
                                          _specifications[specIndex] = {
                                            specName: options,
                                          };
                                        });
                                      }
                                    },
                                    child: InputChip(
                                      deleteIconColor: Colors.red,
                                      label: Text(
                                        opt["price"] != null && opt["price"] > 0
                                            ? "${opt["name"]} (+\$${opt["price"]})"
                                            : opt["name"],
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          options.removeAt(optIndex);
                                          _specifications[specIndex] = {
                                            specName: options,
                                          };
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 8),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      options.add({
                                        "name": "New Option",
                                        "price": 0.0,
                                      });
                                      _specifications[specIndex] = {
                                        specName: options,
                                      };
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade100,
                                    foregroundColor: Colors.black87,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide.none,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.add,
                                    color: primaryBlue,
                                  ),
                                  label: const Text(
                                    "Add Option",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    if (_specifications.isEmpty) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _addSpecification(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide.none,
                            ),
                          ),
                          icon: const Icon(Icons.add, color: primaryBlue),
                          label: const Text(
                            "Add Specification",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ---------------- Add-ons ----------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Add-ons",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_addOns.isNotEmpty)
                          GestureDetector(
                            onTap: _addAddOn,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: primaryBlue,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      children: _addOns.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> addOn = entry.value;

                        return GestureDetector(
                          onDoubleTap: () async {
                            final nameController = TextEditingController(
                              text: addOn["name"],
                            );
                            final priceController = TextEditingController(
                              text: addOn["price"].toString(),
                            );

                            final newValue =
                                await showDialog<Map<String, dynamic>>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Edit Add-On"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                              labelText: "Name",
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          TextField(
                                            controller: priceController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: "Extra Price",
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryBlue,
                                          ),
                                          onPressed: () {
                                            final name = nameController.text
                                                .trim();
                                            final price =
                                                double.tryParse(
                                                  priceController.text.trim(),
                                                ) ??
                                                0.0;

                                            if (name.isNotEmpty) {
                                              Navigator.pop(context, {
                                                "name": name,
                                                "price": price,
                                              });
                                            }
                                          },
                                          child: const Text(
                                            "Save",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                            if (newValue != null) {
                              setState(() => _addOns[index] = newValue);
                            }
                          },
                          child: InputChip(
                            deleteIconColor: Colors.red,
                            label: Text(
                              addOn["price"] != null && addOn["price"] > 0
                                  ? "${addOn["name"]} (+\$${addOn["price"]})"
                                  : addOn["name"],
                            ),
                            onDeleted: () => _removeAddOn(index),
                          ),
                        );
                      }).toList(),
                    ),
                    if (_addOns.isEmpty) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _addAddOn(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide.none,
                            ),
                          ),
                          icon: const Icon(Icons.add, color: primaryBlue),
                          label: const Text(
                            "Add Add-ons",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // ---------------- Save Button ----------------
        bottomNavigationBar: SafeArea(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedProduct = ProductModel(
                    id: widget.product.id,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    price: double.tryParse(_priceController.text) ?? 0.0,
                    quantity: int.tryParse(_quantityController.text) ?? 0,
                    specifications: _specifications,
                    selectedAddOns: _addOns,
                    images: _images,
                  );
                  Navigator.pop(context, updatedProduct);
                }
              },
              child: const Text(
                "Save Changes",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
