import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/views/company_introduction/viewmodel/company_mission_viewmodel.dart';

class CompanyMissionVisionScreen extends ConsumerWidget {
  const CompanyMissionVisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyMisison = ref.watch(companyMissionViewmodelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mission and Vision",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
      ),
      body: companyMisison.when(
        data: (companyMisison) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 20,
              left: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '${companyMisison.mission}',
                  ),
                  Text('${companyMisison.vision}'),
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
    );
  }
}
