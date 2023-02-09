// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz_state.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/loading.dart';
import 'package:quizapp/shared/progress_bar.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;
  const QuizScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizState(),
      child: FutureBuilder(
        future: FireStoreService().getQuiz(quizId),
        builder: (context, snapshot) {
          var state = Provider.of<QuizState>(context);

          if (!snapshot.hasData || snapshot.hasError) {
            return Loader();
          } else {
            var quiz = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: AnimatedProgressBar(value: state.progress),
                leading: IconButton(
                  icon: const Icon(FontAwesomeIcons.xmark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state.controller,
                onPageChanged: (int idx) =>
                    state.progress = (idx / (quiz.questions.length + 1)),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return StartPage(quiz: quiz);
                  } else if (index == quiz.questions.length + 1) {
                    return CongratsPage(quiz: quiz);
                  } else {
                    return QuestionPage(question: quiz.questions[index - 1]);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  final Quiz quiz;
  const StartPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            quiz.title,
            style: Theme.of(context).textTheme.headline4,
          ),
          const Divider(),
          Expanded(child: Text(quiz.description)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: state.nextPage,
                label: const Text('Start Quiz!'),
                icon: const Icon(Icons.poll),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  const CongratsPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Brao majmune! You completed ${quiz.title}',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Image.asset('assets/congrats.gif'),
          ElevatedButton.icon(
            icon: const Icon(FontAwesomeIcons.check),
            label: const Text('Mark complete!'),
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              FireStoreService().updateUserReport(quiz);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/topics',
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(question.text),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: question.options.map(
              (opt) {
                return Container(
                  height: 90,
                  margin: const EdgeInsets.only(bottom: 10),
                  color: Colors.black26,
                  child: InkWell(
                    onTap: () {
                      state.selected = opt;
                      _bottomSheet(context, opt, state);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            state.selected == opt
                                ? FontAwesomeIcons.circleCheck
                                : FontAwesomeIcons.circle,
                            size: 30,
                          ),
                          Text(
                            opt.value,
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        )
      ],
    );
  }

  _bottomSheet(BuildContext context, Option opt, QuizState state) {
    bool correct = opt.correct;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(correct ? 'Good job' : 'Wrong'),
              Text(
                opt.detail,
                style: const TextStyle(fontSize: 18, color: Colors.white54),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: correct ? Colors.green : Colors.red),
                child: Text(
                  correct ? 'Onward!' : 'Try again',
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (correct) {
                    state.nextPage();
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
