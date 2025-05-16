part of 'home_bloc.dart';

enum Status { initial, loading, success, error }

class HomeState extends Equatable {
  final List<AllQuestionModel> allQuestionDataList;
  final Status status;

  const HomeState({required this.allQuestionDataList, required this.status});

  @override
  List<Object?> get props => [allQuestionDataList, status];

  HomeState copyWith({
    final List<AllQuestionModel>? allQuestionDataList,
    final Status? status,
  }) {
    return HomeState(
      allQuestionDataList: allQuestionDataList ?? this.allQuestionDataList,
      status: status ?? this.status,
    );
  }
}

final class HomeInitial extends HomeState {
   HomeInitial()
    : super(allQuestionDataList: [], status: Status.initial);
}
