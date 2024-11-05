import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/button/arrow_back_button.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/views/base/base_view.dart';

import '../../providers/add_pollpost_provider.dart';
import '../home/home_screen.dart';

class AddPollpostScreen extends ConsumerStatefulWidget {
  const AddPollpostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPollpostScreenState();
}

class _AddPollpostScreenState extends BaseView<AddPollpostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _choiceController = [];

  @override
  void onDispose() {
    _titleController.dispose();
    for (var controller in _choiceController) {
      controller.dispose();
    }
  }

  // ignore: unused_element
  void _removeChoice(int index) {
    setState(() {
      _choiceController[index].dispose();
      _choiceController.removeAt(index);
    });
  }

  // ignore: unused_element
  void _addMoreChoice() {
    setState(() {
      _choiceController.add(TextEditingController());
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      leading: ArrowBackButton(),
      title: Text(
        "Crate a pollpost",
        style: TextStyle(
          fontFamily: AppTextStyle.drawerFontStyle,
          fontSize: 25,
          color: Colors.grey,
        ),
      ),
      centerTitle: true,
    );
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _choiceController.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final title = _titleController.text;
    final choices =
        _choiceController.map((controller) => controller.text).toList();

    try {
      final pollpostViewmodel = ref.read(pollPostProvider.notifier);
      await pollpostViewmodel.submitPollPost(title, choices);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bài viết đã được gửi thành công')),
      );

      await Future.delayed(Duration(seconds: 2));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error was happened: $e')),
      );
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    final statePollPost = ref.watch(pollPostProvider);
    var size = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Make a question?",
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
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ..._choiceController.map((controller) {
              int index = _choiceController.indexOf(controller);
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 5,
                        right: 10,
                      ),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: "Option : ${index + 1}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeChoice(index),
                    icon: Icon(Icons.remove_circle),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            SizedBox(
              width: size / 2,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: _addMoreChoice,
                child: Text("Add more choice"),
              ),
            ),
            const SizedBox(height: 10),
            statePollPost.when(
              data: (isLoading) {
                return SizedBox(
                  width: size / 2,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Submit"),
                  ),
                );
              },
              error: (e, stackTrace) => buildErrorWidget(e, stackTrace),
              loading: () => buildLoadingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
