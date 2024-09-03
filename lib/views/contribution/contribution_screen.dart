import 'package:flutter/material.dart';

import '../../components/button/app_button.dart';

class ContributionScreen extends StatefulWidget {
  const ContributionScreen({super.key});

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  @override
  Widget build(BuildContext context) {
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
                  decoration: InputDecoration(
                    hintText: "Title",
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "description",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  backgroundColor: Colors.blueGrey,
                  text: "Submit",
                  function: () {},
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


//////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_notifier.dart';

class PostPage extends ConsumerWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            postState.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final title = _titleController.text;
                      final description = _descriptionController.text;
                      ref.read(postNotifierProvider.notifier).submitPost(title, description);
                    },
                    child: Text('Submit'),
                  ),
            if (postState.isSuccess) Text('Post submitted successfully!'),
            if (postState.errorMessage != null) Text('Error: ${postState.errorMessage}'),
          ],
        ),
      ),
    );
  }
}
