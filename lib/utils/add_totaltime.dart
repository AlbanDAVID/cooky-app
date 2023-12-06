// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTotalTime extends StatefulWidget {
  const AddTotalTime({super.key});

  @override
  State<AddTotalTime> createState() => _AddTotalTimeState();
}

class _AddTotalTimeState extends State<AddTotalTime> {
  final TextEditingController _controller = TextEditingController();
  final List<String> totalTimeList = [
    "5m",
    "10m",
    "15m",
    "20m",
    "30m",
    "40m",
    "45m",
    "1h",
    "1,5h",
    "2h",
    "3h",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addTotalTime),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            //IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          const Text("Suggestions : ", style: TextStyle(fontSize: 13)),
          SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: totalTimeList.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      Navigator.pop(context, totalTimeList[index]);
                    },
                    child: Center(
                      child: Text(
                        totalTimeList[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                },
              )),
          FloatingActionButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.addTotalTime),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.add),
                          onPressed: () async {
                            setState(() {
                              Navigator.pop(context);
                              totalTimeList.insert(0, _controller.text);
                            });
                          },
                        )
                      ],
                    );
                  });
            },
            child: Icon(Icons.add),
          ),
        ]));
  }
}
