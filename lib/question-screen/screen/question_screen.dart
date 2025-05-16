import 'package:driver/question-screen/bloc/question_bloc.dart';
import 'package:driver/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionScreen extends StatefulWidget {
  final String title;
  const QuestionScreen({super.key, required this.title});

  @override
  State<QuestionScreen> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionScreen> {
  // Stores selected answers and their correctness
  final Map<String, String> selectedAnswers = {};
  final nepaliLabels = ['(क)', '(ख)', '(ग)', '(घ)'];

  @override
  void initState() {
    super.initState();
    locator<QuestionBloc>().add(GettitleQuestionList(title: widget.title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // actions: [Container(child: Text(see),)],
      ),
      body: BlocBuilder<QuestionBloc, QuestionState>(
        bloc: locator<QuestionBloc>(),
        builder: (context, state) {
          if (state.status == Status.error) {
            return const Center(child: Text('Error'));
          } else if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == Status.success &&
              (state.allQuestionList!.questions == null ||
                  state.allQuestionList!.questions!.isEmpty)) {
            return const Center(child: Text("No Questions Found"));
          } else if (state.status == Status.success) {
            final questions = state.allQuestionList!.questions!;

            return ListView.builder(
              itemCount: questions.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final question = questions[index];
                final questionId = question.sId?.toString() ?? '$index';
                final selectedOption = selectedAnswers[questionId];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '(${index + 1}) ${question.question ?? "No Question"}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...question.options?.map((option) {
                              final isCorrect =
                                  option.trim().toLowerCase() ==
                                  question.correctAnswer?.trim().toLowerCase();
                              final isSelected = option == selectedOption;

                              Color? optionColor;
                              if (selectedOption != null) {
                                if (isSelected && isCorrect) {
                                  optionColor = Colors.green;
                                } else if (isSelected && !isCorrect) {
                                  optionColor = Colors.red;
                                } else if (isCorrect) {
                                  optionColor = Colors.green.withOpacity(0.5);
                                }
                              }

                              return GestureDetector(
                                onTap:
                                    selectedOption == null
                                        ? () {
                                          setState(() {
                                            selectedAnswers[questionId] =
                                                option;
                                          });
                                        }
                                        : null,
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: optionColor ?? Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Text(
                                    '${nepaliLabels[question.options!.indexOf(option)]}  ${option.toString()}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList() ??
                            [],
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Unknown State"));
          }
        },
      ),
    );
  }
}
