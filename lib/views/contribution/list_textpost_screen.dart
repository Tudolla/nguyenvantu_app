import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/get_textpost_provider.dart';

class TextPostListScreen extends ConsumerStatefulWidget {
  const TextPostListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TextPostListScreenState();
}

class _TextPostListScreenState extends ConsumerState<TextPostListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(textPostViewModelProvider.notifier).loadTextPost();
  }

  @override
  Widget build(BuildContext context) {
    final textPostState = ref.watch(textPostViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("List TextPost"),
      ),
      body: textPostState.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey.withOpacity(.5),
              ),
              child: ListTile(
                title: Text(post.title!),
                subtitle: Text(post.description!),
              ),
            );
          },
        ),
        error: (e, stack) {
          return Center(
            child: Text("Error : $e"),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
