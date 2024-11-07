import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/data/models/api/request/contribution_model/contribution_model.dart';
import 'package:monstar/views/base/base_view.dart';

import '../../components/core/app_textstyle.dart';
import '../../gen/assets.gen.dart';
import '../../providers/get_textpost_provider.dart';

class TextPostList extends StatefulWidget {
  final List<TextPostModel> posts;
  const TextPostList({
    super.key,
    required this.posts,
  });

  @override
  State<StatefulWidget> createState() => _TextPostListState();
}

class _TextPostListState extends State<TextPostList> {
  Map<int, bool> _isExpandedMap = {};

  String formatDateFromApi(String dateString) {
    // Chuyển đổi chuỗi ISO 8601 sang DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // Sử dụng DateFormat để format lại DateTime thành dd-MM-yyyy
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.posts.isEmpty) {
      return Center(
        child: Text("No notification today!"),
      );
    }
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        return PostListItem(
          post: widget.posts[index],
          isExpanded: _isExpandedMap[index] ?? false,
          onToggleExpand: () {
            setState(() {
              _isExpandedMap[index] = !(_isExpandedMap[index] ?? false);
            });
          },
          formatDate: formatDateFromApi,
        );
      },
    );
  }
}

class PostListItem extends StatelessWidget {
  final TextPostModel post;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final String Function(String) formatDate;

  const PostListItem({
    super.key,
    required this.post,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        border: Border.all(
          color: Colors.brown,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onToggleExpand,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "News in day: ${formatDate(post.createdAt!)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: AppTextStyle.appFont,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: LottieBuilder.asset(Assets.mybell),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    post.title!,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppTextStyle.appFont,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: LottieBuilder.asset("assets/dropdown.json"),
                ),
              ],
            ),
          ),
          PostDescription(
            description: post.description!,
            isExpanded: isExpanded,
          ),
        ],
      ),
    );
  }
}

class PostDescription extends StatelessWidget {
  final String description;
  final bool isExpanded;

  const PostDescription({
    super.key,
    required this.description,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topLeft,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: ConstrainedBox(
        constraints: isExpanded
            ? const BoxConstraints()
            : const BoxConstraints(maxHeight: 0),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5.0),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: AppTextStyle.appFont,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class TextPostListScreen extends ConsumerStatefulWidget {
  const TextPostListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TextPostListScreenState();
}

class _TextPostListScreenState
    extends BaseViewKeepAliveMixin<TextPostListScreen>
    with SingleTickerProviderStateMixin {
  @override
  void loadInitialData() {
    ref.read(textPostViewModelProvider.notifier).loadTextPost();
  }

  @override
  String? getScreenTitle() => "list textpost";

  @override
  Widget buildBody(BuildContext context) {
    final textPostState = ref.watch(textPostViewModelProvider);
    return textPostState.when(
      data: (posts) {
        return TextPostList(posts: posts);
      },
      error: (e, stackTrace) => buildErrorWidget(e, stackTrace),
      loading: () {
        return textPostState.maybeWhen(
          data: (oldPosts) => Stack(
            children: [
              TextPostList(posts: oldPosts),
              Container(
                color: Colors.black.withOpacity(.4),
                child: buildLoadingWidget(),
              ),
            ],
          ),
          orElse: () => buildLoadingWidget(),
        );
      },
    );
  }
}
