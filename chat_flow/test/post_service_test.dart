import 'package:chat_flow/core/models/post_model.dart';
import 'package:chat_flow/core/service/post/post_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PostService postService;

  setUp(() {
    postService = PostService();
  });

  group('PostService Tests', () {
    test('getPosts returns list of posts', () async {
      final posts = await postService.getPosts();
      print(posts);
      expect(posts, isNotNull);
      expect(posts, isA<List<PostModel>>());
      expect(posts!.isNotEmpty, isTrue);
      expect(posts.first, isA<PostModel>());
    });

    test('getPost returns single post', () async {
      final post = await postService.getPost(1);
      expect(post, isNotNull);
      expect(post, isA<PostModel>());
      expect(post?.id, equals(1));
    });

    test('createPost creates new post', () async {
      final newPost = await postService.createPost(
        'Test Başlık',
        'Test İçerik',
        1,
      );
      expect(newPost, isNotNull);
      expect(newPost, isA<PostModel>());
      expect(newPost?.title, equals('Test Başlık'));
      expect(newPost?.body, equals('Test İçerik'));
    });

    test('updatePost updates existing post', () async {
      final updatedPost = await postService.updatePost(
        1,
        'Güncellenmiş Başlık',
        'Güncellenmiş İçerik',
      );
      expect(updatedPost, isNotNull);
      expect(updatedPost, isA<PostModel>());
      expect(updatedPost?.title, equals('Güncellenmiş Başlık'));
      expect(updatedPost?.body, equals('Güncellenmiş İçerik'));
    });

    test('deletePost deletes post', () async {
      final result = await postService.deletePost(1);
      expect(result, isTrue);
    });
  });
}
