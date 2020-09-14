import 'dart:math' as math;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:share/share.dart';

class CountDownTimer extends StatefulWidget {
  final String question;
  CountDownTimer(this.question);
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

//ggggggggggggggggggggggggggggggggggggggggggggg

  int timer = 30;
  String showtimer = "30";
  var link;
  int nindex;
  int p;
  int n = 1;
  bool canceltimer = false;
  int correct = 0;
  Random random = new Random();
  var linkapp;
  getData() async {
    var a = await Firestore.instance
        .collection("Categories")
        .document(widget.question)
        .collection('Questions')
        .get();
    var b = await Firestore.instance
        .collection("PlaystoreLink")
        .document("Link")
        .get();

    setState(() {
      link = a;
      linkapp = b;
    });
    p = link.documents.length;

    nextQuestion();
  }

  void colorFunc(String answer, String s) {
    if (answer == link.documents[nindex].data()['correct_answer'] && s == 'a') {
      setState(() {
        a = true;
        aw = false;
        correct++;
      });
    } else if (answer == link.documents[nindex].data()['correct_answer'] &&
        s == 'b') {
      setState(() {
        b = true;
        bw = false;
        correct++;
      });
    } else if (answer == link.documents[nindex].data()['correct_answer'] &&
        s == 'c') {
      setState(() {
        c = true;
        cw = false;
        correct++;
      });
    } else if (answer == link.documents[nindex].data()['correct_answer'] &&
        s == 'd') {
      setState(() {
        d = true;
        dw = false;
        correct++;
      });
    } else {
      cc();
    }
  }

  void cc() {
    if (link.documents[nindex].data()['answerA'] ==
        link.documents[nindex].data()['correct_answer']) {
      setState(() {
        a = true;
      });
    } else if (link.documents[nindex].data()['answerB'] ==
        link.documents[nindex].data()['correct_answer']) {
      setState(() {
        b = true;
      });
    } else if (link.documents[nindex].data()['answerC'] ==
        link.documents[nindex].data()['correct_answer']) {
      setState(() {
        c = true;
      });
    } else {
      setState(() {
        d = true;
      });
    }
  }

  bool a = false;
  bool b = false;
  bool c = false;
  bool d = false;
  void nextQuestion() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    setState(() {
      a = false;
      b = false;
      c = false;
      d = false;
      aw = false;
      bw = false;
      cw = false;
      dw = false;
    });
    canceltimer = false;
    timer = 30;
    if (n <= 20) {
      setState(() {
        nindex = random.nextInt(p);
        nc = n;
      });

      starttimer();
    } else {
      showAlertDialog(context);
    }
  }

  Timer timerg;
  void autoPress() {
    timerg = new Timer(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          setState(() {
            n++;
          });
          cc();
          autoPress();
          // nextQuestion();
        } else if (canceltimer == true) {
          t.cancel();
          setState(() {
            n++;
          });
          autoPress();
          //  nextQuestion();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  bool aw = false;
  bool bw = false;
  bool cw = false;
  bool dw = false;
  int nc;
  int ss;
  showAlertDialog(BuildContext context) {
    SimpleDialog dialog = SimpleDialog(
      title: Center(child: const Text('Result')),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
              child: Text(
            'Correct Answer : $correct',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          )),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
              child: Text(
            'Wrong Answer : ${20 - correct}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          )),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Share.share(
                    'My Currect  Answer : $correct . Test je kennis over Suriname! https://${linkapp.data()['link']}',
                    subject: 'Look what I made!');
              },
              child: Icon(
                Icons.share,
                size: 50,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 80,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Color(
                          0xffEDC917), //                   <--- border color
                      width: 5,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'Start New Topic',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  )),
                )),
          ),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

//ggggggggggggggggggggggggggggggggggggggggggggggggggg
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: link == null
            ? Center(child: CircularProgressIndicator())
            : AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Color(0xff30474f),
                          height: controller.value *
                              MediaQuery.of(context).size.height,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            link.documents[nindex].data()['question'],
                            style: TextStyle(
                              color: Color(0xffEDC917),
                              fontSize: 25,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  height: 150,
                                  child: Align(
                                    alignment: FractionalOffset.center,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: CustomPaint(
                                                painter: CustomTimerPainter(
                                                    animation: controller,
                                                    backgroundColor:
                                                        Color(0xffEDC917),
                                                    color: Color(0xffB50329)
                                                    //themeData.indicatorColor,
                                                    )),
                                          ),
                                          Align(
                                            alignment: FractionalOffset.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  timerString.substring(2),
                                                  style: TextStyle(
                                                      fontSize: 30.0,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Correct Answer : $correct',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Total   :  $nc/20',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  controller.stop();
                                  setState(() {
                                    aw = true;
                                  });
                                  colorFunc(
                                      link.documents[nindex].data()['answerA'],
                                      'a');

                                  canceltimer = true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: a == false
                                            ? Colors.white
                                            : Color(
                                                0xff347F3D), //                   <--- border color
                                        width: 2.5,
                                      ),
                                    ),
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        link.documents[nindex]
                                                    .data()['answerA'] !=
                                                null
                                            ? '${link.documents[nindex].data()['answerA']}'
                                            : '',
                                        style: TextStyle(
                                          color: aw == true
                                              ? Color(0xffB50329)
                                              : Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.stop();
                                  setState(() {
                                    bw = true;
                                  });
                                  colorFunc(
                                      link.documents[nindex].data()['answerB'],
                                      'b');

                                  canceltimer = true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: b == false
                                            ? Colors.white
                                            : Color(
                                                0xff347F3D), //                   <--- border color
                                        width: 2.5,
                                      ),
                                    ),
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        link.documents[nindex]
                                                    .data()['answerB'] !=
                                                null
                                            ? '${link.documents[nindex].data()['answerB']}'
                                            : '',
                                        style: TextStyle(
                                          color: bw == true
                                              ? Color(0xffB50329)
                                              : Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.stop();
                                  setState(() {
                                    cw = true;
                                  });

                                  colorFunc(
                                      link.documents[nindex].data()['answerC'],
                                      'c');

                                  canceltimer = true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: c == false
                                            ? Colors.white
                                            : Color(
                                                0xff347F3D), //                   <--- border color
                                        width: 2.5,
                                      ),
                                    ),
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        link.documents[nindex]
                                                    .data()['answerC'] !=
                                                null
                                            ? '${link.documents[nindex].data()['answerC']}'
                                            : '',
                                        style: TextStyle(
                                          color: cw == true
                                              ? Color(0xffB50329)
                                              : Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.stop();
                                  setState(() {
                                    dw = true;
                                  });
                                  colorFunc(
                                      link.documents[nindex].data()['answerD'],
                                      'd');

                                  canceltimer = true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: d == false
                                            ? Colors.white
                                            : Color(
                                                0xff347F3D), //                   <--- border color
                                        width: 2.5,
                                      ),
                                    ),
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        link.documents[nindex]
                                                    .data()['answerD'] !=
                                                null
                                            ? '${link.documents[nindex].data()['answerD']}'
                                            : '',
                                        style: TextStyle(
                                          color: dw == true
                                              ? Color(0xffB50329)
                                              : Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                }),
      ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
