import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:myapp/core/common/widgets/loader.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/utils/pic_image.dart';
import 'package:myapp/core/utils/show_snackbar.dart';
import 'package:myapp/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:myapp/features/blog/presentation/pages/blog_page.dart';
import 'package:myapp/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File? image;

  List<String> selectedTopis = [];

  final formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopis.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
        BlogUploaded(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: image!,
          topics: selectedTopis,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(image!, fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              options: RectDottedBorderOptions(
                                color: AppPallete.borderColor,
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                              ),
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text(
                                      "Select your image",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                                  'Technology',
                                  'Buisiness',
                                  'Programming',
                                  'Entertainement',
                                ]
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedTopis.contains(e)) {
                                          selectedTopis.remove(e);
                                        } else {
                                          selectedTopis.add(e);
                                        }
                                        setState(() {});
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        color: selectedTopis.contains(e)
                                            ? const WidgetStatePropertyAll(
                                                AppPallete.gradient2,
                                              )
                                            : null,
                                        side: selectedTopis.contains(e)
                                            ? null
                                            : BorderSide(
                                                color: AppPallete.borderColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    BlogEditor(
                      controller: titleController,
                      hintText: "Blog title",
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: "Blog Content",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
