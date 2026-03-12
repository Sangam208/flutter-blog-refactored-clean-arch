import 'package:hive/hive.dart';
import 'package:my_app/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDatasource {
  void uploadLocalBlogs({required List<BlogModel> blogs});

  List<BlogModel> loadBlogs();

  Future<void> clearLocalBlogs();
}

class BlogLocalDatasourceImplementation implements BlogLocalDatasource {
  final Box _box;
  BlogLocalDatasourceImplementation(this._box);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    for (final key in _box.keys) {
      final blogsRaw = _box.get(key);
      if (blogsRaw == null) continue;
      blogs.add(BlogModel.fromJson(Map<String, dynamic>.from(blogsRaw)));
    }
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    _box.clear();
    for (var i = 0; i < blogs.length; i++) {
      _box.put(i.toString(), blogs[i].toJson());
    }
  }

  @override
  Future<void> clearLocalBlogs() async {
    await _box.clear();
  }
}
