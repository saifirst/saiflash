// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saiflash/widgets/add_question.dart';
import 'package:saiflash/widgets/question.dart';
import 'package:saiflash/widgets/user_image_picker.dart';
import 'package:saiflash/models/question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    isCompleted();
    _loadUserQuestions();
  }

  var userId = '';
  var userName = '';
  var userImage = '';

  void isCompleted() async {
    final user = FirebaseAuth.instance.currentUser!;
    userId = user.uid;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userData.data()!['Profile Picture'] == '') {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (ctx) {
            return UserImagePicker(
              onImagePicked: (pickedImage) {
                return;
              },
            );
          });
    }
    setState(() {
      userName = userData.data()!['Name'];

      userImage = userData.data()!['Profile Picture'];
    });
  }

  List<Question> userQuestions = [];
  List<Question> answeredQuestions = [];
  List<Question> skippedQuestions = [];

  var currentIndex = 0;
  var questionsCount = 0;
  bool fetched = false;
  bool quizFinished = false;
  Future<void> _loadUserQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users_questions')
        .doc(userId)
        .collection('questions')
        .get();

    setState(() {
      userQuestions = querySnapshot.docs.map((doc) {
        return Question.fromMap(doc.data(), doc.id);
      }).toList();
      questionsCount = userQuestions.length;
      fetched = true;
    });
  }

  Future<void> deleteQuestion(int index) async {
    String questionId = userQuestions[index].id;

    // Remove from Firestore
    await FirebaseFirestore.instance
        .collection('users_questions')
        .doc(userId)
        .collection('questions')
        .doc(questionId)
        .delete();

    // Remove from local list
    setState(() {
      currentIndex = 0;
      _loadUserQuestions();
    });
  }

  void _showAddQuestionDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return const AddQuestion();
      },
    );
    if (result == true) {
      _loadUserQuestions();
    }
  }

  bool _showLogoutButton = false;
  void _toggleLogoutButton() {
    setState(() {
      _showLogoutButton = !_showLogoutButton;
    });
  }

  var score = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Hi, ${userName.toString().split(" ")[0].length > 8 ? userName.toString().split(" ")[0].substring(0, 8) : userName.toString().split(" ")[0]}!',
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 32)),
                      Text(
                        'Good ${DateTime.now().hour < 12 ? 'Morning☀️' : 'Evening🌙'}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 120,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            right: _showLogoutButton ? 25 : 0,
                            child: _showLogoutButton
                                ? GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 32,
                                          top: 8,
                                          bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 156, 156, 156),
                                              offset: Offset(0, 0),
                                              blurRadius: 8,
                                              blurStyle: BlurStyle.normal)
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/logout.svg'),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Logout',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color:
                                                        const Color(0xff912F40),
                                                    fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container()),
                        userImage != ''
                            ? GestureDetector(
                                onTap: _toggleLogoutButton,
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(userImage),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffffffff),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 156, 156, 156),
                                offset: Offset(0, 0),
                                blurRadius: 8,
                                blurStyle: BlurStyle.normal)
                          ]),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                                minHeight: 12,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                value: userQuestions.isEmpty
                                    ? 0
                                    : (currentIndex + 1) /
                                        (userQuestions.length),
                                backgroundColor: const Color(0xffD3ACB3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xff912F40))),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                              fetched && questionsCount > 0
                                  ? '${currentIndex + 1}/$questionsCount'
                                  : '0/0',
                              style: Theme.of(context).textTheme.bodySmall!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      deleteQuestion(currentIndex);
                    },
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xff912F40)))),
                    icon: SvgPicture.asset(
                      'assets/icons/trash.svg',
                      width: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      _showAddQuestionDialog(context);
                    },
                    style: IconButton.styleFrom(
                        backgroundColor: const Color(0xff912F40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xff912F40)))),
                    icon: SvgPicture.asset(
                      'assets/icons/plus.svg',
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xff912F40),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                    ),
                    child: !fetched
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : quizFinished
                            ? score > userQuestions.length
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Your Score!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 36),
                                      ),
                                      const SizedBox(
                                        height: 38,
                                      ),
                                      Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 230,
                                              height: 230,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 16,
                                                value: score /
                                                    userQuestions.length,
                                                backgroundColor:
                                                    const Color(0xffBD828C),
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                            Text(
                                              '${(score / userQuestions.length * 100).toStringAsFixed(1)}%',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 38),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 38,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            score = 0.0;
                                            quizFinished = false;
                                            _loadUserQuestions();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 48, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/icons/again.svg'),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Text('Try Again',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 20)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                            : userQuestions.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        'No Q&A has been added yet!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              height: 1.3,
                                              color: Colors.white,
                                              fontSize: 56,
                                            ),
                                      ),
                                      const SizedBox(height: 32),
                                      GestureDetector(
                                        onTap: () {
                                          _showAddQuestionDialog(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 48, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text('Add your own Q&A',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 20)),
                                        ),
                                      )
                                    ],
                                  )
                                : ListView(
                                    children: [
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      QuestionWidget(
                                          question:
                                              userQuestions[currentIndex]),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  resetSelectedIndex();
                                                });
                                                skippedQuestions.add(
                                                    userQuestions[
                                                        currentIndex]);
                                                if (currentIndex <
                                                    userQuestions.length - 1) {
                                                  setState(() {
                                                    currentIndex++;
                                                  });
                                                } else {
                                                  if (skippedQuestions
                                                      .isNotEmpty) {
                                                    setState(() {
                                                      answeredQuestions =
                                                          userQuestions;
                                                      userQuestions =
                                                          skippedQuestions;
                                                      skippedQuestions = [];
                                                      currentIndex = 0;
                                                    });
                                                  } else {
                                                    _loadUserQuestions();
                                                    setState(() {
                                                      quizFinished = true;
                                                      currentIndex = 0;
                                                    });
                                                  }
                                                }
                                              },
                                              child: Container(
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Skip',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isAnswerCorrect(
                                                    userQuestions[
                                                        currentIndex])) {
                                                  score++;
                                                }
                                                setState(() {
                                                  if (currentIndex <
                                                      userQuestions.length -
                                                          1) {
                                                    currentIndex++;
                                                  } else {
                                                    if (skippedQuestions
                                                        .isNotEmpty) {
                                                      setState(() {
                                                        answeredQuestions =
                                                            userQuestions;
                                                        userQuestions =
                                                            skippedQuestions;
                                                        skippedQuestions = [];
                                                        currentIndex = 0;
                                                      });
                                                    } else {
                                                      _loadUserQuestions();

                                                      setState(() {
                                                        quizFinished = true;
                                                        currentIndex = 0;
                                                      });
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Submit',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      )
                                    ],
                                  ))),
          ],
        ),
      ),
    );
  }
}
