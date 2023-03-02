import 'package:flutter/material.dart';
import 'package:quickqueue/pages/resMainpage.dart';

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
  //ตัวแปร
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(20, 180, 20, 20),
              child: Text(
                "Quick Queue",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.cyan,
                    fontWeight: FontWeight.w500),
              )),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Form(
                    child: Column(children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                          ),
                          labelText: 'Email',
                        ),
                        // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                          ),
                          labelText: 'Password',
                        ),
                        // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.green,
                          // elevation: 3,
                          minimumSize: Size(280, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        child: const Text('Log In',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        onPressed: () {
                          //** ใส่ที่จะ check ข้อมูล */
                          // alert แจ้งเตือนใส่ email/password ผิด
                          // showDialog<String>(
                          //   context: context,
                          //   builder: (BuildContext context) => AlertDialog(
                          //     title: const Text('Incorrect email or password'),
                          //     content: const Text('Your email and password do not match. Please try again.'),
                          //   ),
                          // );
                          
                          // ไปหน้า Customer
                          //  Navigator.of(context).push(MaterialPageRoute(
                          // builder: (context) => CusChooseResPage()));

                          // ไปหน้า Restaurant
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResMainPage()));
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.green,
                          // elevation: 3,
                          minimumSize: Size(280, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        child: const Text('Sign Up',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        onPressed: () {
                          //** ใส่ที่จะ check ข้อมูล */
                           Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CusSignUpPage()));
                          
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          
                           Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResRegisterPage()));
                        },
                        child: Text(
                          'or Register for Restaurant ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    ));
  }
}

// navigateToCusChooseResPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return CusChooseResPage();
//   }));
// }

// navigateToCusSignUpPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return CusSignUpPage();
//   }));
// }

// navigateToResRegisterPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return ResRegisterPage();
//   }));
// }
