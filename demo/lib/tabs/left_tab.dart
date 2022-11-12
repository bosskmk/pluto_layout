import 'package:flutter/widgets.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../example_text.dart';

class LeftTab extends StatelessWidget {
  const LeftTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PlutoLayoutTabs(
      mode: PlutoLayoutTabMode.showSelected,
      draggable: true,
      tabViewSizeResolver: const PlutoLayoutTabViewSizeConstrains(
        minSize: 100,
      ),
      items: [
        PlutoLayoutTabItem(
          id: ExampleText.aboutTitle,
          title: ExampleText.aboutTitle,
          showRemoveButton: true,
          sizeResolver: const PlutoLayoutTabItemSizeInitial(300),
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: const [
                Text(ExampleText.aboutTitle),
                SizedBox(height: 15),
                Text(ExampleText.aboutDesc1),
                SizedBox(height: 10),
                Text(ExampleText.aboutDesc2),
              ],
            ),
          ),
        ),
        PlutoLayoutTabItem(
          id: ExampleText.aboutLayoutTitle,
          title: ExampleText.aboutLayoutTitle,
          showRemoveButton: true,
          sizeResolver: const PlutoLayoutTabItemSizeFlexible(0.7),
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: const [
                Text(ExampleText.aboutLayoutTitle),
                SizedBox(height: 15),
                Text(ExampleText.aboutLayoutDesc1),
                SizedBox(height: 10),
                Text(ExampleText.aboutLayoutDesc2),
              ],
            ),
          ),
        ),
        PlutoLayoutTabItem(
          id: ExampleText.nestedTabsTitle,
          title: ExampleText.nestedTabsTitle,
          showRemoveButton: true,
          sizeResolver: const PlutoLayoutTabItemSizeFlexible(0.3),
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: const [
                Text(ExampleText.nestedTabsTitle),
                SizedBox(height: 15),
                Text(ExampleText.nestedTabsDesc1),
                SizedBox(height: 10),
                Text(ExampleText.nestedTabsDesc2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
