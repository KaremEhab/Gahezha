import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:iconly/iconly.dart';

class ProductImagesCarousel extends StatefulWidget {
  final List<String> productImages;
  const ProductImagesCarousel({super.key, required this.productImages});

  @override
  State<ProductImagesCarousel> createState() => _ProductImagesCarouselState();
}

class _ProductImagesCarouselState extends State<ProductImagesCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < widget.productImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.productImages == null || widget.productImages.isEmpty
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  child: Center(child: Icon(IconlyBroken.image, size: 50)),
                )
              : PageView.builder(
                  controller: _pageController,
                  itemCount: widget.productImages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final imageUrl = widget.productImages[index];
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                ),

          // Left arrow (only if not first page)
          if (_currentPage > 0)
            Positioned(
              right: lang == 'ar' ? 8 : null,
              left: lang == 'en' ? 8 : null,
              child: _ArrowButton(
                icon: Icons.arrow_back_ios_new,
                onTap: _prevPage,
              ),
            ),

          // Right arrow (only if not last page)
          if (_currentPage < widget.productImages.length - 1)
            Positioned(
              right: lang == 'en' ? 8 : null,
              left: lang == 'ar' ? 8 : null,
              child: _ArrowButton(
                icon: Icons.arrow_forward_ios,
                onTap: _nextPage,
              ),
            ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
