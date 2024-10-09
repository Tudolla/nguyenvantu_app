import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/views/company_introduction/viewmodel/company_info_view_model.dart';

class CompanyInfoScreen extends ConsumerWidget {
  const CompanyInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyInfo = ref.watch(companyInfoViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monstarlab Profile",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
      ),
      body: companyInfo.when(
        data: (companyInfo) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 20,
              left: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tên công ty:",
                    style: AppTextStyle.introductionCompanyStyle,
                  ),
                  Text(
                    '${companyInfo.name}\n',
                    style: TextStyle(color: Colors.brown),
                  ),
                  Text(
                    'Công ty chủ quản:',
                    style: AppTextStyle.introductionCompanyStyle,
                  ),
                  Text(
                    '${companyInfo.fatherCompany}\n',
                    style: TextStyle(color: Colors.brown),
                  ),
                  Text(
                    'Ngày thành lập :',
                    style: AppTextStyle.introductionCompanyStyle,
                  ),
                  Text(
                    '${companyInfo.foundingDate}\n',
                    style: TextStyle(color: Colors.brown),
                  ),
                  Text(
                    'CEO : ',
                    style: AppTextStyle.introductionCompanyStyle,
                  ),
                  Text(
                    '${companyInfo.ceo}\n',
                    style: TextStyle(color: Colors.brown),
                  ),
                  Text(
                    'Lĩnh vực hoạt động :',
                    style: AppTextStyle.introductionCompanyStyle,
                  ),
                  Text(
                    '${companyInfo.description}\n',
                    style: TextStyle(color: Colors.brown),
                  ),
                  Text(
                    'Số lượng nhân viên:',
                    style: AppTextStyle.introductionCompanyStyle,
                  ),
                  Text(
                    '${companyInfo.amountStaff}\n',
                    style: TextStyle(color: Colors.brown),
                  ),
                  Text(
                    'Địa chỉ:',
                    style: AppTextStyle.introductionCompanyStyle,
                  ),
                  Text(
                    '${companyInfo.address}\n',
                    style: TextStyle(color: Colors.brown),
                  ),
                ],
              ),
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
        shape: CircleBorder(),
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
