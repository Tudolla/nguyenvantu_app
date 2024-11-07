import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_textstyle.dart';

import 'package:monstar/views/book_store/book_detail_screen.dart';

import '../../providers/get_list_book_provider.dart';
import '../../providers/reading_book_tracking_provider.dart';
import '../base/base_view.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookListScreenState();
}

class _BookListScreenState extends BaseView<BookListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
  }

  @override
  void loadInitialData() {
    final bookListState = ref.read(bookListViewModelProvider);
    if (bookListState is! AsyncData || (bookListState.value?.isEmpty ?? true)) {
      ref.read(bookListViewModelProvider.notifier).loadListBook();
    }
  }

  void setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(bookListViewModelProvider.notifier).loadMoreBooks();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Future<void> onRefresh() async {
    await ref.read(bookListViewModelProvider.notifier).loadListBook();
  }

  @override
  Widget buildBody(BuildContext context) {
    final stateListBook = ref.watch(bookListViewModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: stateListBook.when(
        data: (bookList) {
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.85,
            ),
            itemCount: bookList.length + 1,
            itemBuilder: (context, index) {
              if (index == bookList.length) {
                return Center(
                  child:
                      ref.read(bookListViewModelProvider.notifier).isLoadingMore
                          ? const CircularProgressIndicator()
                          : const SizedBox.shrink(),
                );
              }
              final itemBook = bookList[index];
              return GestureDetector(
                onTap: () {
                  ref
                      .read(readingTrackingViewModelProvider.notifier)
                      .startRading(itemBook.id!);
                  pushScreen(BookDetailScreen(id: itemBook.id!));
                },
                child: Card(
                  elevation: 4,
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
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
                        const SizedBox(height: 20),
                        Text("Số: ${itemBook.id}"),
                        const SizedBox(height: 2),
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
        error: (e, _) => buildErrorWidget(e, _),
        loading: () => buildLoadingWidget(),
      ),
    );
  }
}
