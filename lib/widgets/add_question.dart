import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saiflash/models/question.dart';
import 'package:saiflash/widgets/answer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerAController = TextEditingController();
  TextEditingController answerBController = TextEditingController();
  TextEditingController answerCController = TextEditingController();
  TextEditingController answerDController = TextEditingController();
  var selectedAnswer = '';

  void addQuestion() {
    String coreectAnswer = '';
    if (selectedAnswer == 'A') {
      coreectAnswer = answerAController.text;
    } else if (selectedAnswer == 'B') {
      coreectAnswer = answerBController.text;
    } else if (selectedAnswer == 'C') {
      coreectAnswer = answerCController.text;
    } else {
      coreectAnswer = answerDController.text;
    }

    Question newQuestion = Question(
      id: '',
      questionText: questionController.text,
      answers: [
        Answer(
          answer: answerAController.text,
          symbol: 'A',
          selected: false,
          onSelected: () {},
        ),
        Answer(
          answer: answerBController.text,
          symbol: 'B',
          selected: false,
          onSelected: () {},
        ),
        Answer(
          answer: answerCController.text,
          symbol: 'C',
          selected: false,
          onSelected: () {},
        ),
        Answer(
          answer: answerDController.text,
          symbol: 'D',
          selected: false,
          onSelected: () {},
        ),
      ],
      correctAnswer: coreectAnswer,
    );
    try {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance
          .collection('users_questions')
          .doc(user.uid)
          .collection('questions')
          .add(newQuestion.toMap());
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('New question added successfully!',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                )),
      ));

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  children: [
                    Text(
                      'Add your own Q&A',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffEFEFEF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: questionController,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintText: 'Question..',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: const Color(0xffD2D2D2),
                                  ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Click on the answer sympol to mark it as a correct answer',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontSize: 8),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedAnswer == 'A'
                                  ? Colors.black
                                  : const Color(0xffEFEFEF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAnswer = 'A';
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff912F40),
                                    child: Text(
                                      'A',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: answerAController,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: selectedAnswer == 'A'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                    decoration: InputDecoration(
                                      hintText: 'Answer..',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: selectedAnswer == 'A'
                                                ? Colors.white
                                                : const Color(0xffD2D2D2),
                                          ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 8),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedAnswer == 'B'
                                  ? Colors.black
                                  : const Color(0xffEFEFEF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAnswer = 'B';
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff912F40),
                                    child: Text(
                                      'B',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: answerBController,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: selectedAnswer == 'B'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                    decoration: InputDecoration(
                                      hintText: 'Answer..',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: selectedAnswer == 'B'
                                                ? Colors.white
                                                : const Color(0xffD2D2D2),
                                          ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 8),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedAnswer == 'C'
                                  ? Colors.black
                                  : const Color(0xffEFEFEF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAnswer = 'C';
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff912F40),
                                    child: Text(
                                      'C',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: answerCController,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: selectedAnswer == 'C'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                    decoration: InputDecoration(
                                      hintText: 'Answer..',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: selectedAnswer == 'C'
                                                ? Colors.white
                                                : const Color(0xffD2D2D2),
                                          ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 8),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedAnswer == 'D'
                                  ? Colors.black
                                  : const Color(0xffEFEFEF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAnswer = 'D';
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff912F40),
                                    child: Text(
                                      'D',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: answerDController,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: selectedAnswer == 'D'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                    decoration: InputDecoration(
                                      hintText: 'Answer..',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: selectedAnswer == 'D'
                                                ? Colors.white
                                                : const Color(0xffD2D2D2),
                                          ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xffFF4D4D),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (selectedAnswer == '' ||
                            answerAController.text.isEmpty ||
                            answerBController.text.isEmpty ||
                            answerCController.text.isEmpty ||
                            answerDController.text.isEmpty ||
                            questionController.text.isEmpty) return;
                        setState(() {
                          addQuestion();
                        });
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: selectedAnswer == '' ||
                                  (answerAController.text.isEmpty ||
                                      answerBController.text.isEmpty ||
                                      answerCController.text.isEmpty ||
                                      answerDController.text.isEmpty ||
                                      questionController.text.isEmpty)
                              ? const Color(0xffD2D2D2)
                              : Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            'Add',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: selectedAnswer == ''
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
