import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/views/company_introduction/company_mission_detail_screen.dart';
import 'package:monstar/views/company_introduction/viewmodel/company_mission_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CompanyMissionVisionScreen extends ConsumerStatefulWidget {
  const CompanyMissionVisionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompanyMissionVisionScreenState();
}

class _CompanyMissionVisionScreenState
    extends ConsumerState<CompanyMissionVisionScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Skeletonizer(
        enabled: _loading || companyMisison.isLoading,
        child: companyMisison.maybeWhen(
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
                                      "assets/images/target.jpg",
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
          // Đang trong trạng thái Loading, trả về 1 Widget có kích thước 0x0 pixel
          orElse: () => SizedBox.shrink(),
        ),
      ),
    );
  }
}
