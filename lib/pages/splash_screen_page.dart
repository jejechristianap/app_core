import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';

class SplashScreenPage extends StatefulWidget {
  final Widget content;
  final Widget nextPage;
  final Duration duration;

  const SplashScreenPage({
    super.key,
    required this.content,
    required this.nextPage,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<StatefulWidget> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      widget.duration,
      () {
        Navigation.pushReplacement(
          context: context,
          page: widget.nextPage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: widget.content,
    );
  }
}
