import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowRecipeSteps extends StatelessWidget {
  final List<String> steps;
  const ShowRecipeSteps({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.steps),
        ),
        body: PageView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return ListView(children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                    "${AppLocalizations.of(context)!.stepCasLock} ${index + 1} / ${steps.length} ",
                    style: const TextStyle(fontSize: 20)),
                ListTile(
                    title: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    steps[index],
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ))
              ])
            ]);
          },
        ));
  }
}
