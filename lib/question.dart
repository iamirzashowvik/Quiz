import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:share/share.dart';

class Question extends StatefulWidget {
  final String question;
  // final int index;
  Question(this.question);
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
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
      });
    } else if (answer == link.documents[nindex].data()['correct_answer'] &&
        s == 'b') {
      setState(() {
        b = true;
      });
    } else if (answer == link.documents[nindex].data()['correct_answer'] &&
        s == 'c') {
      setState(() {
        c = true;
      });
    } else {
      setState(() {
        d = true;
      });
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
    setState(() {
      a = false;
      b = false;
      c = false;
      d = false;
    });
    canceltimer = false;
    timer = 30;
    if (n <= 20) {
      setState(() {
        nindex = random.nextInt(p);
      });

      starttimer();
    } else {
      showAlertDialog(context);
    }
  }

  Timer timerg;
  void autoPress() {
    timerg = new Timer(const Duration(seconds: 2), () {
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
                      color: Colors.blue, //                   <--- border color
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

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: link == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  link.documents[nindex].data()['question'],
                  style: TextStyle(
                    color: Colors.yellow[400],
                    fontSize: 25,
                  ),
                ),
                Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Total   :  $n/20',
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
                        canceltimer = true;

                        colorFunc(
                            link.documents[nindex].data()['answerA'], 'a');
                        if (link.documents[nindex].data()['answerA'] ==
                            link.documents[nindex].data()['correct_answer']) {
                          setState(() {
                            correct++;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .white, //                   <--- border color
                              width: 2.5,
                            ),
                          ),
                          height: 50,
                          child: Center(
                            child: Text(
                              link.documents[nindex].data()['answerA'] != null
                                  ? '${link.documents[nindex].data()['answerA']}'
                                  : '',
                              style: TextStyle(
                                color: a == false ? Colors.white : Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        canceltimer = true;
                        colorFunc(
                            link.documents[nindex].data()['answerB'], 'b');
                        if (link.documents[nindex].data()['answerB'] ==
                            link.documents[nindex].data()['correct_answer']) {
                          setState(() {
                            correct++;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .white, //                   <--- border color
                              width: 2.5,
                            ),
                          ),
                          height: 50,
                          child: Center(
                            child: Text(
                              link.documents[nindex].data()['answerB'] != null
                                  ? '${link.documents[nindex].data()['answerB']}'
                                  : '',
                              style: TextStyle(
                                color: b == false ? Colors.white : Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        canceltimer = true;
                        colorFunc(
                            link.documents[nindex].data()['answerC'], 'c');
                        if (link.documents[nindex].data()['answerC'] ==
                            link.documents[nindex].data()['correct_answer']) {
                          setState(() {
                            correct++;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .white, //                   <--- border color
                              width: 2.5,
                            ),
                          ),
                          height: 50,
                          child: Center(
                            child: Text(
                              link.documents[nindex].data()['answerC'] != null
                                  ? '${link.documents[nindex].data()['answerC']}'
                                  : '',
                              style: TextStyle(
                                color: c == false ? Colors.white : Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        canceltimer = true;
                        colorFunc(
                            link.documents[nindex].data()['answerD'], 'd');

                        if (link.documents[nindex].data()['answerD'] ==
                            link.documents[nindex].data()['correct_answer']) {
                          setState(() {
                            correct++;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .white, //                   <--- border color
                              width: 2.5,
                            ),
                          ),
                          height: 50,
                          child: Center(
                            child: Text(
                              link.documents[nindex].data()['answerD'] != null
                                  ? '${link.documents[nindex].data()['answerD']}'
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: d == false ? Colors.white : Colors.green,
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
    );
  }
}
