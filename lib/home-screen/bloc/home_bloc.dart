import 'package:dartz/dartz.dart';
import 'package:driver/home-screen/home_repo/home_repo.dart';
import 'package:driver/home-screen/model/home_model.dart';
import 'package:driver/services/api_handling/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo _repo = HomeRepo();

  HomeBloc() : super(HomeInitial()) {
    on<GetAllQuestionList>(_getAllQuestionList);
  }

  void _getAllQuestionList(
    GetAllQuestionList event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    Either<dynamic, Failure> repo = await _repo.fetchdata();

    repo.fold(
      (l) {
        final quizzes = l["data"]["quizzes"];
       
        if (quizzes == null || quizzes.isEmpty) {
          emit(state.copyWith(status: Status.error));
          return;
        }
        List<AllQuestionModel> allquestionList = [];
        try {
          List<dynamic> respData = quizzes;
          for (var element in respData) {
            if (element is Map<String, dynamic>) {
              
              allquestionList.add(AllQuestionModel.fromJson(element));
            }
          }
          emit(
            state.copyWith(
              status: Status.success,
              allQuestionDataList: allquestionList,
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
