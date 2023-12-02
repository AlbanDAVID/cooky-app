// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class AddTotalTime extends StatefulWidget {
  const AddTotalTime({super.key});

  @override
  State<AddTotalTime> createState() => _AddTotalTimeState();
}

class _AddTotalTimeState extends State<AddTotalTime> {
  final TextEditingController _controller = TextEditingController();
  final List<String> totalTimeList = ["120 min", "130 min"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add total time"),
          centerTitle: true,
          elevation: 0,
          //leading: const Icon(Icons.menu),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: Column(children: [
          const Text("Suggestions : ", style: TextStyle(fontSize: 10)),
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
                      title: Text('Add total time'),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text('Add'),
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

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
