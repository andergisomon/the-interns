import 'package:flutter/material.dart';
import 'wellness_report_screen.dart';

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
          const SizedBox(
            height: 100,
            width: 130,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                "Being a caregiver can be tough, you might have to juggle a lot of things at once and have trouble tracking everything.",
                style: TextStyle(fontFamily: 'Work Sans'),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(top: 8.0, start: 4.0, bottom: 10.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                'Tools to help',
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
                  if (index == 4) {
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
                    label: image.title,
                    description: image.subtitle,
                    imageInfo: image,
                    onTap: image == ImageInfo.image4 // Check if it's the last card
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
          const Padding(
            padding: EdgeInsetsDirectional.only(top: 8.0, start: 4.0, bottom: 0.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                'New parent or about to be?',
                style: TextStyle(fontSize: 22, fontFamily: 'Work Sans Semibold'),
              ),
            ),
          ),
          const SizedBox(
            height: 230,
            width: 300,
            child: Image(
              image: AssetImage('assets/images/parent.png'),
            ),
          ),
          const SizedBox(
            height: 100,
            width: 130,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                "Nobody gets it right the first time. Transitioning into the life of a parent can be challenging, many things aren't obvious at first glance.",
                style: TextStyle(fontFamily: 'Work Sans'),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                  onPressed: () {},
                  child: const Text('Get started'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
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
  image0('Daily routines', 'Set up specific routines and checklists to be done regularly. Never forget anything again.', 'daily_routine.png'),
  image1('Consumables', 'Define supplies that may run out, track how much you have left and set reminders to restock.', 'consumables.png'),
  image2('Reach out', 'Feel seen. Guide others. Find a community of people to relate to and make your days feel a little bit lighter.', 'reach_out.png'),
  image3('Need to vent?', "Sometimes, all we need is to feel that we're being heard. A shoulder that doesn't judge can help us weather bad times.", 'vent.png'),
  image4('Wellness report', 'Privately analyze your data and generate a brief report of how things are going', 'wellness.png');

  const ImageInfo(this.title, this.subtitle, this.url);
  final String title;
  final String subtitle;
  final String url;
}