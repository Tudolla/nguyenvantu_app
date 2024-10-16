import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/components/core/app_colors.dart';

import '../../components/button/arrow_back_button.dart';
import '../../components/core/app_textstyle.dart';
import '../../components/loading/loading.dart';
import '../../gen/assets.gen.dart';
import '../../providers/get_book_detail_provider.dart';
import '../../providers/reading_book_tracking_provider.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final int id;

  const BookDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    ref.read(bookDetailViewModelProvider.notifier).loadDetailBook(widget.id);
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   // Call endReading when the widget is disposed
  //   ref.read(readingTrackingViewModelProvider.notifier).endReading(widget.id);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Application is in background (e.g., user presses Home button)
  //     ref.read(readingTrackingViewModelProvider.notifier).endReading(widget.id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final stateDetailBook = ref.watch(bookDetailViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.paperYellow,
      appBar: AppBar(
        backgroundColor: AppColors.paperYellow,
        title: Text(
          "Story for sharing",
          style: AppTextStyle.appBarStyle,
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

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.blueGrey,
                          content: Text("Copied story you want"),
                        ),
                      );
                    },
                    icon: Icon(Icons.copy_all_outlined),
                  )
                : Container(), // TH bookDetail == null
            error: (e, stackTrace) => Container(),
            loading: () => Container(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          softWrap: true,
                          bookDetail.title ?? "",
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
                          child: LottieBuilder.asset(
                            Assets.book,
                          ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                        "Lượt đọc: ${bookDetail.views.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    bookDetail.content ?? "",
                    style: TextStyle(
                      fontFamily: 'ReadingFont',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
          error: (e, stackTrace) {
            return Center(
              child: Text("Fail to load detail: ${e}"),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
