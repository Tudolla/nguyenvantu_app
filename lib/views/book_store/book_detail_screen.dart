import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/components/core/color_reading.dart';

import '../../components/button/arrow_back_button.dart';
import '../../components/core/app_text_style.dart';
import '../../providers/get_book_detail_provider.dart';

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

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(bookDetailViewModelProvider.notifier).loadDetailBook(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final stateDetailBook = ref.watch(bookDetailViewModelProvider);
    return Scaffold(
      backgroundColor: BackgroundReading.paperYellow,
      appBar: AppBar(
        backgroundColor: BackgroundReading.paperYellow,
        title: Text(
          "Story for sharing",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
        leading: ArrowBackButton(
          popScreen: true,
          showSnackbar: false,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.copy_all_outlined),
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
                            "assets/book.json",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Thể loại: ${bookDetail.type}" ?? "",
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
          loading: () => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
