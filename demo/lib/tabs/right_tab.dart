import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../example_text.dart';
import '../helper/launch_url.dart';

class RightTab extends StatelessWidget {
  const RightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PlutoLayoutTabs(
      draggable: true,
      items: [
        PlutoLayoutTabItem(
          id: ExampleText.donateTitle,
          title: ExampleText.donateTitle,
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                const Text(ExampleText.donateTitle),
                const SizedBox(height: 15),
                const Text(ExampleText.donateDesc1),
                const SizedBox(height: 50),
                Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl('https://github.com/sponsors/bosskmk');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(15),
                        constraints: const BoxConstraints(
                          maxWidth: 213.7,
                          minHeight: 32,
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.favorite, color: Colors.pink),
                            Expanded(
                              child: Text(
                                'Github Sponsor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  overflow: TextOverflow.fade,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl('https://www.buymeacoffee.com/manki');
                      },
                      child: Image.asset(
                        'assets/buy_me_a_coffee.png',
                        height: 60,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PlutoLayoutTabItem(
          id: ExampleText.jetbrainsTitle,
          title: ExampleText.jetbrainsTitle,
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                const Text(ExampleText.jetbrainsTitle),
                const SizedBox(height: 15),
                const Text(ExampleText.jetbrainsDesc1),
                const SizedBox(height: 50),
                Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                            'https://www.jetbrains.com/community/opensource/#support');
                      },
                      child: Image.asset(
                        'assets/jb_beam.png',
                        height: 150,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
