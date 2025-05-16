part of 'question_bloc.dart';

sealed class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class GettitleQuestionList extends QuestionEvent {
  final String title;
  const GettitleQuestionList({required this.title});
}
