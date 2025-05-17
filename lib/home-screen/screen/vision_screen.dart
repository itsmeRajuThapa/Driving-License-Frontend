import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorVisionScreen extends StatelessWidget {
  ColorVisionScreen({super.key});
  final List<Map<String, String>> items = [
    {'image': 'assets/images/2.png', 'text': '2'},
    {'image': 'assets/images/4.jpg', 'text': '4'},
    {'image': 'assets/images/74.png', 'text': '74'},
    {'image': 'assets/images/5.png', 'text': '5'},
    {'image': 'assets/images/7.jpg', 'text': '7'},
    {'image': 'assets/images/57.jpg', 'text': '57'},
    {'image': 'assets/images/74.png', 'text': '74'},
    {'image': 'assets/images/35.jpg', 'text': '35'},
    {'image': 'assets/images/3.png', 'text': '3'},
    {'image': 'assets/images/8.jpg', 'text': '8'},
    {'image': 'assets/images/9.jpg', 'text': '9'},
    {'image': 'assets/images/15.jpg', 'text': '15'},
    {'image': 'assets/images/26.jpg', 'text': '26'},
    {'image': 'assets/images/38.jpg', 'text': '38'},
    {'image': 'assets/images/16.jpg', 'text': '16'},
    {'image': 'assets/images/57.jpg', 'text': '57'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Vision Test')),
      body: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Click on the image to see the answer",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.sp,
                  mainAxisSpacing: 10.sp,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(item['image']!, fit: BoxFit.cover),
                    ),
                    back: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Ans: ${item['text']!}",
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
