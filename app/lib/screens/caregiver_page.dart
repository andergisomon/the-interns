import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('Caregiver'), // Add an AppBar title
      ),
      
      body: ListView(
      children: <Widget>[
        const SizedBox(height: 270, width: 300,
                    child: Image(image: AssetImage('assets/images/caregiver_hero.png'),
                          )
                  ),

        const SizedBox(
          height: 100, width: 130,
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text("Being a caregiver can be tough, you might have to juggle a lot of things at once and have trouble tracking everything.",
                          style: TextStyle(fontFamily: 'Work Sans'),
                          textAlign: TextAlign.left,
                          ),
                        )
        ),
        const Padding(
          padding: EdgeInsetsDirectional.only(top: 8.0, start: 4.0, bottom: 10.0),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          child: Text('Tools to help',
                                      style: TextStyle(fontSize: 22, fontFamily: 'Work Sans Semibold'),
                                      ),
                                )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 450),
            child: CarouselView(
              itemExtent: 330,
              shrinkExtent: 330,
              children: 
          ImageInfo.values.map((ImageInfo image) {
              return UncontainedLayoutCard(index: image.index, label: image.title, description: image.subtitle, imageInfo: image);
            }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        const Padding(
          padding: EdgeInsetsDirectional.only(top: 8.0, start: 4.0, bottom: 0.0),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          child: Text('New parent or about to be?',
                                      style: TextStyle(fontSize: 22, fontFamily: 'Work Sans Semibold'),
                                      ),
                                )
        ),
        const SizedBox(height: 230, width: 300,
                    child: Image(image: AssetImage('assets/images/parent.png'),
                          )
                  ),

        const SizedBox(
          height: 100, width: 130,
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text("Nobody gets it right the first time. Transitioning into the life of a parent can be challenging, many things aren't obvious at first glance.",
                          style: TextStyle(fontFamily: 'Work Sans'),
                          textAlign: TextAlign.left,
                          ),
                        )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 45,
              width: 150, // Adjust the width as needed
              child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8A2BE2), // Friendly, maternal shade of purple/violet
            foregroundColor: Colors.white, // White text color
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
    )
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
  });

  final int index;
  final String label;
  final String description;
  final ImageInfo imageInfo;

  @override
  Widget build(BuildContext context) {
    // Use Color.withAlpha() instead of withOpacity()
    final Color backgroundColor = Colors.primaries[index % Colors.primaries.length].withAlpha((0.5 * 255).round());
    
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/caregiver_carousel/${imageInfo.url}',
              width: 330,
              height: 268, // One more pixel and this card will overflow
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Work Sans Black'),
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
            const SizedBox(height: 8),
            // ignore: sized_box_for_whitespace
            Container(
              width: 400,
              height: 110,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0), // Example: 16 pixels horizontal padding
                child: Text(
                  description, // Replace with your actual description variable
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CardInfo {
  camera('Cameras', Icons.video_call, Color(0xff2354C7), Color(0xffECEFFD)),
  lighting('Lighting', Icons.lightbulb, Color(0xff806C2A), Color(0xffFAEEDF)),
  climate('Climate', Icons.thermostat, Color(0xffA44D2A), Color(0xffFAEDE7)),
  wifi('Wifi', Icons.wifi, Color(0xff417345), Color(0xffE5F4E0)),
  media('Media', Icons.library_music, Color(0xff2556C8), Color(0xffECEFFD)),
  security('Security', Icons.crisis_alert, Color(0xff794C01), Color(0xffFAEEDF)),
  safety('Safety', Icons.medical_services, Color(0xff2251C5), Color(0xffECEFFD)),
  more('', Icons.add, Color(0xff201D1C), Color(0xffE3DFD8));

  const CardInfo(this.label, this.icon, this.color, this.backgroundColor);
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
}

enum ImageInfo {
  image0('Daily routines', 'Set up specific routines and checklists to be done regularly. Never forget anything again.', 'daily_routine.png'),
  image1('Consumables', 'Define supplies that may run out, track how much you have left and set reminders to restock.', 'consumables.png',),
  image2('Reach out', 'Feel seen. Guide others. Find a community of people to relate to and make your days feel a little bit lighter.', 'reach_out.png'),
  image3('Need to vent?', "Sometimes, all we need is to feel that we're being heard. A shoulder that doesn't judge can help us weather bad times.", 'vent.png');
  // image4('Blue Symphony', 'Sponsored | Season 1 Now Streaming', 'content_based_color_scheme_5.png'),
  // image5('When It Rains', 'Sponsored | Season 1 Now Streaming', 'content_based_color_scheme_6.png');

  const ImageInfo(this.title, this.subtitle, this.url);
  final String title;
  final String subtitle;
  final String url;
}