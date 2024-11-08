import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/bottom_snackbar/bottom_snackbar.dart';

import 'package:monstar/views/base/base_view.dart';
import 'package:monstar/views/contribution/widgets/option_input_field.dart';

import '../../components/button/arrow_back_button.dart';
import '../../providers/add_pollpost_provider.dart';
import '../home/home_screen.dart';
import 'widgets/text_input_field.dart';

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
  String? getScreenTitle() => "create a pollpost";

  @override
  Widget? getAppBarLeading() => ArrowBackButton();

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
      bottomSnackbar(context, "Send your pollpost successfully", "");

      await Future.delayed(Duration(seconds: 2));
      if (!mounted) return;

      pushReplacementScreen(HomeScreen());
    } catch (e) {
      if (!mounted) return;
      bottomSnackbar(context, "Some error have occurred", "");
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
            TextInputField(
              maxLines: 1,
              controller: _titleController,
              hintText: "Make your question",
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
                      child: OptionInputField(
                        controller: _choiceController[index],
                        index: index + 1,
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
                    onPressed: _submit,
                    child: isLoading
                        ? const Text("Submit")
                        : const CircularProgressIndicator(),
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
