import 'package:flutter/material.dart';

class ShowRecipe extends StatelessWidget {
  final List<String> steps;
  const ShowRecipe({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Steps'),
        ),
        body: PageView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("STEP ${index + 1} / ${steps.length} "),
                  ListTile(
                      title: Center(
                    child: Text(steps[index]),
                  ))
                ]);
          },
        ));
  }
}
