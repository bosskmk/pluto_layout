import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../example_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlutoLayoutTabsOrChild(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 800,
            ),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(ExampleText.homeTitle, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 15),
                  Text(ExampleText.homeDesc1),
                  SizedBox(height: 50),
                  _FeatureContainer(
                    title: ExampleText.homeDraggableTab,
                    features: [
                      _Feature(description: ExampleText.homeDraggableTabDesc),
                    ],
                  ),
                  SizedBox(height: 50),
                  _FeatureContainer(
                    title: ExampleText.homeShortcutsTitle,
                    features: [
                      _Feature(description: ExampleText.homeShortcutsDesc),
                      _Feature(
                        title: ExampleText.homeShortcutsAlt1Title,
                        description: ExampleText.homeShortcutsAlt1Desc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsAlt2Title,
                        description: ExampleText.homeShortcutsAlt2Desc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsShiftNTitle,
                        description: ExampleText.homeShortcutsShiftNDesc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsShiftWTitle,
                        description: ExampleText.homeShortcutsShiftWDesc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsEscapeTitle,
                        description: ExampleText.homeShortcutsEscapeDesc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsAltArrowUpDownTitle,
                        description:
                            ExampleText.homeShortcutsAltArrowUpDownDesc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsControlArrowUpDownTitle,
                        description:
                            ExampleText.homeShortcutsControlArrowUpDownDesc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsTabOrShiftTabTitle,
                        description: ExampleText.homeShortcutsTabOrShiftTabDesc,
                      ),
                      _Feature(
                        title: ExampleText
                            .homeShortcutsControlAltArrowLeftRightTitle,
                        description: ExampleText
                            .homeShortcutsControlAltArrowLeftRightDesc,
                      ),
                      _Feature(
                        title: ExampleText.homeShortcutsEnterTitle,
                        description: ExampleText.homeShortcutsEnterDesc,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureContainer extends StatelessWidget {
  const _FeatureContainer({
    required this.title,
    required this.features,
  });

  final String title;

  final List<_Feature> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final lastItem = features.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final feature in features)
                    if (lastItem != feature) ...[
                      feature,
                      const SizedBox(height: 15),
                    ] else
                      feature,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    this.title,
    required this.description,
  });

  final String? title;

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      direction: Axis.horizontal,
      children: [
        if (title != null) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.secondaryHeaderColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(title!),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Text(description),
      ],
    );
  }
}
