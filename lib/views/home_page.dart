import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/data.dart';
import 'details_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _moveRight() {
    print('right pressed');
    FocusManager.instance.primaryFocus?.focusInDirection(TraversalDirection.right);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bou TV'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          print("1) ${event.data}");
          print("2) ${event.character.toString()}");
          print("3) ${event.toString()}");
          print("4) ${event.physicalKey.debugName}");
          print("5) ${event.logicalKey.keyId}");
          print("6) ${event.isKeyPressed(LogicalKeyboardKey.enter)}");


          if (LogicalKeyboardKey.arrowRight == event.logicalKey) {
            _moveRight();
          }

          if (event is RawKeyDownEvent) {
            // handle key down
          } else if (event is RawKeyUpEvent) {
            // handle key up
          }
        },
        child: Column(
          children: [
            Expanded(
              child: GridView(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                children: images
                    .map((url) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => DetailsScreen(
                                  url: links[images.indexOf(url)],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              url,
                              height: 150,
                              width: 150,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
