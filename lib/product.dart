import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final int quantity;

  const Product(
      {@required this.name, @required this.quantity, @required this.price});

  factory Product.fromJson(Map<String, dynamic> parsedJson){
    return new Product(
      name: parsedJson['name'] ?? '',
      quantity: parsedJson['quantity'] ?? '',
      price: parsedJson['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'name': this.name,
      'quantity': this.quantity,
      'price' : this.price
    };
  }

  static Future<Product> saveProduct(Product product) async{
    return await FirebaseFirestore.instance.collection('products').doc(product.name).set(product.toJson()).then((value){ return  product;});
  }

  static Future<Product> saveProductFav(Product product) async{
    return await FirebaseFirestore.instance.collection('productsFav').doc(product.name).set(product.toJson()).then((value){ return  product;});
  }


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
