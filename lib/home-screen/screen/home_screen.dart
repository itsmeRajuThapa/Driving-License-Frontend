import 'package:driver/home-screen/bloc/home_bloc.dart';
import 'package:driver/home-screen/model/home_model.dart';
import 'package:driver/home-screen/screen/drawer_screen.dart';
import 'package:driver/routes/route_name.dart';
import 'package:driver/services/navigation_service.dart';
import 'package:driver/services/service_locator.dart';
import 'package:driver/utils/back_to_exit.dart';
import 'package:driver/utils/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(title: const Text('Nepali Driving License App')),
      drawer: const CustomDrawer(),
      body: BackToExit(
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: locator<HomeBloc>(),
          builder: (context, state) {
            if (state.status == Status.error) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    locator<HomeBloc>().add(GetAllQuestionList());
                  },
                  child: Text("Refresh Again"),
                ),
              );
            } else if (state.status == Status.loading) {
              return const Center(child: HomePageShimmer());
            } else if (state.status == Status.success &&
                state.allQuestionDataList.isEmpty) {
              return const Center(child: Text("No Data Found"));
            } else if (state.status == Status.success &&
                state.allQuestionDataList.isNotEmpty) {
              allQuestionDataList = state.allQuestionDataList;

              return Padding(
                padding: EdgeInsets.all(14.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          color: Colors.green,
                          height: 25.h,
                          width: 4.w,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "Mock Exam",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            locator<NavigationService>().navigateTo(
                              Routes.practiceScreen,
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.all(5.sp),
                            child: Container(
                              padding: EdgeInsets.all(16.sp),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.asset(
                                      'assets/exam.png',
                                      fit: BoxFit.cover,
                                      height: 170.h,
                                      width: 150.w,
                                    ),
                                  ),
                                  Text(
                                    'Practice Question',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            locator<NavigationService>().navigateTo(
                              Routes.colorVisionScreen,
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.all(5.sp),
                            child: Container(
                              padding: EdgeInsets.all(16.sp),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.asset(
                                      'assets/images/74.png',
                                      fit: BoxFit.cover,
                                      height: 170.h,
                                      width: 154.w,
                                    ),
                                  ),
                                  Text(
                                    'Color Vision Test',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Container(
                          color: Colors.green,
                          height: 25.h,
                          width: 4.w,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "All Question List",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
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
                              margin: EdgeInsets.all(5.sp),
                              child: Container(
                                padding: EdgeInsets.all(15.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.title ?? '',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        Text(
                                          "${data.numberOfQuestions} Questions    ",
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          color: Colors.purple,
                                          height: 20.h,
                                          width: 2.5.w,
                                        ),

                                        Text(
                                          "    ${data.askableQuestions} will be asked",
                                          style: TextStyle(
                                            fontSize: 17.sp,
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
      ),
    );
  }
}
