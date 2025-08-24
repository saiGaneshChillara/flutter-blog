import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failures.dart';
import 'package:myapp/features/blog/domain/entities/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String content,
    required String title,
    required String posterId,
    required List<String> topics,
  });
}