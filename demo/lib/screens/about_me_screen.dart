import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helper/launch_url.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('About Me'),
                const SizedBox(height: 15),
                const Text(
                  'I develop Flutter packages as a hobby as a backend developer.\n'
                  'I am interested in developing CMS or administrator services.\n'
                  'I like to improve the convenience of users who use CMS or administrator services.\n',
                  textAlign: TextAlign.left,
                ),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 10.0,
                  children: [
                    TextButton.icon(
                      label: const Text('Github'),
                      onPressed: () => launchUrl('https://github.com/bosskmk'),
                      icon: const FaIcon(FontAwesomeIcons.github),
                    ),
                    TextButton.icon(
                      label: const Text('Youtube'),
                      onPressed: () => launchUrl(
                          'https://www.youtube.com/channel/UCNhIXBPlLI_y8wkQQw-_ImQ'),
                      icon: const FaIcon(
                        FontAwesomeIcons.youtube,
                        color: Color(0xFFFD0001),
                        size: 22,
                      ),
                    ),
                    TextButton.icon(
                      label: const Text('Twitch'),
                      onPressed: () =>
                          launchUrl('https://www.twitch.tv/bosskmk'),
                      icon: const FaIcon(
                        FontAwesomeIcons.twitch,
                        color: Color(0xFF9447FE),
                      ),
                    ),
                    TextButton.icon(
                      label: const Text('Pub.dev'),
                      onPressed: () => launchUrl(
                          'https://pub.dev/publishers/weblaze.dev/packages'),
                      icon: const FaIcon(
                        FontAwesomeIcons.link,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
