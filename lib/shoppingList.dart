import 'package:flutter/material.dart';
import 'package:iot_lab5/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';



final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shopping List',
      theme: ThemeData(
        primaryColor: Colors.amber,
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'My Shopping List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int checker = 0;
  int _selectedIndex = 0;
  final TextEditingController textFieldController = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  final TextEditingController textFieldController3 = TextEditingController();
  List<Product> shoppingList = [];
  List<Product> favs = [];
  final User user = _auth.currentUser;



  @override
  Widget build(BuildContext context) {
    favs = favs.toSet().toList();
    final String email = user.email;
    final String UID = user.uid;
    const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    List<Widget> _widgetOptions = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Image.asset(
                "images/1560.png",
                width: 50,
                height: 50,
              ),
              Text(
                "Products you have to buy",
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ],

          ),

          Expanded(
            child: ListView.builder(
              itemCount:shoppingList.length,
              itemBuilder: (context, index) {
                checker = shoppingList.length;
                return Dismissible(
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
                  key: Key(shoppingList[index].toString()),
                  child: ShoppingListItem(
                    product: shoppingList[index],
                    priceProduct: shoppingList[index].price,
                    quantityProduct: shoppingList[index].quantity,
                    inCart: shoppingList.contains(shoppingList[index]),
                    onCartChanged: onCartChanged,
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        shoppingList.removeAt(index);
                      });
                      return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Done"),
                          content: Text("Item deleted!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                        ),
                      );
                    } else {
                      setState(() {
                        favs.add(shoppingList[index]);
                      });
                      return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Done"),
                          content: Text("Item added to favourites"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Text(
            email,
          ),
          Text(
            UID,
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Image.asset(
                "images/1560.png",
                width: 50,
                height: 50,
              ),
              Text(
                "Your favourite products",
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ],
          ),

          Expanded(
            child: ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, index) {
                return Card(
                  key: Key(favs[index].toString()),
                  child: ShoppingListItem(
                    product: favs[index],
                    priceProduct: favs[index].price,
                    quantityProduct: favs[index].quantity,
                    inCart: favs.contains(favs[index]),
                    onCartChanged: onCartChanged,
                  ),
                );
              },
            ),
          ),
          Text(
            email,
          ),
          Text(
            UID,
          )
        ],
      ),


    ];
    void _onItemTapped(int index) {
      setState(() {

        _selectedIndex = index;

      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: _widgetOptions.elementAt(_selectedIndex)

          ),),

      floatingActionButton: FloatingActionButton(
        onPressed: () => displayDialog(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourites',
            backgroundColor: Colors.red,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Future<AlertDialog> displayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add a new product to your list",
                textAlign: TextAlign.center),
            content: Column(
              children: [
                TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(hintText: "Product Name"),
                ),
                TextField(
                  controller: textFieldController2,
                  decoration: InputDecoration(hintText: "Product amount"),
                ),
                TextField(
                  controller: textFieldController3,
                  decoration: InputDecoration(hintText: "Product price"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (textFieldController.text.trim() != "" &&
                      isNumericUsing_tryParse(textFieldController2.text) &&
                      isNumericUsing_tryParse(textFieldController3.text)) {
                    setState(() {
                      shoppingList.add(
                        Product(
                          name: textFieldController.text,
                          price: int.parse(textFieldController2.text),
                          quantity: int.parse(textFieldController3.text),
                        ),
                      );
                    });
                  }
                  textFieldController.clear();
                  textFieldController2.clear();
                  textFieldController3.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Save"),
              ),
              TextButton(
                onPressed: () {
                  textFieldController.clear();
                  textFieldController2.clear();
                  textFieldController3.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        });
  }

  void onCartChanged(Product product) {
    setState(() {
      showDialog(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.fromLTRB(10, 130, 10, 130),
          child: AlertDialog(
            title: Text("Done"),
            content: Column(
              children: [
                Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  product.price.toString() + "\$",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "Quantity",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  product.quantity.toString() + "piece(s)",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            Text(
              " Add to favourites",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  bool isNumericUsing_tryParse(String string) {
    // Null or empty string is not a number
    if (string == null || string.isEmpty) {
      return false;
    }

    // Try to parse input string to number.
    // Both integer and double work.
    // Use int.tryParse if you want to check integer only.
    // Use double.tryParse if you want to check double only.
    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }
}
