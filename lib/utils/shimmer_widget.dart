import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 10.h),
            Row(
              children: [
                Container(
                  height: 220.h,
                  width: 190.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    //backgroundBlendMode: BlendMode.darken,
                    color: Colors.grey,
                  ),
                ),
                Spacer(),
                Container(
                  height: 220.h,
                  width: 190.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    //backgroundBlendMode: BlendMode.darken,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),
            Container(
              height: 42.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                //  scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 100.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        //backgroundBlendMode: BlendMode.darken,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
