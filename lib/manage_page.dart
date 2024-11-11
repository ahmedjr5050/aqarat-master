import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'data/prepations/single_model.dart';
import 'info_page.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  int _selectedIndex = 0; // تحديد "الرئيسية" كالعنصر النشط بشكل افتراضي

  late Future<List<Singleprepation>> _properties;

  @override
  void initState() {
    super.initState();
    _properties = _fetchProperties(); // تعيين قيمة المتغير بشكل صحيح
  }

  // دالة لتسجيل الخروج
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/startpage'); // العودة إلى صفحة البداية
      print("تم تسجيل الخروج بنجاح");
    } catch (e) {
      print("فشل في تسجيل الخروج: $e");
    }
  }

  // جلب البيانات من Firestore
  Future<List<Singleprepation>> _fetchProperties() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('prepations').get();

      List<Singleprepation> properties = querySnapshot.docs.map((doc) {
        return Singleprepation.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return properties;
    } catch (e) {
      print("حدث خطأ أثناء جلب البيانات: $e");
      return [];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // الانتقال إلى صفحة الطلبات
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RequestsPage()),
      );
    } else if (index == 0) {
      // تسجيل الخروج
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تطبيق عقارات'),
        backgroundColor: Color(0xff0d843f),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // إضافة السهم في حال أردت وضع وظيفة
            },
          ),
        ],
        automaticallyImplyLeading: false, // إخفاء زر العودة الافتراضي
      ),
      body: _selectedIndex == 0 // عرض العقارات فقط إذا كانت الصفحة الحالية هي "الرئيسية"
          ? FutureBuilder<List<Singleprepation>>(
        future: _properties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد عقارات حالياً'));
          } else {
            List<Singleprepation> properties = snapshot.data!;

            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                var property = properties[index];
                return PropertyItem(
                  imageUrl: property.imageUrls.isNotEmpty
                      ? property.imageUrls[0]
                      : 'assets/default_image.jpg',
                  title: property.title ?? '',
                  location: property.description ?? '',
                  price: '${property.price} دينار',
                );
              },
            );
          }
        },
      )
          : Center(child: Text('الطلبات')), // إذا كانت الصفحة الحالية هي الطلبات
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'تسجيل الخروج',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        // تغيير اتجاه عناصر الـ BottomNavigationBar إلى من اليمين لليسار
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Arabic', // تخصيص نوع الخط العربي إذا كان موجودًا
        ),
      ),
    );
  }
}

class PropertyItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;

  PropertyItem({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsPage(
              imageUrl: imageUrl,
              title: title,
              location: location,
              price: price,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // وضع المحتوى من اليمين لليسار
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xff005a30),
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                location,
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff997950),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// يمكنك استبدال هذا الكود بـ صفحتك الخاصة للطلبات
class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات'),
        backgroundColor: Color(0xff006837),
      ),
      body: const Center(
        child: Text('لاتوجد طلبات'),
      ),
    );
  }
}
