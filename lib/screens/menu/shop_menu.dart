import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/product/product_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/public_widgets/shimmer_box.dart';
import 'package:gahezha/screens/products/customer/widgets/product_details_sheet.dart';
import 'package:gahezha/screens/products/shop/add_products.dart';
import 'package:gahezha/screens/products/shop/edit_products.dart';
import 'package:iconly/iconly.dart';

class ShopMenuPage extends StatefulWidget {
  const ShopMenuPage({super.key});

  @override
  State<ShopMenuPage> createState() => _ShopMenuPageState();
}

class _ShopMenuPageState extends State<ShopMenuPage> {
  bool display = false;
  @override
  void initState() {
    super.initState();
    ProductCubit.instance.getAllProductsByShopId(uId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
          display = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.current.shop_menu),
            backgroundColor: Colors.white,
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
          ),
          body: ProductCubit.instance.allProducts.isEmpty
              ? Center(child: Text(S.current.no_products_yet))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 80),
                  itemCount: display
                      ? 5
                      : ProductCubit.instance.allProducts.length,
                  itemBuilder: (context, index) {
                    final product = ProductCubit.instance.allProducts[index];
                    return ProductCard(
                      product: display ? null : product,
                      isLoading: display,
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryBlue,
            shape: CircleBorder(),
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage()),
              );
            },
          ),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel? product; // nullable for loading
  final bool isLoading;

  const ProductCard({super.key, this.product, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading || product == null) {
      // Shimmer placeholder
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: const ShimmerBox(width: 56, height: 56, borderRadius: 8),
        title: const ShimmerBox(width: double.infinity, height: 16),
        subtitle: const ShimmerBox(width: double.infinity, height: 12),
        trailing: const ShimmerBox(width: 50, height: 16),
      );
    }

    // Actual ProductCard
    return Slidable(
      key: ValueKey(product!.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (c) {
              ProductCubit.instance.deleteProductById(product!.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product!.name} ${S.current.deleted}"),
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: IconlyLight.delete,
            label: S.current.delete,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (c) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProductPage(product: product!),
                ),
              );
            },
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: S.current.edit,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(sheetRadius),
              ),
            ),
            builder: (_) => ProductDetailsSheet(
              isShopOpen: currentShopModel!.shopStatus,
              productModel: product!,
              shopName: currentShopModel!.shopName,
              shopLogo: currentShopModel!.shopLogo,
              shopPhone: currentShopModel!.shopPhoneNumber,
              preparingTimeFrom: currentShopModel!.preparingTimeFrom,
              preparingTimeTo: currentShopModel!.preparingTimeTo,
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: product!.images.isEmpty
            ? Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: const Center(child: Icon(IconlyBroken.image, size: 30)),
              )
            : CustomCachedImage(
                imageUrl: product!.images.first,
                borderRadius: BorderRadius.circular(radius),
                width: 56,
                height: 56,
              ),
        title: Text(
          product!.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          product!.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          "${S.current.sar} ${product!.price.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
