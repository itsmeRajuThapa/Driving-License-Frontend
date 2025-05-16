part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetAllQuestionList extends HomeEvent {
  final bool isRefresh;
  const GetAllQuestionList({this.isRefresh = true});
}
