import 'package:flutter/material.dart';
import 'package:quickqueue/services/userRegister.dart';

//หน้า Sign up ลูกค้า
class CusSignUpPage extends StatefulWidget {
  const CusSignUpPage({super.key});

  @override
  State<CusSignUpPage> createState() => _CusSignUpPageState();
}

class _CusSignUpPageState extends State<CusSignUpPage> {
  // text field state
  String firstname = '';
  String lastname = '';
  String phone = '';
  String email = '';
  String password = '';

  //ใช้ check textformfiled
  final _formKey = GlobalKey<FormState>();

  UserRegisterService registerService = UserRegisterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 40, color: Colors.cyan),
                  )),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your firstname';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Firstname',
                          ),
                          // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                          onChanged: (val) {
                            setState(() => firstname = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your lastname';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Lastname',
                          ),
                          // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                          onChanged: (val) {
                            setState(() => lastname = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Phone',
                          ),
                          // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                          onChanged: (val) {
                            setState(() => phone = val);
                          },
                        ),
                        SizedBox(height: 20.0),
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
                              return 'Please enter your password';
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
                            minimumSize: Size(160, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          child: const Text('Sign In',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                registerService
                                    .registerCustomerWithEmailAndPassword(email,
                                        firstname, lastname, password, phone);
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Sucess'),
                                    content: const Text(
                                        'Your account has been successfully created.'),
                                  ),
                                );
                              } catch (e) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Error'),
                                          content: Text("Error : $e"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));
                              }
                            }

                            // alert แจ้งเตือนบันทึกสำเร็จ ใช้ได้ค่อยเปิด
                            // showDialog<String>(
                            //   context: context,
                            //   builder: (BuildContext context) => AlertDialog(
                            //     title: const Text('Sucess'),
                            //     content: const Text('Your account has been successfully created.'),
                            //   ),
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]))),
            ],
          ),
        ));
  }
}
