import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/views/company_introduction/company_mission_detail_screen.dart';
import 'package:monstar/views/company_introduction/viewmodel/company_mission_view_model.dart';

class CompanyMissionVisionScreen extends ConsumerWidget {
  const CompanyMissionVisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyMisison = ref.watch(companyMissionViewmodelProvider);

    List<String> missionTitle = [
      "Đổi mới hướng đến khách hàng",
      "Hợp tác toàn cầu liền mạch",
      "Tạo giá trị cho xã hội",
      "Trao quyền cho nhân tài",
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mission and Vision",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
      ),
      body: companyMisison.when(
        data: (data) {
          return Center(
            child: MasonryGridView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              children: [
                Text(
                  "Monstarlab",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    height: 1.2,
                  ),
                ),
                for (int i = 0; i < missionTitle.length; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyMissionDetailScreen(
                            missionTitle: missionTitle[i],
                            descrptionMission: data.visions[i].description,
                            heroTag: 'mission_$i',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.4,
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: AspectRatio(
                                aspectRatio: 0.95,
                                child: Hero(
                                  tag: 'mission_$i',
                                  child: Image.asset(
                                    "assets/images/5898.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            missionTitle[i],
                          ),
                        ],
                      ),
                    ),
                  ),
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
    );
  }
}
