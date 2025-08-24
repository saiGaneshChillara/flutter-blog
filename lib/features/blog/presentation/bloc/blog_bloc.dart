import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/usecases/usecase.dart';
import 'package:myapp/features/blog/domain/entities/blog.dart';
import 'package:myapp/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:myapp/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  }) : _uploadBlog = uploadBlog, 
  _getAllBlogs = getAllBlogs,
  super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploaded>(_onBlogUploaded);
    on<BlogFetchAll>(_onFetchAllBlogs);
  }

  void _onBlogUploaded(
    BlogUploaded event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (error) => emit(
        BlogFailure(
          error.message
        )
      ),
      (blog) => emit(
        BlogUploadSuccess(),
      ),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAll event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (error) => emit(BlogFailure(error.message)),
      (blogs) => emit(BlogFetchSuccess(blogs)),
    );
  }
}