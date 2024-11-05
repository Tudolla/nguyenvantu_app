import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_textstyle.dart';

import '../../providers/get_pollpost_provider.dart';
import '../../providers/vote_pollpost_provider.dart';
import '../base/base_view.dart';

class PollPostScreen extends ConsumerStatefulWidget {
  const PollPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollPostScreenState();
}

class _PollPostScreenState extends BaseView<PollPostScreen> {
  @override
  void onInit() {
    super.onInit();
    ref.read(pollPostViewModelProvider.notifier).loadPollPost();
  }

  @override
  String? getScreenTitle() => "pollpost and vote";

  @override
  Widget buildBody(BuildContext context) {
    // watch to get post
    final statePollPost = ref.watch(pollPostViewModelProvider);
    // watch to update state of pollpost
    final stateVote = ref.watch(votePollpostViewModelProvider);
    // vote post
    final voteViewModel = ref.watch(votePollpostViewModelProvider.notifier);

    return statePollPost.when(
      data: (pollpost) {
        if (pollpost.isEmpty) {
          return const Center(
            child: Text("No notification today!"),
          );
        }

        final firstItemPost = pollpost[0];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstItemPost.title!,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: firstItemPost.choices.length,
                  itemBuilder: (context, index) {
                    final choice = firstItemPost.choices[index];
                    // check if User vote for id choice then disable this choice
                    final isVoted = stateVote[choice.id] ?? false;
                    // check if User has voted for any choice, then disabable every other choice
                    final hasVoted = voteViewModel.hasVoted();
                    final isSelected =
                        voteViewModel.selectedChoiceId == choice.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isSelected
                            ? Colors.lightBlueAccent.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Checkbox(
                              value: isVoted,
                              shape: const CircleBorder(),
                              onChanged: (hasVoted || isVoted)
                                  ? null
                                  : (bool? value) {
                                      if (value == true) {
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
                              choice.choiceText ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: AppTextStyle.appFont,
                                fontSize: 20,
                              ),
                            ),
                            trailing: Text(
                              "${choice.count}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: AppTextStyle.appFont,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // if a choice is voted then pop up the button
              if (voteViewModel.hasVoted())
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(votePollpostViewModelProvider.notifier)
                          .removeVote();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      backgroundColor: Colors.blueGrey,

                      // Màu đỏ cho nút "Bỏ chọn"
                    ),
                    child: const Text(
                      "Bỏ chọn",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      error: (e, stackTrace) => buildErrorWidget(e, stackTrace),
      loading: () => buildLoadingWidget(),
    );
  }
}
