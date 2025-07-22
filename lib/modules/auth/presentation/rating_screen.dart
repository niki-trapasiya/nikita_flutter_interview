import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating'),
        backgroundColor: AppColors.primaryGradientEnd,
      ),
      body: Center(
        child: Text(
          'Rating Screen',
          style: TextStyle(fontSize: 22, color: AppColors.textPrimary),
        ),
      ),
    );
  }
} 