import 'package:flutter/material.dart';
import 'package:profile_app/core/asset_constants.dart';
import 'package:profile_app/core/string_constants.dart';
import 'package:provider/provider.dart';
import '../core/color_constants.dart';
import '../viewmodels/profile_view_model.dart';
import '../viewmodels/user_posts_view_model.dart';
import 'user_posts_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppStrings.appName),
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
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
                          backgroundImage: viewModel.user.imageBytes != null
                              ? MemoryImage(viewModel.user.imageBytes!)
                              : const AssetImage(AppAssets.profilePlaceholder)
                                  as ImageProvider,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.backgroundColor,
                            size: 24,
                          ),
                          onPressed: viewModel.pickImage,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  itemProfile(AppStrings.nameLabel, viewModel.user.name, Icons.person),
                  itemProfile(AppStrings.emailLabel, viewModel.user.email, Icons.mail),
                  itemProfile(AppStrings.phoneLabel, viewModel.user.phone, Icons.phone),
                  itemProfile(AppStrings.addressLabel, viewModel.user.address, Icons.location_city),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _editProfile(context, viewModel),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Text(AppStrings.editProfileButton),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (_) => UserPostsViewModel(),
                                  child: const UserPostsPage(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Text(AppStrings.viewUserPostsButton),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 5),
            color: AppColors.secondaryColor,
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
          color: AppColors.arrowColor,
        ),
        tileColor: AppColors.backgroundColor,
      ),
    );
  }

  void _editProfile(BuildContext context, ProfileViewModel viewModel) {
    String tempName = viewModel.user.name;
    String tempEmail = viewModel.user.email;
    String tempPhone = viewModel.user.phone;
    String tempAddress = viewModel.user.address;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                  decoration: const InputDecoration(labelText: AppStrings.nameLabel),
                  controller: TextEditingController(text: viewModel.user.name),
                ),
                TextField(
                  onChanged: (value) => tempEmail = value,
                  decoration: const InputDecoration(labelText: AppStrings.emailLabel),
                  controller: TextEditingController(text: viewModel.user.email),
                ),
                TextField(
                  onChanged: (value) => tempPhone = value,
                  decoration: const InputDecoration(labelText: AppStrings.phoneLabel),
                  controller: TextEditingController(text: viewModel.user.phone),
                ),
                TextField(
                  onChanged: (value) => tempAddress = value,
                  decoration: const InputDecoration(labelText: AppStrings.addressLabel),
                  controller: TextEditingController(text: viewModel.user.address),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    viewModel.updateUser(tempName, tempEmail, tempPhone, tempAddress);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text(AppStrings.saveButton),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
