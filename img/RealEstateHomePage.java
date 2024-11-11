import 'package:flutter/material.dart';

class RealEstateHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 260.0),
          child: Text(
            'تطبيق عقارات',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xff0d843f),
        automaticallyImplyLeading: false,
        toolbarHeight: 66,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,  // التأكد من أن الاتجاه من اليمين لليسار
        child: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // شريط البحث
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xff005a30)),
                    hintText: '...ابحث عن عقار',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // فئات العقارات
              Padding(
                padding: const EdgeInsets.only(left: 320.0),
                child: Text(
                  'الفئات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff005a30),
                  ),
                  textAlign: TextAlign.right,  // تعديل هنا
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryItem(icon: Icons.apartment, label: 'شقق'),
                      CategoryItem(icon: Icons.house, label: 'فيلات'),
                      CategoryItem(icon: Icons.business, label: 'مكاتب'),
                      CategoryItem(icon: Icons.villa, label: 'أراضي'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // قائمة العقارات المتاحة
              Padding(
                padding: const EdgeInsets.only(left: 180.0),
                child: Text(
                  'عقارات متاحة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff005a30),
                  ),
                  textAlign: TextAlign.right,  // تعديل هنا
                ),
              ),
              SizedBox(height: 10),

              // عرض العقارات في شبكة (مربعات)
              GridView.builder(
                shrinkWrap: true,  // لتقليص حجم الـ GridView ليظهر في المساحة المتاحة
                physics: NeverScrollableScrollPhysics(),  // لمنع التمرير داخل الـ GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // عدد الأعمدة (يمكن تعديله)
                  crossAxisSpacing: 10,  // المسافة بين الأعمدة
                  mainAxisSpacing: 10,  // المسافة بين الصفوف
                  childAspectRatio: 0.75,  // تحديد نسبة العرض إلى الارتفاع
                ),
                itemCount: 3,  // عدد العناصر (يمكن تعديله حسب عدد العقارات)
                itemBuilder: (context, index) {
                  return PropertyItem(
                    imageUrl: 'assets/img/h5.jpg',  // تأكد من أنك تستخدم مسار الصورة المحلي
                    title: 'عقار رقم $index',
                    location: 'موقع العقار $index',
                    price: '${(index + 1) * 100000} دينار',
                  );
                },
              ),
            ],
          ),
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      shadowColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.asset(  // تعديل هنا لاستخدام صورة محلية
              imageUrl,
              width: double.infinity,
              height: 120,  // تحديد ارتفاع الصورة داخل المربع
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
              textAlign: TextAlign.right,  // تعديل هنا
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              location,
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.right,  // تعديل هنا
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
                color: Color(0xff00ce55),
              ),
              textAlign: TextAlign.right,  // تعديل هنا
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // إضافة الحشو حول العناصر
      child: Column(
        mainAxisSize: MainAxisSize.min, // تأكد من أن العمود لا يشغل أكثر من المساحة اللازمة
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 35, // تحديد نصف القطر للأيقونة داخل الدائرة
              backgroundColor: Colors.white,
              child: Icon(icon, color: Color(0xff997950), size: 28),
            ),
          ),
          SizedBox(height: 5), // إضافة مسافة بين الأيقونة والعنوان
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff005a30),
            ),
            textAlign: TextAlign.center, // محاذاة النص بشكل مركزي
          ),
        ],
      ),
    );
  }
}
