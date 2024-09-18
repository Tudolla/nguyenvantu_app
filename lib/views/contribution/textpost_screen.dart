import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../components/core/app_text_style.dart';
import '../../providers/get_textpost_provider.dart';

class TextPostListScreen extends ConsumerStatefulWidget {
  const TextPostListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TextPostListScreenState();
}

class _TextPostListScreenState extends ConsumerState<TextPostListScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<double> _animation;
  bool _isDownExpanded = false;
  @override
  void initState() {
    super.initState();
    ref.read(textPostViewModelProvider.notifier).loadTextPost();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDateFromApi(String dateString) {
    // Chuyển đổi chuỗi ISO 8601 sang DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // Sử dụng DateFormat để format lại DateTime thành dd-MM-yyyy
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final textPostState = ref.watch(textPostViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "List TextPost",
          style: AppTextStyle.appBarStyle,
        ),
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
                color: Colors.blueGrey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        _isDownExpanded = !_isDownExpanded;
                      });
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "News in day: ${formatDateFromApi(post.createdAt!)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppTextStyle.drawerFontStyle,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: LottieBuilder.asset("assets/mybell.json"),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          post.title!,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppTextStyle.drawerFontStyle,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          height: 50,
                          child: LottieBuilder.asset(
                            "assets/dropdown.json",
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    alignment: Alignment.topLeft,
                    duration: Duration(microseconds: 500),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: _isDownExpanded
                          ? BoxConstraints()
                          : BoxConstraints(maxHeight: 0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          post.description!,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppTextStyle.drawerFontStyle,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
