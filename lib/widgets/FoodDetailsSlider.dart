import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FoodDetailsSlider extends StatelessWidget {
  final String slideImage1;
  final String slideImage2;
  final String slideImage3;

  FoodDetailsSlider({
    Key? key,
    required this.slideImage1,
    required this.slideImage2,
    required this.slideImage3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
        items: [
          Image.asset(slideImage1, fit: BoxFit.cover),
          Image.asset(slideImage2, fit: BoxFit.cover),
          Image.asset(slideImage3, fit: BoxFit.cover),
        ],
      ),
    );
  }
}
