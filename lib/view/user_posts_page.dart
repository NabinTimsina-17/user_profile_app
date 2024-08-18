import 'package:flutter/material.dart';
import 'package:profile_app/core/color_constants.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_posts_view_model.dart';

class UserPostsPage extends StatelessWidget {
  const UserPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Posts'),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Consumer<UserPostsViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.posts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: viewModel.posts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppColors.cardBackgroundColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: ListTile(
                        title: Text(
                          viewModel.posts[index].author,
                          style: const TextStyle(
                            color: AppColors.titleTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          viewModel.posts[index].title,
                          style: const TextStyle(
                            color: AppColors.subtitleTextColor,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.iconColor,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
