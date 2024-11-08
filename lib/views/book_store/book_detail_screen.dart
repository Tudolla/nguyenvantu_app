import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/components/bottom_snackbar/bottom_snackbar.dart';
import 'package:monstar/components/core/app_colors.dart';

import '../../components/button/arrow_back_button.dart';
import '../../components/core/app_textstyle.dart';
import '../../gen/assets.gen.dart';
import '../../providers/get_book_detail_provider.dart';
import '../../providers/reading_book_tracking_provider.dart';
import '../base/base_view.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final int id;

  BookDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookDetailScreenState();
}

class _BookDetailScreenState extends BaseView<BookDetailScreen> {
  @override
  void loadInitialData() {
    ref.read(bookDetailViewModelProvider.notifier).loadDetailBook(widget.id);
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final stateDetailBook = ref.watch(bookDetailViewModelProvider);

    return AppBar(
      backgroundColor: AppColors.paperYellow,
      title: Text(
        "Story Content",
        style: TextStyle(
          fontFamily: AppTextStyle.drawerFontStyle,
          color: const Color.fromARGB(255, 109, 105, 105),
        ),
      ),
      centerTitle: true,
      leading: ArrowBackButton(
        popScreen: true,
        showSnackbar: false,
        onTap: () {
          ref
              .read(readingTrackingViewModelProvider.notifier)
              .endReading(widget.id);
        },
      ),
      actions: [
        stateDetailBook.when(
          data: (bookDetail) => bookDetail != null
              ? IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: bookDetail.content ?? ""),
                    );
                    bottomSnackbar(context, "Copied story", null);
                  },
                  icon: Icon(Icons.copy_all_outlined),
                )
              : Container(),
          error: (e, stackTrace) => buildErrorWidget(e, stackTrace),
          loading: () => buildLoadingWidget(),
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final stateDetailBook = ref.watch(bookDetailViewModelProvider);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: stateDetailBook.when(
        data: (bookDetail) {
          if (bookDetail == null) {
            return Center(
              child: Text("Nothing to show"),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        bookDetail.title ?? "",
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'ReadingFont',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 100,
                        child: LottieBuilder.asset(Assets.book),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Thể loại: ${bookDetail.type}",
                  style: TextStyle(
                    fontFamily: 'ReadingFont',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Colors.black),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  width: size.width / 3,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.5),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Lượt đọc: ${bookDetail.views}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  bookDetail.content ?? "",
                  style: TextStyle(fontFamily: 'ReadingFont'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
        error: (e, stackTrace) => buildErrorWidget(e, stackTrace),
        loading: () => buildLoadingWidget(),
      ),
    );
  }

  @override
  Color? get backgroundColor => AppColors.paperYellow;
}
