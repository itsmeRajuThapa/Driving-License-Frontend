part of 'practice_bloc.dart';

sealed class PracticeEvent extends Equatable {
  const PracticeEvent();

  @override
  List<Object> get props => [];
}

class GetAllPracticeQtnList extends PracticeEvent {
  const GetAllPracticeQtnList();
}

class SubmitPracticeAnswers extends PracticeEvent {
  final List<Map<String, String>> responses;

  const SubmitPracticeAnswers(this.responses);
}
