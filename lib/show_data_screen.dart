import 'package:flutter/material.dart';

class ShowDataScreen extends StatelessWidget {
  ShowDataScreen({Key? key, this.sharedText});

  String? sharedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Show Data Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Shared Data  ",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text(sharedText ?? '', style: const TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }
}
