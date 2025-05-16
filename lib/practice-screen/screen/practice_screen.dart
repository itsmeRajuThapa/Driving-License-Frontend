import 'dart:async';
import 'package:driver/practice-screen/bloc/practice_bloc.dart';
import 'package:driver/practice-screen/model/mock_qtn_model.dart';
import 'package:driver/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final Map<int, String> selectedAnswers = {};
  Timer? _timer;
  int _secondsRemaining = 1800; // Default to 30 minutes (1800 seconds)

  @override
  void initState() {
    super.initState();
    locator<PracticeBloc>().add(GetAllPracticeQtnList());
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 1800; // Hardcode to 30 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          _handleSubmit(locator<PracticeBloc>().state.allPracticeQuestionList);
        }
      });
    });
  }

  void _handleSubmit(List<MockQuestionModel> questions) {
  if (selectedAnswers.length < questions.length) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('कृपया सबै प्रश्नहरूको जवाफ दिनुहोस्।')),
    );
    return;
  }

  final submission = selectedAnswers.entries
      .where((entry) => entry.key < questions.length)
      .map((entry) {
        final questionId = questions[entry.key].questionId;
        return {
          'questionId': questionId.toString(),
          'answer': entry.value.toString(),
        };
      })
      .where((s) {
        final isValid = s['questionId']!.isNotEmpty && s['answer']!.isNotEmpty;
        if (!isValid) {
        }
        return isValid;
      })
      .toList();

  if (submission.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('कुनै मान्य जवाफ फेला परेन।')),
    );
    return;
  }

  _timer?.cancel();
  locator<PracticeBloc>().add(SubmitPracticeAnswers(submission));
}

   

  void _handleRetry() {
    setState(() {
      selectedAnswers.clear();
      _secondsRemaining = 1800; // Reset to 30 minutes
    });
    locator<PracticeBloc>().add(GetAllPracticeQtnList());
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('अभ्यास प्रश्न'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'समय: ${_formatTime(_secondsRemaining)}',
              style: const TextStyle(
                fontFamily: 'NotoSansNepali',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<PracticeBloc, PracticeState>(
        bloc: locator<PracticeBloc>(),
        listener: (context, state) {
          if (state.status == Status.success) {
            _startTimer();
          } else if (state.status == Status.submitted) {
            _timer?.cancel();
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: const Text('प्रश्नोत्तर समाप्त'),
                    content: Text(
                      'सही: ${state.correctAnswers ?? 0} / ${state.allPracticeQuestionList.length}\n'
                      'अंक: ${state.scorePercentage?.toStringAsFixed(2) ?? '0.00'}%',
                      style: const TextStyle(fontFamily: 'NotoSansNepali'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleRetry();
                        },
                        child: const Text('पुन: प्रयास गर्नुहोस्'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ठीक छ'),
                      ),
                    ],
                  ),
            );
          } else if (state.status == Status.error &&
              state.errorMessage != null) {
            _timer?.cancel();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'पुन: प्रयास',
                  onPressed:
                      () => _handleSubmit(
                        locator<PracticeBloc>().state.allPracticeQuestionList,
                      ),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<PracticeBloc, PracticeState>(
          bloc: locator<PracticeBloc>(),
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == Status.error) {
              return Center(child: Text(state.errorMessage ?? 'त्रुटि भयो'));
            } else if (state.status == Status.success &&
                state.allPracticeQuestionList.isEmpty) {
              return const Center(child: Text('कुनै डाटा फेला परेन'));
            } else if (state.status == Status.submitting) {
              return const Center(child: CircularProgressIndicator());
            }

            final questions = state.allPracticeQuestionList;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final selected = selectedAnswers[index];
                        final labels = ['(क)', '(ख)', '(ग)', '(घ)'];

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}. ${question.question ?? 'प्रश्न उपलब्ध छैन'}',
                                  style: const TextStyle(
                                    fontFamily: 'NotoSansNepali',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...List.generate(
                                  question.options?.length ?? 0,
                                  (optIndex) {
                                    final option = question.options![optIndex];
                                    final label =
                                        optIndex < labels.length
                                            ? labels[optIndex]
                                            : '';
                                    return RadioListTile<String>(
                                      title: Semantics(
                                        label: '$label $option',
                                        child: Text(
                                          '$label $option',
                                          style: const TextStyle(
                                            fontFamily: 'NotoSansNepali',
                                          ),
                                        ),
                                      ),
                                      value: option,
                                      groupValue: selected,
                                      onChanged:
                                          _secondsRemaining > 0
                                              ? (value) {
                                                setState(() {
                                                  selectedAnswers[index] =
                                                      value!;
                                                });
                                              }
                                              : null,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                      visualDensity: VisualDensity.compact,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        _secondsRemaining > 0
                            ? () => _handleSubmit(questions)
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'जवाफ पेश गर्नुहोस्',
                      style: TextStyle(fontFamily: 'NotoSansNepali'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
