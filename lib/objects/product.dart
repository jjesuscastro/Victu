class Product {
  String title = "";
  double price = 0;

  Product(this.title, this.price);

  Map<String, dynamic> toJson() {
    return {'title': title, 'price': price};
  }
}

Product createProduct(value) {
  Map<String, dynamic> attributes = {'title': '', 'price': 0};

  value.forEach((key, value) => {attributes[key] = value});

  Product product = Product(attributes['title'], attributes['price']);

  return product;
}
