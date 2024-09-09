import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/get_pollpost_provider.dart';

class PollPostScreen extends ConsumerStatefulWidget {
  const PollPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollPostScreenState();
}

class _PollPostScreenState extends ConsumerState<PollPostScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(pollPostViewModelProvider.notifier).loadPollPost();
  }

  @override
  Widget build(BuildContext context) {
    final statePollPost = ref.watch(pollPostViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Let make a choice"),
        centerTitle: true,
      ),
      body: statePollPost.when(
        data: (pollpost) => Column(
          children: [
            ListView.builder(
              itemCount: pollpost.length,
              itemBuilder: (context, index) {
                final post = pollpost[index];
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
                    title: Text(
                      post.choices[index].choiceText ?? "",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        error: (e, strackTrace) {
          return Center(
            child: Text("Having some: $e"),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
