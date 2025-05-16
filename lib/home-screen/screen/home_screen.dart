import 'package:driver/home-screen/bloc/home_bloc.dart';
import 'package:driver/home-screen/model/home_model.dart';
import 'package:driver/home-screen/screen/drawer_screen.dart';
import 'package:driver/routes/route_name.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AllQuestionModel> allQuestionDataList = [];

  @override
  void initState() {
    super.initState();
    locator<HomeBloc>().add(GetAllQuestionList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepali Driving License App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: locator<HomeBloc>(),
        builder: (context, state) {
          if (state.status == Status.error) {
            return const Center(child: Text('Error.....'));
          } else if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == Status.success &&
              state.allQuestionDataList.isEmpty) {
            return const Center(child: Text("No Data Found"));
          } else if (state.status == Status.success &&
              state.allQuestionDataList.isNotEmpty) {
            allQuestionDataList = state.allQuestionDataList;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(color: Colors.green, height: 25, width: 4),
                      SizedBox(width: 20),
                      Text(
                        "Mock Exam",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().navigateTo(
                        Routes.practiceScreen,
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(5),
                      color: const Color.fromARGB(255, 248, 213, 213),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Practice Sample Question',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "25 Questions    ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  color: Colors.purple,
                                  height: 20,
                                  width: 2,
                                ),

                                Text(
                                  "    Time: 30 Minutes",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(color: Colors.green, height: 25, width: 4),
                      SizedBox(width: 20),
                      Text(
                        "All Question List",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      //  scrollDirection: Axis.horizontal,
                      itemCount: allQuestionDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        AllQuestionModel data = allQuestionDataList[index];
                        return InkWell(
                          onTap: () {
                            locator<NavigationService>().navigateTo(
                              Routes.questionScreen,
                              arguments: data.title,
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(5),
                            color: const Color.fromARGB(255, 248, 213, 213),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.title ?? '',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "${data.numberOfQuestions} Questions    ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.purple,
                                        height: 20,
                                        width: 2,
                                      ),

                                      Text(
                                        "    ${data.askableQuestions} will be asked",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
