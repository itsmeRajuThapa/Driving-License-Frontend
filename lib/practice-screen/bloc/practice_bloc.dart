import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:driver/practice-screen/model/mock_qtn_model.dart';
import 'package:driver/practice-screen/practice_repo/practice_repo.dart';
import 'package:driver/services/api_handling/failure.dart' show Failure;
import 'package:equatable/equatable.dart';

part 'practice_event.dart';
part 'practice_state.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final PracticeRepo _repo = PracticeRepo();
  PracticeBloc() : super(PracticeInitial()) {
    on<GetAllPracticeQtnList>(_getAllPracticeQtnList);
    on<SubmitPracticeAnswers>(_onSubmitPracticeAnswers);
  }

  FutureOr<void> _getAllPracticeQtnList(
    GetAllPracticeQtnList event,
    Emitter<PracticeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final Either<dynamic, Failure> repo = await _repo.fetchpracticedata();

    repo.fold(
      (success) {
        final quizzes = success["data"]?["questions"] as List<dynamic>?;

        if (quizzes == null || quizzes.isEmpty) {
          emit(
            state.copyWith(
              status: Status.error,
              errorMessage: 'No questions available.',
            ),
          );
          return;
        }

        try {
          final allPracticeQuestionList =
              quizzes
                  .where((element) => element is Map<String, dynamic>)
                  .map((element) => MockQuestionModel.fromJson(element))
                  .toList();

          emit(
            state.copyWith(
              status: Status.success,
              allPracticeQuestionList: allPracticeQuestionList,
              timeLimit: success["data"]?["timeLimit"]?.toString() ?? '30 min',
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: Status.error,
              errorMessage: 'Failed to parse questions: $e',
            ),
          );
        }
      },
      (failure) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: failure.message ?? 'Failed to fetch questions.',
          ),
        );
      },
    );
  }

  FutureOr<void> _onSubmitPracticeAnswers(
    SubmitPracticeAnswers event,
    Emitter<PracticeState> emit,
  ) async {
    emit(state.copyWith(status: Status.submitting));

    final result = await _repo.submitanswer(event.responses);

    result.fold(
      (l) {
        final correct = l["data"]['correctAnswers'] as int? ?? 0;
        final score =
            double.tryParse(l["data"]['scorePercentage'].toString()) ?? 0;
              final attempt = l["data"]['totalQuestions'] as int? ?? 0;

        emit(
          state.copyWith(
            status: Status.submitted,
            correctAnswers: correct,
            scorePercentage: score,
            totalQuestions:attempt,
          ),
        );
      },
      (failure) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: failure.message ?? 'Failed to submit answers.',
          ),
        );
      },
    );
  }
}
