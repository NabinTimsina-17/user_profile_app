import 'dart:typed_data';

class User {
  String name;
  String email;
  String phone;
  String address;
  Uint8List? imageBytes;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.imageBytes,
  });
}
