import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // دالة لإنشاء الحساب
  Future<void> _createAccount() async {
    if (formKey.currentState!.validate()) {
      try {
        // إنشاء حساب جديد باستخدام Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text);

        // إضافة بيانات المستخدم إلى Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': _emailController.text,
          'fullName': _fullNameController.text,
          'age': _ageController.text,
          'id_roles': 1,  // إضافة دور المستخدم كـ 1، يمكن تخصيصه لاحقًا
        });

        // الانتقال إلى صفحة تسجيل الدخول أو الصفحة الرئيسية
        Navigator.pushReplacementNamed(context, '/login');  // أو '/home'
      } catch (e) {
        print("خطأ في إنشاء الحساب: $e");
        _showErrorDialog("حدث خطأ أثناء إنشاء الحساب");
      }
    }
  }

  // إظهار مربع حوار في حالة الخطأ
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('حسناً'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  _buildBackground(),
                  _buildLoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff00ce55),
            Color(0xff006837),
          ],
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 80.0, right: 30),
        child: Text(
          'مرحباً\n أنشأ حسابك الآن',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 200.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFullNameField(),
                const SizedBox(height: 10),
                _buildAgeField(),
                const SizedBox(height: 10),
                _buildEmailField(),
                const SizedBox(height: 10),
                _buildPasswordField(),
                const SizedBox(height: 10),
                _buildRPasswordField(),
                const SizedBox(height: 25),
                _buildCreateAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // حقل اسم المستخدم
  Widget _buildFullNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        controller: _fullNameController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.supervised_user_circle_rounded, color: Colors.green),
          label: Padding(
            padding: EdgeInsets.only(left: 200.0),
            child: Text(
              'إسم المستخدم',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff006837),
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال اسم المستخدم';
          }
          return null;
        },
      ),
    );
  }

  // حقل البريد الإلكتروني
  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.green),
          label: Padding(
            padding: EdgeInsets.only(left: 200.0),
            child: Text(
              'البريد الإلكتروني',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff006837),
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال البريد الإلكتروني';
          }
          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          if (!emailRegex.hasMatch(value)) {
            return 'يرجى إدخال بريد إلكتروني صالح';
          }
          return null;
        },
      ),
    );
  }

  // حقل كلمة المرور
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.green),
          label: Padding(
            padding: EdgeInsets.only(left: 230.0),
            child: Text(
              'كلمة المرور',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff006837),
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال كلمة المرور';
          }
          return null;
        },
      ),
    );
  }

  // حقل تأكيد كلمة المرور
  Widget _buildRPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.green),
          label: Padding(
            padding: EdgeInsets.only(left: 200.0),
            child: Text(
              'تأكيد كلمة المرور',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff006837),
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال تأكيد كلمة المرور';
          }
          if (value != _passwordController.text) {
            return 'كلمات المرور غير متطابقة';
          }
          return null;
        },
      ),
    );
  }

  // حقل العمر
  Widget _buildAgeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.date_range, color: Colors.green),
          label: Padding(
            padding: EdgeInsets.only(left: 270.0),
            child: Text(
              'العمر',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff006837),
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال العمر';
          }
          return null;
        },
      ),
    );
  }

  // زر إنشاء الحساب
  Widget _buildCreateAccountButton() {
    return Center(
      child: Container(
        width: 300,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xff005a30),
              Color(0xff00ce55),
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: _createAccount,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Center(
            child: Text(
              'إنشاء حساب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
