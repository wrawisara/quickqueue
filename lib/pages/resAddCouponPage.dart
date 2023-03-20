import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/services/restaurantServices.dart';
import 'package:quickqueue/services/userRegister.dart';
import 'package:quickqueue/utils/horizontalLine.dart';
import 'package:quickqueue/widgets/customElevatedButton.dart';

class ResAddCouponPage extends StatefulWidget {
  const ResAddCouponPage({super.key});

  @override
  State<ResAddCouponPage> createState() => _ResAddCouponPageState();
}

class _ResAddCouponPageState extends State<ResAddCouponPage> {
  //ใช้ทำ tier dropdown
  final List<String> tierList = <String>['Bronze', 'Silver', 'Gold'];
  String? selectedValue;
  final _formKey = GlobalKey<FormState>();
  final RestaurantServices restaurantServices = RestaurantServices();

  //set unpress textfield
  bool couponMenu = true;
  bool couponDiscount = true;
  String couponType = 'Food Menu';

  //date picker
  late DateTime _expirationDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  // text field state
  String couponName = '';
  int requiredPoint = 0;
  String tier = '';
  // String date = '';
  String menu = '';
  double discount = 0;
  File? couponImage;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final RestaurantServices restaurantServices = RestaurantServices();
    //ใช้เพื่อ add image ตรง logo
    Future getImage() async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.couponImage = imageTemporary;
      });
    }

    var dropdownValue;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
        title: Text('Add Coupon', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              children: [
                Text(
                  "Coupon",
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 35.0, top: 20, bottom: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                labelText: 'Coupon Name',
                              ),
                              onChanged: (val) {
                                setState(() => couponName = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 35.0, top: 20, bottom: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                labelText: ('Required Points'),
                              ),
                              onChanged: (val) {
                                int newRqPoint = int.tryParse(val) ?? 0;

                                setState(() => requiredPoint = newRqPoint);
                              },
                            ),
                            SizedBox(height: 20.0),
                            DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              isExpanded: true,
                              hint: const Text(
                                'Select Tier',
                                style: TextStyle(fontSize: 17),
                              ),
                              items: tierList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                               onChanged: (value) {
                                setState(() {
                                  tier = value!;
                                });
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 60,
                                padding: EdgeInsets.only(left: 20, right: 10),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Coupon expiration date',
                                  hintText: 'Select Coupon expiration date ',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: Text(
                                  _expirationDate != null
                                      ? '${_expirationDate.day}/${_expirationDate.month}/${_expirationDate.year}'
                                      : '',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            HorizontalLine(),
                            SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.only(right: 230),
                              child: Text(
                                'Redeem',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            Column(children: [
                              Row(children: [
                                //checkbox Food Menu
                                SizedBox(
                                  child: Radio(
                                    value: 'Food menu',
                                    groupValue: couponType,
                                    activeColor: Colors.cyan,
                                    onChanged: (value) {
                                      //value may be true or false
                                      setState(() {
                                        couponType = value!;
                                        couponMenu = true;
                                        couponDiscount = false;
                                      });
                                    },
                                  ),
                                ),
                                // SizedBox(width: 10.0),
                                Text('Food menu'),
                                SizedBox(width: 50.0),
                                //checkbox Discount
                                SizedBox(
                                  child: Radio(
                                    value: 'Discount',
                                    groupValue: couponType,
                                    activeColor: Colors.cyan,
                                    onChanged: (value) {
                                      //value may be true or false
                                      setState(() {
                                        couponType = value!;
                                        couponMenu = false;
                                        couponDiscount = true;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text('Discount')
                              ]),
                            ]),
                            TextFormField(
                              // obscureText: true,
                              decoration: InputDecoration(
                                enabled: couponMenu,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Menu',
                              ),
                              // validator: (val) => val.isEmpty ? 'Firstname' : null, //ตัวแปรที่รับเข้ามาเป็น null ไม่ได้อยู่แล้ว
                              onChanged: (val) {
                                setState(() => menu = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabled: couponDiscount,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Discount (%)',
                              ),
                              onChanged: (val) {
                                double newDiscount =
                                    double.tryParse(val) ?? 0.0;
                                setState(() => discount = newDiscount);
                              },
                            ),
                            SizedBox(height: 20.0),
                            SizedBox(
                              height: 20.0,
                            ),
                            couponImage != null
                                ? Image.file(
                                    couponImage!,
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
                              title: 'Add Coupon Image',
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
                              child: const Text('Create',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                              onPressed: () {
                                String defaultImageUrl =
                                    'gs://quickqueue-17550.appspot.com/images/default.jpg';
                                File img =
                                    couponImage ?? File(defaultImageUrl);
                                if (currentUser != null && currentUser.uid != null){
                                    restaurantServices.addCoupon(couponName, menu, discount, requiredPoint, tier, currentUser.uid, img, _expirationDate);
                                }

                                //File img = File('assets/img/default.jpg');
                                // registerService
                                //     .registerRestaurantWithEmailAndPassword(
                                //         point,
                                //         couponName,
                                //         password,
                                //         phone,
                                //         address,
                                //         double.parse(latitude),
                                //         double.parse(longitude),
                                //         branch,
                                //         img);

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
    width: 225,
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
