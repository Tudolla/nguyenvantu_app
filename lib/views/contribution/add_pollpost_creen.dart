import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/api/request/contribution_model/pollpost_model.dart';
import '../../providers/add_pollpost_provider.dart';

class AddPollpostCreen extends ConsumerStatefulWidget {
  const AddPollpostCreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPollpostCreenState();
}

class _AddPollpostCreenState extends ConsumerState<AddPollpostCreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _choiceController = [];

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
    final pollpostViewmodel = ref.watch(pollPostProvider.notifier);
    final statePollPost = ref.watch(pollPostProvider);

    void _submit() {
      final title = _titleController.text;
      final choices =
          _choiceController.map((controller) => controller.text).toList();
      List<Choice> listChoice =
          choices.map((e) => Choice(choiceText: e)).toList();
      pollpostViewmodel.submitPollPost(title, choices);
    }

    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a pollpost"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                                  borderRadius: BorderRadius.circular(30),
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
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    width: size / 2,
                    child: ElevatedButton(
                      onPressed: _addMoreChoice,
                      child: Text("Add more choice"),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            statePollPost.when(
              data: (isSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (isSuccess) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Thành công'),
                        content: Text('Tạo poll thành công!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Đóng dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Thất bại'),
                        content: Text('Tạo poll thất bại!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Đóng dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                });

                return SizedBox.shrink();
              },
              error: (e, stackTrace) {
                return Center(
                  child: Text('Some error was happend'),
                );
              },
              loading: () => CircularProgressIndicator(),
            ),
            Container(
              alignment: Alignment.center,
              width: size / 2,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
