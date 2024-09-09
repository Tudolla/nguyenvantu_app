import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../providers/get_pollpost_provider.dart';
import '../../providers/vote_pollpost_provider.dart';

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
    final stateVote = ref.watch(votePollpostViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Let make a choice"),
        centerTitle: true,
      ),
      body: statePollPost.when(
        error: (e, strackTrace) {
          return Center(
            child: Text("Having some: $e"),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        data: (pollpost) {
          if (pollpost.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text("No data available"),
              ),
            );
          }

          final firstItem = pollpost[0];

          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstItem.title!,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: firstItem.choices.length,
                    itemBuilder: (context, index) {
                      final isVoted = stateVote[firstItem.choices[index].id];
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
                          leading: Checkbox(
                            value: isVoted ?? false,
                            onChanged: (isVoted ?? false)
                                ? null
                                : (bool? value) {
                                    if (value != null &&
                                        value &&
                                        firstItem.choices[index].id != null) {
                                      ref
                                          .read(
                                            votePollpostViewModelProvider
                                                .notifier,
                                          )
                                          .vote(firstItem.choices[index].id!);
                                    }
                                    setState(() {
                                      if (firstItem.choices[index].count !=
                                          null) {
                                        final updateCount =
                                            firstItem.choices[index].copyWith(
                                          count:
                                              (firstItem.choices[index].count ??
                                                      0) +
                                                  1,
                                        );
                                        firstItem.choices[index] = updateCount;
                                        stateVote[
                                                firstItem.choices[index].id] ==
                                            true;
                                      }
                                    });
                                  },
                          ),
                          title: Text(
                            firstItem.choices[index].choiceText ?? "",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Text("${firstItem.choices[index].count}"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
