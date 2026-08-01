class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.isAvailable,
  });

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, '
        'category: $category, isAvailable: $isAvailable)';
  }
}

void printResult(String title, Object result) {
  print('\n$title');
  print('-' * 45);
  print(result);
}

void main() {
  final List<Product> products = [
    const Product(
      id: 1,
      name: 'Gaming Laptop',
      price: 35000,
      category: 'Electronics',
      isAvailable: true,
    ),
    const Product(
      id: 2,
      name: 'Flutter Development Book',
      price: 650,
      category: 'Education',
      isAvailable: true,
    ),
    const Product(
      id: 3,
      name: 'Wireless Headphones',
      price: 2500,
      category: 'Electronics',
      isAvailable: false,
    ),
    const Product(
      id: 4,
      name: 'Coffee Pack',
      price: 300,
      category: 'Food',
      isAvailable: true,
    ),
    const Product(
      id: 5,
      name: 'Smartphone',
      price: 22000,
      category: 'Electronics',
      isAvailable: true,
    ),
  ];

  final availableProducts = products
      .where((product) => product.isAvailable)
      .toList();

  final productNames = products
      .map((product) => product.name)
      .toList();

  final availableElectronicsNames = products
      .where(
        (product) =>
            product.isAvailable &&
            product.category == 'Electronics',
      )
      .map((product) => product.name)
      .toList();

  final totalPrice = products.fold<double>(
    0,
    (total, product) => total + product.price,
  );

  final availableProductsTotal = products
      .where((product) => product.isAvailable)
      .fold<double>(
        0,
        (total, product) => total + product.price,
      );

  final hasProductAboveTwentyThousand = products.any(
    (product) => product.price > 20000,
  );

  final allProductsHaveValidPrices = products.every(
    (product) => product.price > 100,
  );

  final firstElectronicsProduct = products.firstWhere(
    (product) => product.category == 'Electronics',
  );

  final sortedProducts = [...products]
    ..sort(
      (firstProduct, secondProduct) =>
          firstProduct.price.compareTo(secondProduct.price),
    );

  final categories = [
    'Electronics',
    'Education',
    'Electronics',
    'Food',
  ];

  final uniqueCategories = categories.toSet();

  printResult('Available Products', availableProducts);
  printResult('Product Names', productNames);
  printResult(
    'Available Electronics Products',
    availableElectronicsNames,
  );
  printResult(
    'Total Price',
    '${totalPrice.toStringAsFixed(2)} EGP',
  );
  printResult(
    'Available Products Total',
    '${availableProductsTotal.toStringAsFixed(2)} EGP',
  );
  printResult(
    'Any Product Above 20,000 EGP',
    hasProductAboveTwentyThousand,
  );
  printResult(
    'All Products Above 100 EGP',
    allProductsHaveValidPrices,
  );
  printResult(
    'First Electronics Product',
    firstElectronicsProduct,
  );
  printResult('Products Sorted by Price', sortedProducts);
  printResult('Unique Categories', uniqueCategories);
}
