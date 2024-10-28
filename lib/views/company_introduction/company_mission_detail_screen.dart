import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_textstyle.dart';

class CompanyMissionDetailScreen extends ConsumerStatefulWidget {
  final String missionTitle;
  final String descrptionMission;
  final String heroTag;
  const CompanyMissionDetailScreen({
    super.key,
    required this.missionTitle,
    required this.descrptionMission,
    required this.heroTag,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompanyMissionDetailScreenState();
}

class _CompanyMissionDetailScreenState
    extends ConsumerState<CompanyMissionDetailScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: PageView.builder(
                    key: PageStorageKey<String>('pageview'),
                    onPageChanged: (value) => setState(() {
                      currentIndex = value;
                    }),
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    itemBuilder: (context, index) => AspectRatio(
                      aspectRatio: 0.9,
                      child: Hero(
                        tag: widget.heroTag,
                        child: Image.asset(
                          "assets/images/target.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 80,
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: Duration(
                          milliseconds: 200,
                        ),
                        margin: const EdgeInsets.only(bottom: 5),
                        width: 7,
                        height: index == currentIndex ? 20 : 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: index == currentIndex
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Text(
                widget.missionTitle,
                style: TextStyle(
                  fontFamily: AppTextStyle.secureFontStyle,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 2 - 190),
          ],
        ),
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height / 2 - 150,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
          color: const Color.fromARGB(255, 180, 233, 137),
        ),
        child: Text(widget.descrptionMission),
      ),
    );
  }
}
