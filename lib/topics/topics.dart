// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/bottom_nav.dart';
import 'package:quizapp/shared/error.dart';
import 'package:quizapp/shared/loading.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: FireStoreService().getTopics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        } else if (snapshot.hasError) {
          return ErrorMessage(message: snapshot.error.toString());
        } else if (snapshot.hasData) {
          var topics = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              centerTitle: true,
              title: Text("Topics"),
              actions: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                  icon: Icon(
                    FontAwesomeIcons.user,
                    size: 10,
                  ),
                )
              ],
            ),
            body: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              children: topics.map((topic) => Text(topic.title)).toList(),
            ),
            bottomNavigationBar: BottomNavBar(),
          );
        } else {
          return const Text('No topics fount in Firestore. Check database');
        }
      },
    );
  }
}
