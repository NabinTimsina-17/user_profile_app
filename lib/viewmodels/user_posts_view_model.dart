import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/post_model.dart';

class UserPostsViewModel extends ChangeNotifier {
  List<Post> posts = [];
  late Dio _dio;

  UserPostsViewModel() {
    _dio = Dio()
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await _dio.get(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=e332b11c23d64f4d93d86aff90eb1442');
      if (response.statusCode == 200) {
        List<dynamic> jsonPosts = response.data['articles'];
        posts = jsonPosts.map((json) => Post.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching posts: $e');
      }
      throw Exception('Failed to load posts');
    }
  }
}
