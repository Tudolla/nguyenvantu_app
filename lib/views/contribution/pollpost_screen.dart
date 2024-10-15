import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_textstyle.dart';

import '../../providers/get_pollpost_provider.dart';
import '../../providers/vote_pollpost_provider.dart';

class PollPostScreen extends ConsumerStatefulWidget {
  const PollPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollPostScreenState();
}

class _PollPostScreenState extends ConsumerState<PollPostScreen>
    with AutomaticKeepAliveClientMixin<PollPostScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pollPostViewModelProvider.notifier).loadPollPost();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final statePollPost = ref.watch(pollPostViewModelProvider);
    final stateVote = ref.watch(votePollpostViewModelProvider);
    final voteViewModel = ref.watch(votePollpostViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Let make a choice",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
      ),
      body: statePollPost.when(
        data: (pollpost) {
          if (pollpost.isEmpty) {
            return Center(
              child: Text("No notification today!"),
            );
          }

          final firstItem = pollpost[0];

          return Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstItem.title!,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: firstItem.choices.length,
                    itemBuilder: (context, index) {
                      final choice = firstItem.choices[index];
                      final isVoted = stateVote[choice.id] ?? false;
                      final hasVoted = voteViewModel.hasVoted();
                      final isSelected =
                          voteViewModel.selectedChoiceId == choice.id;
                      return Container(
                        margin: const EdgeInsets.only(
                          top: 5,
                          right: 10,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSelected
                              ? Colors.lightBlueAccent.withOpacity(.3)
                              : Colors.grey.withOpacity(.2),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: isVoted,
                            shape: CircleBorder(),
                            onChanged: (hasVoted ||
                                    isVoted) // Không cho chọn lại khi đã chọn
                                ? null
                                : (bool? value) {
                                    if (value == true) {
                                      print(
                                          "Attempting to vote for choice: ${choice.id}");
                                      ref
                                          .read(
                                            votePollpostViewModelProvider
                                                .notifier,
                                          )
                                          .vote(choice.id!);
                                    }
                                  },
                          ),
                          title: Text(
                            firstItem.choices[index].choiceText ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppTextStyle.appFont,
                              fontSize: 20,
                            ),
                          ),
                          trailing: Text(
                            "${firstItem.choices[index].count}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: AppTextStyle.appFont,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (e, strackTrace) {
          return Center(
            child: Text("Having some error: $e"),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
