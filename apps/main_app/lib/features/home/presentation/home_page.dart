import 'package:design_system_app/design_system_app.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(Theme.of(context).primaryColor.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Example App"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Theme.of(context).primaryColor,
            ),
            ButtonExample(
              onPressed: () {
                debugPrint("Tapped it.");
              },
              text: "Tap it",
            ),
          ],
        ),
      ),
    );
  }
}
