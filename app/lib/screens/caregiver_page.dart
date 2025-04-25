import 'package:flutter/material.dart';
import 'wellness_report_screen.dart';
import 'supplies_shop_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CaregiverScreen extends StatefulWidget {
  const CaregiverScreen({super.key});

  @override
  State<CaregiverScreen> createState() => _CaregiverScreenState();
}

class _CaregiverScreenState extends State<CaregiverScreen> {
  final CarouselController controller = CarouselController(initialItem: 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 270,
            width: 300,
            child: Image(
              image: AssetImage('assets/images/caregiver_hero.png'),
            ),
          ),
           SizedBox(
            height: 100,
            width: 130,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                AppLocalizations.of(context)!.caregiverDescription,
                style: TextStyle(fontFamily: 'Work Sans'),
                textAlign: TextAlign.left,
              ),
            ),
          ),
           Padding(
            padding: EdgeInsetsDirectional.only(top: 8.0, start: 4.0, bottom: 10.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                AppLocalizations.of(context)!.caregiverToolsToHelp,
                style: TextStyle(fontSize: 22, fontFamily: 'Work Sans Semibold'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 450),
              child: CarouselView(
                onTap: (int index) {
                  if (index == 1) { // Second card is wellness report
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WellnessReportScreen(),
                              ),
                            );
                  }
                },
                itemExtent: 330,
                shrinkExtent: 330,
                children: ImageInfo.values.map((ImageInfo image) {
                  return UncontainedLayoutCard(
                    index: image.index,
                    label: ImageInfo.getTitle(context, image),
                    description: ImageInfo.getSubtitle(context, image),
                    imageInfo: image,
                    onTap: image == ImageInfo.image1 // Check if it's the second card // Check if it's the last card
                        ? () {
                            print("Navigating to WellnessReportScreen");
                            
                          }
                        : null,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
           Padding(
            padding: EdgeInsetsDirectional.only(top: 8.0, start: 4.0, bottom: 0.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                AppLocalizations.of(context)!.caregiverShopSupplies,
                style: TextStyle(fontSize: 22, fontFamily: 'Work Sans Semibold'),
              ),
            ),
          ),
          SizedBox(height: 8.0,),
          const SizedBox(
              height: 200,
              width: 300,
              child: Image(
                image: AssetImage('assets/images/shop_splash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
           SizedBox(
            height: 90,
            width: 130,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Text(
                AppLocalizations.of(context)!.caregiverShopDescription,
                style: TextStyle(fontFamily: 'Work Sans'),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
            height: 45,
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8A2BE2),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16, fontFamily: 'Work Sans Semibold'),
              ),
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => SuppliesShopScreen(),
                ),
              );
              },
              child: Text(AppLocalizations.of(context)!.caregiverShopNow),
            ),
            ),
          ),
          ),
          SizedBox(height: 48.0)
        ],
      ),
    );
  }
}

// Recommendation cards

class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
    required this.description,
    required this.imageInfo,
    this.onTap,
  });

  final int index;
  final String label;
  final String description;
  final ImageInfo imageInfo;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.primaries[index % Colors.primaries.length].withAlpha((0.5 * 255).round());

return InkWell(
      onTap: onTap,
        child:
         ColoredBox(
          color: backgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/caregiver_carousel/${imageInfo.url}',
                  width: 330,
                  height: 268,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Work Sans Black'),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 400,
                  height: 110,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      description,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      // ), //SizedBox
    );

  }
}

enum ImageInfo {
  image0('daily_routine.png'),
  image1('wellness.png'),
  image2('reach_out.png'),
  image3('vent.png');

  const ImageInfo(this.url);
  final String url;

  static String getTitle(BuildContext context, ImageInfo image) {
    switch (image) {
      case ImageInfo.image0:
        return AppLocalizations.of(context)!.caregiverDailyRoutinesTitle;
      case ImageInfo.image1:
        return AppLocalizations.of(context)!.caregiverWellnessReportTitle;
      case ImageInfo.image2:
        return AppLocalizations.of(context)!.caregiverReachOutTitle;
      case ImageInfo.image3:
        return AppLocalizations.of(context)!.caregiverVentOutTitle;
    }
  }

  static String getSubtitle(BuildContext context, ImageInfo image) {
    switch (image) {
      case ImageInfo.image0:
        return AppLocalizations.of(context)!.caregiverDailyRoutinesSubtitle;
      case ImageInfo.image1:
        return AppLocalizations.of(context)!.caregiverWellnessReportSubtitle;
      case ImageInfo.image2:
        return AppLocalizations.of(context)!.caregiverReachOutSubtitle;
      case ImageInfo.image3:
        return AppLocalizations.of(context)!.caregiverVentOutSubtitle;
    }
  }
}