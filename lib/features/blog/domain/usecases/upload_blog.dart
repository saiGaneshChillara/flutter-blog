import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failures.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/blog/domain/entities/blog.dart';
import 'package:myapp/features/blog/domain/repositories/blog_repository.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,content: params.content,
      title: params.title,
      posterId: params.posterId,
      topics: params.topics
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content; 
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image, 
    required this.topics,
  });
}