import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final stateDetailBook = ref.watch(bookDetailViewModelProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Center(
          child: stateDetailBook.when(
            data: (bookDetail) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookDetail.title ?? ""),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(bookDetail.type ?? ""),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(bookDetail.content ?? ""),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(bookDetail.views.toString()),
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
      ),
    );
  }
}
