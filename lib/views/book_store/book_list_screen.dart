import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/book_store/book_detail_screen.dart';

import '../../providers/get_list_book_provider.dart';
import '../../providers/reading_book_tracking_provider.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookListScreenState();
}

class _BookListScreenState extends ConsumerState<BookListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(bookListViewModelProvider.notifier).loadListBook();
  }

  @override
  Widget build(BuildContext context) {
    final stateListBook = ref.watch(bookListViewModelProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
        ),
        child: stateListBook.when(
          data: (bookList) {
            if (bookList.length == 0 || bookList.isEmpty) {
              return Center(
                child: Text("Nothing att all, wait for the next day"),
              );
            }
            ;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0, // Khoảng cách các cột
                mainAxisSpacing: 10.0, // Khoảng cách các hàng
                childAspectRatio: 0.85, // Tỉ lệ rộng / cao của item
              ),
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                final itemBook = bookList[index];
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(readingTrackingViewModelProvider.notifier)
                        .startRading(itemBook.id!);
                    Get.to(BookDetailScreen(id: itemBook.id!));
                  },
                  child: Card(
                    elevation: 4,
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            itemBook.type != null
                                ? (itemBook.type!.contains("cuoi")
                                    ? "Truyện cười"
                                    : "Truyện tâm linh")
                                : "",
                            style: TextStyle(
                              fontFamily: AppTextStyle.secureFontStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Số: ${itemBook.id}",
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            itemBook.title ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: AppTextStyle.regularFontStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          error: (e, stackTrace) {
            return Center(
              child: Text("Failed to load story: $e"),
            );
          },
          loading: () => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
