import 'package:flutter/material.dart';
import 'package:monstar/components/snackbar/show_snackbar.dart';
import 'package:monstar/views/contribution/viewmodel/text_post_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/button/app_button.dart';
import '../../providers/textpost_provider.dart';

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
        title: Text("your contribution"),
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
                    hintText: "Title",
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "description",
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

                // if (stateTextPost.isSuccess) Text("Success"),
                // if (stateTextPost.errorMessage != null) Text("Error"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
