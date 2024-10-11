import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/base/base_screen.dart';
import 'package:monstar/views/home/home_screen.dart';

import '../../components/button/arrow_back_button.dart';
import '../../components/core/app_textstyle.dart';
import '../../providers/add_pollpost_provider.dart';

class AddPollpostCreen extends ConsumerStatefulWidget {
  const AddPollpostCreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPollpostCreenState();
}

class _AddPollpostCreenState extends BaseScreen<AddPollpostCreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _choiceController = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _removeChoice(int index) {
    setState(() {
      _choiceController[index].dispose();
      _choiceController.removeAt(index);
    });
  }

  void _addMoreChoice() {
    setState(() {
      _choiceController.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ArrowBackButton(),
        title: Text(
          "Create a pollpost",
          style: TextStyle(
            fontFamily: AppTextStyle.drawerFontStyle,
            fontSize: 25,
            color: const Color.fromARGB(255, 109, 105, 105),
          ),
        ),
        centerTitle: true,
      ),
      body: buildBody(context),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final statePollPost = ref.watch(pollPostProvider);
    final pollpostViewmodel = ref.read(pollPostProvider.notifier);
    var size = MediaQuery.of(context).size.width;

    void _submit() async {
      if (_titleController.text.isEmpty ||
          _choiceController.any((controller) => controller.text.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please fill in all fields"),
          ),
        );
        return;
      }
      final title = _titleController.text;
      final choices =
          _choiceController.map((controller) => controller.text).toList();

      try {
        await pollpostViewmodel.submitPollPost(title, choices);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bài viết đã được gửi thành công')),
        );
        await Future.delayed(
          Duration(seconds: 2),
        );
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreenDefault();
            },
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error was happened: $e')),
        );
      }
    }

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
            SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 10,
            ),
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
              error: (e, stackTrace) => Center(
                child: Text("Error : $e"),
              ),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
