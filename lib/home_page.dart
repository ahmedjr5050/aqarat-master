import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/prepations/single_model.dart';
import 'info_page.dart';

class RealEstateHomePage extends StatefulWidget {
  @override
  State<RealEstateHomePage> createState() => _RealEstateHomePageState();
}

class _RealEstateHomePageState extends State<RealEstateHomePage> {
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
        textDirection: TextDirection.rtl,
        child: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // شريط البحث
              _buildSearchBar(),
              SizedBox(height: 20),

              // فئات العقارات
              Padding(
                padding: const EdgeInsets.only(left: 300.0),
                child: Text(
                  'الفئات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff005a30),
                  ),
                  textAlign: TextAlign.right,
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
              SizedBox(height: 30),

              // قائمة العقارات المتاحة حسب الفئة
              _buildPropertySection('المنازل', 'houses'),
              _buildPropertySection('الشقق', 'apartments'),
              _buildPropertySection('المكاتب', 'offices'),
              _buildPropertySection('الأراضي', 'lands'), // التأكد من التصنيف الصحيح في Firebase
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
    );
  }

  Widget _buildPropertySection(String title, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff005a30),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('prepations').where('category', isEqualTo: category).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            if (snapshot.data!.docs.isEmpty) return SizedBox.shrink(); // لا تعرض القسم إذا كان فارغاً

            // تحويل البيانات إلى قائمة من عناصر SinglePreparation
            List<Widget> properties = snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              var property = Singleprepation.fromJson(data);

              // هنا نعيد إنشاء عنصر واجهة المستخدم الخاص بالعقار
              return PropertyItem(
                imageUrl: property.imageUrls.isNotEmpty ? property.imageUrls[0] : 'assets/default_image.jpg',
                title: property.title ?? 'بدون عنوان',
                location: property.description ?? 'بدون موقع',
                price: '${property.price} دينار',
              );
            }).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: properties,
              ),
            );
          },
        ),
      ],
    );
  }
}

// تعريف فئة PropertyItem لعرض تفاصيل العقار
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          // عند الضغط على العقار، يمكنك إضافة الانتقال إلى صفحة التفاصيل
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
                  width: 150,
                  height: 100,
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(icon, color: Color(0xff997950), size: 28),
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff005a30),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// صفحة تفاصيل العقار (اختياري)
class PropertyDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;

  PropertyDetailsPage({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل العقار'),
        backgroundColor: Color(0xff0d843f),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'الموقع: $location',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'السعر: $price',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
