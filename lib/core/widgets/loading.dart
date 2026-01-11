import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool fullScreen;

  const AppLoading({
    Key? key,
    this.size = 40,
    this.color,
    this.message,
    this.fullScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loader = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 12),
          Text(
            message!,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (fullScreen) {
      return Scaffold(
        body: Center(child: loader),
      );
    }

    return Center(child: loader);
  }
}
