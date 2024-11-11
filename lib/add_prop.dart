import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AddPrp extends StatefulWidget {
  const AddPrp({super.key});

  @override
  _AddPrpState createState() => _AddPrpState();
}

class _AddPrpState extends State<AddPrp> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;

  // اختيار صورة من المعرض أو الكاميرا مع اقتصاصها
  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // اقتصاص الصورة بعد اختيارها
      File? croppedFile = (await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
       uiSettings: [
         AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
         ),
         IOSUiSettings(
           title: 'Cropper',
         )
       ]
      )) as File?;

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
      }
    }
  }

  // حفظ العقار
  void _saveProperty() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      final location = _locationController.text;
      final description = _descriptionController.text;
      final price = int.tryParse(_priceController.text) ?? 0;

      // مراقبة البيانات قبل الإرسال
      debugPrint('Title: $title');
      debugPrint('Location: $location');
      debugPrint('Description: $description');
      debugPrint('Price: $price');
      debugPrint('Image Path: ${_image?.path}');

      // هنا يمكنك إرسال البيانات إلى Firebase أو قاعدة بيانات أخرى
      // مثال: FirebaseFirestore.instance.collection('properties').add(newProperty.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة العقار بنجاح')),
      );
      Navigator.pop(context); // العودة إلى الصفحة السابقة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // تحديد اتجاه النصوص من اليمين لليسار
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة عقار جديد', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xff0d843f),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // العودة إلى الصفحة السابقة عند الضغط على زر الرجوع
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 40),
                // حقل لإدخال اسم العقار
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'اسم العقار',
                    labelStyle: const TextStyle(color: Color(0xff997950)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff0d843f)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم العقار';
                    }
                    return null;
                  },
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                // حقل لإدخال الموقع
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'الموقع',
                    labelStyle: const TextStyle(color: Color(0xff997950)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff0d843f)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الموقع';
                    }
                    return null;
                  },
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                // حقل لإدخال الوصف
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'الوصف',
                    labelStyle: const TextStyle(color: Color(0xff997950)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff0d843f)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الوصف';
                    }
                    return null;
                  },
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                // حقل لإدخال السعر
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'السعر',
                    labelStyle: const TextStyle(color: Color(0xff997950)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff0d843f)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال السعر';
                    }
                    return null;
                  },
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                // اختيار صورة
                GestureDetector(
                  onTap: _pickAndCropImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: _image == null
                        ? const Center(child: Text('اختيار صورة', style: TextStyle(color: Colors.grey)))
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // زر إضافة العقار
                ElevatedButton(
                  onPressed: _saveProperty,
                  child: const Text(
                    'إضافة العقار',
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff0d843f),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
