import 'package:flutter/material.dart';

import 'cusChooseResPage.dart';
import 'cusSignupPage.dart';
import 'resRegisterPage.dart';

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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    "Quick Queue",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.cyan,
                        fontWeight: FontWeight.w500),
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
              SizedBox(
                height: 40,
              ),
              Container(
                  height: 60,
                  // padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(280, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    child: const Text('Log In',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () {
                      navigateToCusChooseResPage(context);
                    },
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                // padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    
                    minimumSize: Size(280,5),
                    shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(32.0)
                    ),
                  ),
                  child: const Text('Sign In',
                      style: TextStyle(color: Colors.cyan, fontSize: 18)),
                  onPressed: () {
                    navigateToCusSignUpPage(context);
                  },
                ),

              ),
              TextButton(
                onPressed: () {
                  navigateToResRegisterPage(context);
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

navigateToCusSignUpPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusSignUpPage();
  }));
}

navigateToResRegisterPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ResRegisterPage();
  }));
}
