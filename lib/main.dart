import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

List<String> titles = <String>[
  'All',
  'Pinned',
];

List<String> clipItems = [
  'Hello world',
  'OpenAI is awesome',
  'Flutter is amazing',
  'Coding is fun',
  'Mobile app development',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter layout demo', home: MyAppBar());
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          scrolledUnderElevation: 20.0,
          shadowColor: Colors.blueGrey[200],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.assignment),
                text: titles[0],
              ),
              Tab(
                icon: const Icon(Icons.push_pin),
                text: titles[1],
              ),
            ],
          ),
        ),
        body: const MyTabView(),
      ),
    );
  }
}

class MyTabView extends StatefulWidget {
  const MyTabView({super.key});

  @override
  State<MyTabView> createState() => _MyTabViewState();
}

class _MyTabViewState extends State<MyTabView> {
  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
      var lastClip = clipItems[clipItems.length - 1];
      if (lastClip != cdata?.text) {
        setState(() {
          clipItems.add(cdata!.text!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.secondary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return TabBarView(
      children: <Widget>[
        ListView.builder(
          itemCount: clipItems.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              tileColor: index.isOdd ? oddItemColor : evenItemColor,
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      clipItems[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: clipItems[index]));
                      // copied successfully
                    },
                    child: const Icon(Icons.content_copy_rounded),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        clipItems.removeAt(index);
                      });
                      // copied successfully
                    },
                    child: const InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.delete_forever_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ListView.builder(
          itemCount: 25,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              tileColor: index.isOdd ? oddItemColor : evenItemColor,
              title: Text('${titles[1]} $index'),
            );
          },
        ),
      ],
    );
  }
}
