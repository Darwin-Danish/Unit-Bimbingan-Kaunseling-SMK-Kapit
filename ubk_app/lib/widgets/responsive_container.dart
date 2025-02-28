import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? contentBackgroundColor;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.contentBackgroundColor,
    this.maxWidth = 600, // Default max width similar to a large phone
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          color: contentBackgroundColor,
          width: double.infinity,
          child: padding != null 
              ? Padding(
                  padding: padding!,
                  child: child,
                )
              : child,
        ),
      ),
    );
  }
}