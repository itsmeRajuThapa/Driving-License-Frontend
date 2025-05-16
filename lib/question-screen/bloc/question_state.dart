part of 'question_bloc.dart';

enum Status { initial, loading, success, error }

class QuestionState extends Equatable {
  final AllQuestionModel? allQuestionList;
  final Status status;

  const QuestionState({required this.allQuestionList, required this.status});

  @override
  List<Object?> get props => [allQuestionList, status];

  QuestionState copyWith({
    final AllQuestionModel? allQuestionList,
    final Status? status,
  }) {
    return QuestionState(
      allQuestionList: allQuestionList ?? this.allQuestionList,
      status: status ?? this.status,
    );
  }
}

final class QuestionInitial extends QuestionState {
  QuestionInitial() : super(allQuestionList: null, status: Status.initial);
}
