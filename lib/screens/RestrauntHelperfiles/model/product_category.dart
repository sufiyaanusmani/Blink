class ProductCategory {
  ProductCategory({
    required this.category,
    required this.products,
  });

  final String category;
  final List<Product> products;
}

class Product {
  final String name;
  final String description;
  final String price;
  final String image;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}
