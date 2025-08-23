import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DottedBorder(
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
                    child: Chip(
                      label: Text(e),
                      side: const BorderSide(
                        color: AppPallete.borderColor,
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
              height: 15,
            ),
            BlogEditor(
              controller: contentController,
              hintText: "Blog Content",
            ),
          ],
        ),
      ),
    );
  }
}