import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

//หน้า Register ร้านอาหาร
class ResRegisterPage extends StatefulWidget {
  const ResRegisterPage({super.key});

  @override
  State<ResRegisterPage> createState() => _ResRegisterPageState();
}

class _ResRegisterPageState extends State<ResRegisterPage> {
  // text field state
  String restaurantName = '';
  String email = '';
  String password = '';
  String phone = '';
  String address = '';
  String latitude = '';
  String longitude = '';
  String branch = '';
  File? logo;

  @override
  Widget build(BuildContext context) {
    //ใช้เพื่อ add image ตรง logo
    Future getImage() async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.logo = imageTemporary;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.cyan,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),

          //เป็น form แบบเลื่อนลง
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Restaurant Name',
                              ),
                              // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                              onChanged: (val) {
                                setState(() => restaurantName = val);
                              },
                            ),
                            SizedBox(height: 20.0),
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
                            TextFormField(
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
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Address',
                              ),
                              // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                              onChanged: (val) {
                                setState(() => address = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Latitude',
                              ),
                              // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                              onChanged: (val) {
                                setState(() => latitude = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Longitude',
                              ),
                              // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                              onChanged: (val) {
                                setState(() => longitude = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Branch',
                              ),
                              // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                              onChanged: (val) {
                                setState(() => branch = val);
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            logo != null
                                ? Image.file(
                                    logo!,
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/img/quickqueue.jpg',
                                    scale: 5,
                                  ),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomButton(
                              title: 'Add Logo Image',
                              icon: Icons.image_outlined,
                              onClick: getImage,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.green,
                                // elevation: 3,
                                minimumSize: Size(280, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                              child: const Text('Register',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                              onPressed: () {
                                //** ใส่ที่จะบันทึกข้อมูล */
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    height: 50,
    width: 200,
    child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        )),
  );
}
