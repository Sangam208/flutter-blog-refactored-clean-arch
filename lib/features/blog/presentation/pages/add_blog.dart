import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/common/widgets/loader.dart';
import 'package:my_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:my_app/core/utils/show_toast.dart';
import 'package:my_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:my_app/features/blog/presentation/pages/home.dart';
import 'package:my_app/features/blog/presentation/widgets/blog_field.dart';
import 'package:my_app/features/blog/presentation/widgets/file_container.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  File? selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() && selectedImage != null) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUploadRequested(
              userId: userId,
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
              image: selectedImage!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 169, 169),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 240, 160, 160),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            'Create a post',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) async {
            if (state is BlogFailure) {
              showToast(state.message);
            } else if (state is BlogSuccess) {
              await Future.delayed(const Duration(seconds: 2));
              Navigator.pop(context);
              showToast('Added');
            }
          },
          builder: (context, state) {
            return state is BlogLoading
                ? const Loader()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            child: FileContainer(
                              file: selectedImage,
                              onFilePicked: (file) {
                                setState(() {
                                  selectedImage = file;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 15),

                          /// Title
                          BlogField(
                            fieldController: _titleController,
                            label: 'Title',
                          ),
                          const SizedBox(height: 12),

                          /// Content
                          BlogField(
                            fieldController: _contentController,
                            label: 'Content',
                          ),
                          const SizedBox(height: 20),

                          /// Save Button
                          ElevatedButton(
                            onPressed: uploadBlog,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor:
                                  const Color.fromARGB(255, 34, 34, 34),
                            ),
                            child: Text(
                              'Add',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
