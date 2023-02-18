import 'package:flutter/material.dart';

import 'cusChooseResPage.dart';

//หน้า login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Text(
                    "Quick Queue",
                    style: TextStyle(fontSize: 40, color: Colors.cyan),
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Log In',style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      navigateToCusChooseResPage(context);
                    },
                  )),
              Container(
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Sign In',style: TextStyle(color: Colors.white)),
                    onPressed: () {
                     
                    },
                  )),
              TextButton(
                onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(content: Text(myController.text),
                        );
                      });
                },
                child: Text(
                  'or Register for Restaurant ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ));
  }
}

navigateToCusChooseResPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusChooseResPage();
  }));
}



