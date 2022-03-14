import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:align_positioned/align_positioned.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Focus(),
    ));

class Focus extends StatefulWidget {
  const Focus({Key? key}) : super(key: key);

  @override
  _FocusPageState createState() => _FocusPageState();
}

class _FocusPageState extends State<Focus> with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1500),
    );

    controller.addListener(() {
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(0, 3, 196, 255),
                    value: progress,
                    strokeWidth: 6,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (controller.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: controller.duration!,
                            onTimerDurationChanged: (time) {
                              setState(() {
                                controller.duration = time;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Text(
                      countText,
                      style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                          color: Colors.white),
                    ),
                  ),
                ),
                AlignPositioned(
                  dy: -50,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 26, 26, 26)
                                .withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(1, 3),
                          )
                        ]),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.isAnimating) {
                            controller.stop();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            controller.reverse(
                                from: controller.value == 0
                                    ? 1.0
                                    : controller.value);
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                        child: const Text(
                          'Start',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
