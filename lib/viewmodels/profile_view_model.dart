import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  User user = User(
    name: 'Nabin Timsina',
    email: 'timsinabin9@gmail.com',
    phone: '9841026076',
    address: 'Bijaypur, Pokhara-26',
  );

  ProfileViewModel() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    user = User(
      name: prefs.getString('name') ?? user.name,
      email: prefs.getString('email') ?? user.email,
      phone: prefs.getString('phone') ?? user.phone,
      address: prefs.getString('address') ?? user.address,
      imageBytes: prefs.getString('imageBytes') != null
          ? Uint8List.fromList(prefs.getString('imageBytes')!.codeUnits)
          : null,
    );
    notifyListeners();
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('phone', user.phone);
    await prefs.setString('address', user.address);
    if (user.imageBytes != null) {
      await prefs.setString('imageBytes', String.fromCharCodes(user.imageBytes!));
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      user.imageBytes = await pickedImage.readAsBytes();
      _saveProfile();
      notifyListeners();
    }
  }

  void updateUser(String name, String email, String phone, String address) {
    user = User(
      name: name,
      email: email,
      phone: phone,
      address: address,
      imageBytes: user.imageBytes,
    );
    _saveProfile();
    notifyListeners();
  }
}
