import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/bottom_snackbar/bottom_snackbar.dart';
import '../../components/button/app_button.dart';
import '../../components/button/arrow_back_button.dart';
import '../../providers/add_textpost_provider.dart';
import '../base/base_view.dart';
import 'widgets/text_input_field.dart';

class AddTextPostScreen extends ConsumerStatefulWidget {
  const AddTextPostScreen({super.key});

  @override
  ConsumerState<AddTextPostScreen> createState() => _AddTextPostScreenState();
}

class _AddTextPostScreenState extends BaseView<AddTextPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void onDispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.onDispose();
  }

  @override
  String getScreenTitle() => "your contribution";

  @override
  Widget? getAppBarLeading() => ArrowBackButton();

  @override
  Widget buildBody(BuildContext context) {
    final postViewModel = ref.watch(postNotifierProvider.notifier);
    final stateTextPost = ref.watch(postNotifierProvider);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
        ),
        child: Center(
          child: Column(
            children: [
              TextInputField(
                maxLines: 1,
                controller: _titleController,
                hintText: "title ",
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                maxLines: 5,
                controller: _descriptionController,
                hintText: "Describe about problem",
              ),
              const SizedBox(
                height: 20,
              ),
              stateTextPost.isLoading
                  ? CircularProgressIndicator()
                  : AppButton(
                      backgroundColor: Colors.blueGrey,
                      text: "Submit",
                      function: () async {
                        await postViewModel.submitPost(
                          _titleController.text,
                          _descriptionController.text,
                        );
                        bottomSnackbar(
                            context, "Server get your contribution", "");
                        // _checkPostStatus(context, stateTextPost);
                      },
                      textColor: Colors.white,
                      sizeHeight: 50.0,
                      sizeWidth: 200.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
