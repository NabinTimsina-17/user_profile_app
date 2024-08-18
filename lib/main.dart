import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_post_page.dart';  

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "User Profile App",
    theme: ThemeData(primarySwatch: Colors.deepOrange),
    home: const ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // For web and mobile compatibility
  Uint8List? imageBytes; 
  final ImagePicker _picker = ImagePicker();

  // Image Picker Handler
  Future<void> openImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() {
        this.imageBytes = imageBytes;
      });
    }
  }

  String name = "Nabin Timsina";
  String email = "timsinabin9@gmail.com";
  String phone = "9841026076";
  String address = "Bijaypur, Pokhara-26";

  @override
  void initState() {
    super.initState();
    _loadProfile();
   
  }

  // Load the user profile from SharedPreferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? name;
      email = prefs.getString('email') ?? email;
      phone = prefs.getString('phone') ?? phone;
      address = prefs.getString('address') ?? address;
    });
  }

  // Save the user profile to SharedPreferences
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String tempName = name;
        String tempEmail = email;
        String tempPhone = phone;
        String tempAddress = address;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => tempName = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  onChanged: (value) => tempEmail = value,
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: TextEditingController(text: email),
                ),
                TextField(
                  onChanged: (value) => tempPhone = value,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  controller: TextEditingController(text: phone),
                ),
                TextField(
                  onChanged: (value) => tempAddress = value,
                  decoration: const InputDecoration(labelText: 'Address'),
                  controller: TextEditingController(text: address),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      name = tempName;
                      email = tempEmail;
                      phone = tempPhone;
                      address = tempAddress;
                    });
                    _saveProfile(); 
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToUserPosts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserPostsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User Profile App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: imageBytes != null
                        ? MemoryImage(imageBytes!)
                        : const AssetImage('assets/images/nabin.jpg')
                            as ImageProvider,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: openImagePicker,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            itemProfile('Name', name, Icons.person),
            itemProfile('Email', email, Icons.mail),
            itemProfile('Phone', phone, Icons.phone),
            itemProfile('Address', address, Icons.location_city),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text("Edit Profile"),
                  ),
                ),
                const SizedBox(width: 10), 
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToUserPosts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text("View User Posts"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.deepOrange.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: const Icon(
          Icons.arrow_forward,
          color: Colors.grey,
        ),
        tileColor: Colors.white,
      ),
    );
  }
}
