class ProductCategory {
  ProductCategory({
    required this.category,
    required this.products,
  });

  final String category;
  final List<Product2> products;
}

class Product2 {
  final String name;
  final String description;
  final String price;
  final String image;

  Product2({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}
