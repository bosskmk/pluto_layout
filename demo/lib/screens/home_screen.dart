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
            constraints: const BoxConstraints(maxWidth: 800),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(ExampleText.bodyTitle),
                  SizedBox(height: 15),
                  Text(ExampleText.bodyDesc1),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
