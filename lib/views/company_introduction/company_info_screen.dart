import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/company_introduction/viewmodel/company_info_viewmodel.dart';

class CompanyInfoScreen extends ConsumerWidget {
  const CompanyInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyInfo = ref.watch(companyInfoViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: companyInfo.when(
        data: (companyInfo) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 20,
              left: 20,
            ),
            child: Column(
              children: [
                Text('Name: ${companyInfo.name}'),
                Text('Name: ${companyInfo.amountStaff}'),
              ],
            ),
          );
        },
        error: (e, stackTrace) {
          return Center(
            child: Text('Error: $e'),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Gọi refresh khi bấm nút
          ref.read(companyInfoViewModelProvider.notifier).refresh();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
