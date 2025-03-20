import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:isolate';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  void getData() async {
    String b = await Future.delayed(const Duration(seconds: 3), () {
      return "Run After 3 Seconds Then";
    });

    String a = await Future.delayed(const Duration(seconds: 4), () {
      return "Run After 4 Seconds";
    });
    debugPrint("Hello Print : $b $a");
  }

  Future<String> fetechData() async {
    return Future.delayed(const Duration(seconds: 3), () {
      return "Run After 3 Seconds";
    });
  }

  Stream<int> countStream() async* {
    for (int i = 2; i <= 20; i += 2) {
      await Future.delayed(const Duration(seconds: 3));
      yield i;
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetechData()
  //       .then((value) => debugPrint("Print Data $value"))
  //       .catchError((error) => debugPrint("Error $error"));
  //   countStream().listen((value) => debugPrint("Stream Value $value"));
  //   debugPrint("Hello Print ");
  // }
  //

  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Durations.extralong4,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            _buildUI(),

            // Lottie.asset(
            //   "assets/animation/load.json",
            //   repeat: true,
            //   height: 250,
            //   width: 250,
            // ),
            ElevatedButton.icon(
              onPressed: () async {
                var total = complexTask1();
                debugPrint("Total : $total");
              },
              icon: Icon(Icons.add),
              label: Text("Task 1"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final receivePort = ReceivePort();
                await Isolate.spawn(complexTask2, receivePort.sendPort);
                receivePort.listen((total) {
                  debugPrint("Total : $total");
                });
              },
              icon: Icon(Icons.add),
              label: Text("Task 2"),
            ),
            ElevatedButton.icon(
              onPressed: () async{
                final receivePort = ReceivePort();
                await Isolate.spawn(complexTask3,receivePort.sendPort);
                receivePort.listen((total) {
                  debugPrint("Total : $total");
                });
              },
              icon: Icon(Icons.add),
              label: Text("Task 3"),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var t = _controller.forward();
          t.whenComplete(() {
            _controller.reset();
          });
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Center(
          child: Lottie.asset(
            "assets/animation/tjeson.json",
            repeat: true,
            height: 250,
            width: 250,
          ),
        ),
        Lottie.asset(
          "assets/animation/confetto.json",
          controller: _controller,
          width: MediaQuery.sizeOf(context).height,
          height: MediaQuery.sizeOf(context).width,
          fit: BoxFit.cover,
          repeat: false,
        ),
      ],
    );
  }

  //Have Tast UI are stack
  Future<double> complexTask1() async {
    var total = 0.0;
    for (int i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (int i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}

complexTask3(SendPort sendPort) {
  var total = 0.0;
  for (int i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
