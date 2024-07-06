import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  const Answer(
      {super.key,
      required this.answer,
      required this.symbol,
      required this.selected,
      required this.onSelected});
  final bool selected;
  final String answer;
  final String symbol;
  final void Function() onSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: const Color(0xff912F40),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      symbol,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  )),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(
                answer,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: selected ? Colors.white : Colors.black,
                    ),
              )),
            ],
          )),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'symbol': symbol,
      'selected': selected,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      answer: map['answer'],
      symbol: map['symbol'],
      selected: map['selected'],
      onSelected: () {},
    );
  }
}
