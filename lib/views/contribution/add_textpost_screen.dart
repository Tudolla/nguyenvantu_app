import 'package:flutter/material.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/contribution/viewmodel/add_text_post_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/button/app_button.dart';
import '../../components/button/arrow_back_button.dart';
import '../../providers/add_textpost_provider.dart';

class ContributionScreen extends ConsumerStatefulWidget {
  const ContributionScreen({super.key});

  @override
  ConsumerState<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends ConsumerState<ContributionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _checkPostStatus(BuildContext context, PostState stateTextPost) {
    if (stateTextPost.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Add post successful")),
      );
    } else if (stateTextPost.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${stateTextPost.errorMessage}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final postViewModel = ref.watch(postNotifierProvider.notifier);
    final stateTextPost = ref.watch(postNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: ArrowBackButton(),
        title: Text(
          "your contribution",
          style: TextStyle(
            fontFamily: AppTextStyle.drawerFontStyle,
            fontSize: 25,
            color: const Color.fromARGB(255, 109, 105, 105),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 20,
            right: 20,
          ),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Title information",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 5,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Detail description",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                stateTextPost.isLoading
                    ? CircularProgressIndicator()
                    : AppButton(
                        backgroundColor: Colors.blueGrey,
                        text: "Submit",
                        function: () {
                          postViewModel.submitPost(
                            _titleController.text,
                            _descriptionController.text,
                          );
                          _checkPostStatus(context, stateTextPost);
                        },
                        textColor: Colors.white,
                        sizeHeight: 50.0,
                        sizeWidth: 200.0,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
