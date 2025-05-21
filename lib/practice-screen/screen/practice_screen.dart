import 'dart:async';
import 'package:driver/practice-screen/bloc/practice_bloc.dart';
import 'package:driver/practice-screen/model/mock_qtn_model.dart';
import 'package:driver/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

    final submission =
        selectedAnswers.entries
            .where((entry) => entry.key < questions.length)
            .map((entry) {
              final questionId = questions[entry.key].questionId;
              return {
                'questionId': questionId.toString(),
                'answer': entry.value.toString(),
              };
            })
            .where((s) {
              final isValid =
                  s['questionId']!.isNotEmpty && s['answer']!.isNotEmpty;
              if (!isValid) {}
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
      appBar: AppBar(title: const Text('अभ्यास प्रश्न')),
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
                    title: Text(
                      state.correctAnswers! > 10
                          ? 'You Have Passed'
                          : 'You Have Failed',
                      style:
                          state.correctAnswers! > 10
                              ? TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              )
                              : TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularPercentIndicator(
                          radius: 60.0.r,
                          lineWidth: 10.0.w,
                          percent: (state.scorePercentage ?? 0) / 100,
                          center: Text(
                            '${state.scorePercentage?.toStringAsFixed(1) ?? '0.0'}%',
                            style: TextStyle(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          progressColor:
                              (state.correctAnswers ?? 0) > 10
                                  ? const Color.fromARGB(255, 3, 154, 8)
                                  : Colors.red,
                          backgroundColor: Colors.grey.shade500,
                          animation: true,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'सही: ${state.correctAnswers ?? 0} / ${state.totalQuestions}',
                          style: TextStyle(fontSize: 22.sp),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.amber,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.black,
                          ), // Text color
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _handleRetry();
                        },
                        child: const Text('पुन: प्रयास गर्नुहोस्'),
                      ),

                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.amber,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.black,
                          ), // Text color, // Text color
                        ),
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

                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}. ${question.question ?? 'प्रश्न उपलब्ध छैन'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                ...List.generate(
                                  question.options?.length ?? 0,
                                  (optIndex) {
                                    final option = question.options![optIndex];

                                    return RadioListTile<String>(
                                      title: Semantics(
                                        child: Text(
                                          option,
                                          style: TextStyle(fontSize: 18.sp),
                                        ),
                                      ),
                                      value: option,
                                      groupValue: selected,
                                      activeColor:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                      onChanged:
                                          _secondsRemaining > 0
                                              ? (value) {
                                                setState(() {
                                                  selectedAnswers[index] =
                                                      value!;
                                                });
                                              }
                                              : null,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
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
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Slected: ${selectedAnswers.length}/25",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          Spacer(),
                          Text(
                            'Remaining Time: ${_formatTime(_secondsRemaining)}',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      ElevatedButton(
                        onPressed:
                            _secondsRemaining > 0
                                ? () => _handleSubmit(questions)
                                : null,

                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
