import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:driver/home-screen/model/home_model.dart';
import 'package:driver/question-screen/question-repo/question-repo.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:equatable/equatable.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionRepo _repo = QuestionRepo();
  QuestionBloc() : super(QuestionInitial()) {
    on<GettitleQuestionList>(_gettitleQuestionList);
  }

  FutureOr<void> _gettitleQuestionList(
    GettitleQuestionList event,
    Emitter<QuestionState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    Either<dynamic, Failure> repo = await _repo.fetchquestiondata(
      title: event.title,
    );
    repo.fold(
      (l) {
        try {
          if (l == null || l['data'] == null || l['data']['quiz'] == null) {
            emit(state.copyWith(status: Status.error));
            return;
          }
          final allQuestionList = AllQuestionModel.fromJson(l['data']['quiz']);
          emit(
            state.copyWith(
              status: Status.success,
              allQuestionList: allQuestionList,
            ),
          );
        } catch (e) {
          emit(state.copyWith(status: Status.error));
        }
      },
      (r) {
        emit(state.copyWith(status: Status.error));
      },
    );
  }
}
