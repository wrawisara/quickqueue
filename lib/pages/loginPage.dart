import 'package:flutter/material.dart';
import 'package:quickqueue/pages/cusHomePage.dart';
import 'package:quickqueue/pages/resHomePage.dart';
import 'package:quickqueue/services/userAuthen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

final AuthenServices authenServices = AuthenServices();

class _LoginPageState extends State<LoginPage> {
  //ตัวแปร
  String email = '';
  String password = '';
  //ใช้ check textformfiled
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(20, 220, 20, 20),
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
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter you password';
                          }
                          return null;
                        },
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
                          child: const Text('Sign In',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print(email);
                              print(password);
                              await loginChecker(context, email, password);
                            }
                            child:
                            Text('Submit');
                          }),
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

Future<void> loginChecker(
    BuildContext context, String email, String password) async {
  try {
    String userType = await authenServices.getUserType(email, password);
    User? user = await authenServices.userSignInWithEmailAndPassword(
        email: email, password: password);
    if (user != null) {
      if (userType == 'customer') {
        print('Login Success');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CusHomePage()));
        //navigateToCusChooseResPage(context, user);
      } else if (userType == 'restaurant') {
        print('Login Success');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ResHomePage()));
        // go to restaurant page
      }
    }
  } on FirebaseAuthException catch (e) {
    print("Login error: ${e.message}");
    if (e.code == 'invalid-email' || e.code == 'wrong-password' || e.code =='too-many-requests' ) {
      print("Invalid email or password!");
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: Text(
                    "Your email or password is incorrect. Please try again."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
    if (e.code == 'user-not-found') {
      print("User not found!");
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: Text("You account doesn't exist. Please sign up."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } 
  }
}

// catch password มาจาก backend
//  on FirebaseAuthException catch (e) {
//                               print(e.message);
//                               showDialog<String>(
//                                 context: context,
//                                 builder: (BuildContext context) => AlertDialog(
//                                   title: const Text('Error'),
//                                   content: Text(
//                                       "You account doesn't exist. Please sign up."),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, 'OK'),
//                                       child: const Text('OK'),
//                                     ),
//                                   ],
//                                 ),
//                               );