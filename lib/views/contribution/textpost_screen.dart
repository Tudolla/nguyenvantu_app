import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../components/core/app_textstyle.dart';
import '../../gen/assets.gen.dart';
import '../../providers/get_textpost_provider.dart';

class TextPostListScreen extends ConsumerStatefulWidget {
  const TextPostListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TextPostListScreenState();
}

class _TextPostListScreenState extends ConsumerState<TextPostListScreen>
    with SingleTickerProviderStateMixin {
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
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              padding: const EdgeInsets.all(
                15,
              ), // Thêm padding để hiển thị thoáng hơn
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Viền tròn vừa phải
                color: Colors.transparent, // Nền trong suốt
                border: Border.all(
                  // Viền nâu xung quanh
                  color: Colors.brown,
                  width: 1.5,
                ),
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
                            color: Colors.black, // Sử dụng màu tối cho văn bản
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
                          // Đảm bảo không bị tràn ra ngoài màn hình
                          child: Text(
                            post.title!,
                            style: TextStyle(
                              color: Colors.black, // Giữ màu đen cho tiêu đề
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
                  AnimatedSize(
                    alignment: Alignment.topLeft,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: _isDownExpanded
                          ? BoxConstraints()
                          : BoxConstraints(maxHeight: 0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                        child: Text(
                          post.description!,
                          style: TextStyle(
                            color: Colors.black87, // Màu văn bản tối để dễ nhìn
                            fontFamily: AppTextStyle.appFont,
                            fontSize: 22,
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
