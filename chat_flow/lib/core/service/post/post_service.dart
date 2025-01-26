import 'package:chat_flow/core/init/network/network_manager.dart';
import 'package:chat_flow/core/models/post_model.dart';

abstract class IPostService {
  Future<List<PostModel>?> getPosts();
  Future<PostModel?> getPost(int id);
  Future<PostModel?> createPost(String title, String body, int userId);
  Future<PostModel?> updatePost(int id, String title, String body);
  Future<bool> deletePost(int id);
}

class PostService extends IPostService {
  final NetworkManager _networkManager = NetworkManager.instance;

  // Tüm gönderileri getir
  @override
  Future<List<PostModel>?> getPosts() async {
    return _networkManager.send<PostModel, List<PostModel>>(
      path: '/posts',
      type: RequestType.get,
      parseModel: PostModel(),
    );
  }

  // Belirli bir gönderiyi getir
  @override
  Future<PostModel?> getPost(int id) async {
    return _networkManager.send<PostModel, PostModel>(
      path: '/posts/$id',
      type: RequestType.get,
      parseModel: PostModel(),
    );
  }

  // Yeni gönderi oluştur
  @override
  Future<PostModel?> createPost(String title, String body, int userId) async {
    return _networkManager.send<PostModel, PostModel>(
      path: '/posts',
      type: RequestType.post,
      parseModel: PostModel(),
      data: {
        'title': title,
        'body': body,
        'userId': userId,
      },
    );
  }

  // Gönderiyi güncelle
  @override
  Future<PostModel?> updatePost(int id, String title, String body) async {
    return _networkManager.send<PostModel, PostModel>(
      path: '/posts/$id',
      type: RequestType.put,
      parseModel: PostModel(),
      data: {
        'id': id,
        'title': title,
        'body': body,
      },
    );
  }

  // Gönderiyi sil
  @override
  Future<bool> deletePost(int id) async {
    final response = await _networkManager.send<PostModel, PostModel>(
      path: '/posts/$id',
      type: RequestType.delete,
      parseModel: PostModel(),
    );
    return response != null;
  }
}
