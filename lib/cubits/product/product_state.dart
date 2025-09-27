part of 'product_cubit.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final ProductModel product;
  ProductLoaded(this.product);
}

class AllProductsLoaded extends ProductState {
  final List<ProductModel> products;
  AllProductsLoaded(this.products);
}

class ProductSuccess extends ProductState {
  final String message;
  ProductSuccess(this.message);
}

class ProductFailure extends ProductState {
  final String error;
  ProductFailure(this.error);
}

/// ✅ Create Product States
class ProductCreatedLoading extends ProductState {}

class ProductCreatedSuccessfully extends ProductState {
  final List<ProductModel> allProducts; // updated list
  ProductCreatedSuccessfully(this.allProducts);
}

class ProductCreatedFailure extends ProductState {
  final String error;
  ProductCreatedFailure(this.error);
}

/// ✅ Delete Product States
class ProductDeletedLoading extends ProductState {}

class ProductDeletedSuccessfully extends ProductState {
  final List<ProductModel> allProducts; // updated list
  ProductDeletedSuccessfully(this.allProducts);
}

class ProductDeletedFailure extends ProductState {
  final String error;
  ProductDeletedFailure(this.error);
}

/// ✅ Edit Product States
class ProductEditedLoading extends ProductState {}

class ProductEditedSuccessfully extends ProductState {
  final String message; // updated list
  ProductEditedSuccessfully(this.message);
}

class ProductEditedFailure extends ProductState {
  final String error;
  ProductEditedFailure(this.error);
}
