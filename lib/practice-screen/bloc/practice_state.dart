part of 'practice_bloc.dart';

enum Status { initial, loading, success, error, submitting, submitted }

class PracticeState extends Equatable {
  final Status status;
  final List<MockQuestionModel> allPracticeQuestionList;
  final int? correctAnswers;
  final double? scorePercentage;
  final String? errorMessage;
  final String? timeLimit;
  final int? totalQuestions;

  const PracticeState({
    this.status = Status.initial,
    this.allPracticeQuestionList = const [],
    this.correctAnswers,
    this.scorePercentage,
    this.errorMessage,
    this.timeLimit,
    this.totalQuestions,
  });

  PracticeState copyWith({
    Status? status,
    List<MockQuestionModel>? allPracticeQuestionList,
    int? correctAnswers,
    double? scorePercentage,
    String? errorMessage,
    String? timeLimit,
    int? totalQuestions,
  }) {
    return PracticeState(
      status: status ?? this.status,
      allPracticeQuestionList:
          allPracticeQuestionList ?? this.allPracticeQuestionList,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      scorePercentage: scorePercentage ?? this.scorePercentage,
      errorMessage: errorMessage ?? this.errorMessage,
      timeLimit: timeLimit ?? this.timeLimit,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allPracticeQuestionList,
    correctAnswers,
    scorePercentage,
    errorMessage,
    timeLimit,
    totalQuestions,
  ];
}

class PracticeInitial extends PracticeState {}
