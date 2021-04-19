import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final int quantity;

  const Product(
      {@required this.name, @required this.quantity, @required this.price});
}

typedef void CartChangedCallback(Product product);

class ShoppingListItem extends StatelessWidget {
  final Product product;
  final int priceProduct;
  final int quantityProduct;
  final inCart;
  final CartChangedCallback onCartChanged;

  ShoppingListItem(
      {@required this.product,
      @required this.inCart,
      @required this.onCartChanged,
      @required this.priceProduct,
      @required this.quantityProduct});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      leading: CircleAvatar(
        backgroundColor: Colors.amber,
        child: Text(product.name[0]),
      ),
      onTap: () {
        onCartChanged(product);
      },
    );
  }
}
