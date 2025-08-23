import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/utils/pic_image.dart';
import 'package:myapp/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File? image;

  List<String> selectedTopis = [];

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
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
            onPressed: () {}, 
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              image != null ?
              GestureDetector(
                onTap: selectImage,
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius:BorderRadius.circular(10),
                    child: Image.file(
                      image!,
                      fit: BoxFit.cover,
                    ),
                  )
                ),
              )
              :
              GestureDetector(
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
                        Icon(
                          Icons.folder_open,
                          size: 40,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Select your image",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Technology',
                    'Buisiness',
                    'Programming',
                    'Entertainement'
                  ].map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          if (selectedTopis.contains(e)) {
                            selectedTopis.remove(e);
                          } else {
                            selectedTopis.add(e);
                          }
                          setState(() {
                            
                          });
                        },
                        child: Chip(
                          label: Text(e),
                          color: selectedTopis.contains(e) ? const WidgetStatePropertyAll(AppPallete.gradient2) : null,
                          side: selectedTopis.contains(e) ? null : BorderSide(
                            color: AppPallete.borderColor,
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
              BlogEditor(
                controller: titleController,
                hintText: "Blog title",
              ),
              const SizedBox(
                height: 10,
              ),
              BlogEditor(
                controller: contentController,
                hintText: "Blog Content",
              ),
            ],
          ),
        ),
      ),
    );
  }
}