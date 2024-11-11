import 'package:aqarat_apps/admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'create_account.dart';
import 'home_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'manage_page.dart';

class LoginPage extends StatefulWidget {
  final int userId;

  const LoginPage({super.key, required this.userId});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<int?> _fetchUserRole(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .get();

      return userDoc['id_roles'];
    } catch (e) {
      print("خطأ في تسجيل الدخول: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // إخفاء لوحة المفاتيح عند النقر خارج الحقول
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery
                  .of(context)
                  .size
                  .height,
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
        padding: EdgeInsets.only(top: 120.0, right: 30),
        child: Text(
          'مرحباً\n سجل دخولك الآن',
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
      padding: const EdgeInsets.only(top: 250.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 160.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 50),
                _buildLoginButton(),
                _buildSignUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

          // Validate email using a regular expression
          final emailRegex = RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          if (!emailRegex.hasMatch(value)) {
            return 'يرجى إدخال بريد إلكتروني صالح';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.green),
          label: Padding(
            padding: EdgeInsets.only(left: 220.0),
            child: Text(
              'كلمة المرور',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff006837),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
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
          onPressed: () async {
            int? idRole = await _fetchUserRole(
                _emailController.text, _passwordController.text);

            if (idRole != null) {
              _navigateToRolePage(idRole);
            } else {
              _showErrorDialog();
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Center(
            child: Text(
              'تسجيل الدخول',
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

  Widget _buildSignUpText() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0, top: 30),
            child: GestureDetector(
              onTap: () {
                // توجيه المستخدم إلى صفحة إنشاء الحساب
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePage()), // استبدل CreateAccountPage بالصفحة الخاصة بك
                );
              },
              child: RichText(
                text: const TextSpan(
                  text: "ليس لديك حساب؟ ",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: "إنشاء حساب",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  void _navigateToRolePage(int idRole) {
    if (idRole == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ManagePage()),
      );
    } else if (idRole == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RealEstateHomePage()),
      );
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'خطأ',
            textAlign: TextAlign.right, // ضبط النص ليكون على اليمين
          ),          content: const Text('البريد الإلكتروني أو كلمة المرور غير صحيحة'),
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
}