import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RestaurantServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> addCoupon(String couponCode, String description, int discount, int requiredPoint, String tier,String resId) async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = now.add(Duration(days: 1));
      DateTime endDate = startDate.add(Duration(days: 7));
      String imageUrl = 'https://via.placeholder.com/150';

      await _firestore.collection('coupons').add({
        'code': couponCode,
        'cus_id': null,
        'res_id': resId,
        'description': description,
        'discount': discount,
        'required_point': requiredPoint,
        'tier': tier,
        'start_date': Timestamp.fromDate(startDate),
        'end_date': Timestamp.fromDate(endDate),
        'img': imageUrl,
      });
    } catch (e) {
      print('Error adding coupon: $e');
    }
  }
}