import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/get_list_book_provider.dart';

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
      appBar: AppBar(
        title: const Text("Funny story"),
        centerTitle: true,
      ),
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

            return ListView.builder(
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                final book = bookList[index];
                return ListTile(
                  title: Text(book.title ?? ""),
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
