import 'package:flutter/material.dart';
import 'package:iot_lab5/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot_lab5/shoppingList.dart';
import 'package:iot_lab5/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

void _pushPage(BuildContext context, Widget page) {
  Navigator.of(context) /*!*/ .push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}

class _EditProfileState extends State<EditProfile> {
  int checker = 0;
  int _selectedIndex = 0;
  final TextEditingController textFieldController = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  final TextEditingController textFieldController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(hintText: "Name"),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  Colors.amber,
                )),
                onPressed: () async {
                  setState(() {
                    var user = FirebaseAuth.instance.currentUser;
                    user.updateProfile(displayName: textFieldController.text);
                    UserModel.updateCurrentUser(UserModel(
                        email: user.email,
                        id: user.uid,
                        name: textFieldController.text));
                  });
                  _pushPage(context, MyApp());
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
